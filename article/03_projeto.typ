#import "conf.typ": sourced_image
// NOTE: No TCC3 trocar os tempos verbais dessa seção toda!

= PROJETO

A etapa mais fundamental do projeto é a implementação dos algoritmos e da API de resiliência, dado o contexto de real time, cuidados devem ser tomados no quesito da performance e uso de memória (que pode indiretamente degradar a CPU na presença de erros de cache).

A arquitetura será primariamente orientada à passagem de mensagens, pois permite uma generalização para mecanismos de I/O assíncrono e possível distribuição da arquitetura, permite também um desacoplamento  entre a lógica de detecção e transporte das mensagens, potencialmente permitindo otimizações futuras na diminuição da ociosidade dos núcleos. O estilo de implementação orientado à mensagens naturalmente oferece um custo adicional em termos de latência quando comparado à alternativas puramente baseadas em compartilhamento de memória, apesar deste custo poder ser amortizado com a utilização de filas concorrentes bem implementadas e com a criação de um perfil de uso para melhor ajuste do sistema.

== Visão Geral e Premissas

=== Visão Geral

// TODO: Mudar o diagrama de ordem, talvez deixar o paragrafo menos denso
#figure(caption: "Visão Geral do projeto", image("assets/visao_geral.png"))

A análise final será realizada com os mecanismos de tolerância já implementados no FreeRTOS, serão executados 2 programas de exemplo com diferentes combinações de técnicas, métricas do uso médio de CPU, memória e número de falhas detectadas e por quais técnicas serão todas armazenadas em um segmento de memória previamente definido, será tomado um cuidado adicional para não injetar falhas neste segmento, ou alterar endereços de memória para que apontem para este segmento, pois será utilizado um dump da imagem com as métricas para a análise e escrita do resto da monografia.

O PC (host) será responsável por orquestrar o processo de injeção, será utilizado o ST-Link para manipular a memória e registradores do microcontrolador, a interface de uso será feita pela sessão de GDB exposta pelo driver do ST-Link e pela IDE STM32Cube. As técnicas representadas no diagrama são para propósito ilustrativo da arquitetura, e não necessariamente correspondem a segmentos de memória dedicados. O uso de Asserts é realizado no código das tasks ativas, mas não existe nenhum "módulo de asserts", dado que esta técnica é profundamente contextual.

=== Premissas

// TODO: Termos em ingles
Será partido do ponto que ao menos o processador que executa o scheduler terá registradores de controle (Stack Pointer, Program Counter, Return Address) que sejam capazes de mascarar falhas. Apesar de ser possível executar os algoritmos reforçados com análise de fluxo do programa e adicionar redundância aos registradores, isso adiciona um grau a mais de complexidade que foge do escopo do trabalho, e, como mencionado na seção de *trabalhos relacionados*, a memória fora do banco de registradores pode ser 2 ordens de magnitude mais sensível à eventos disruptivos @ReliabilityArmCortexUnderHeavyIons.

Portanto, todos os testes subsequentes assumirão ao menos uma quantia mínima de tolerância do núcleo monitor, tendo foco na detecção de falhas de memória, passagem de mensagens e resultados dos co-processadores.

Com o fim de reduzir o tamanho do executável e manter o fluxo de execução mais previsível não será utilizado mecanismo de exceção com stack unwinding ou RTTI (Runtime Type Information), ao invés, erros de validação devem ser cuidados explicitamente com valores ou através de callbacks.

Necessariamente, é preciso também presumir que testes sintéticos possam ao menos aproximar a performance do mundo real, ou ao menos prever o pior caso possível com grau razoável de acurácia. O uso de testes sintéticos não deve ser um substituto para a medição em uma aplicação real, porém, uma bateria de testes com injeção artificial de falhas pode ser utilizada para verificar as tendências e overheads relativos introduzidos, mesmo que não necessariamente reflitam as medidas absolutas do produto final.

Portanto, será assumido que os resultados extraídos de injeção de falhas artificiais, apesar de menos condizentes com os valores absolutos de uma aplicação e não sendo substitutos adequados na fase de aprovação de um produto real, são ao menos capazes para realizar uma análise quanto ao overhead proporcional introduzido, e devido à sua facilidade de realização e profundidade de inspeção possível, serão priorizados inicialmente neste projeto.
== Metodologia

=== Métodos

// TODO: Trocar a ordem, sumarizar, mais diagramas, melhorar coesao

Serão utilizadas técnicas de detecção e tolerância à falhas implementadas em software, duas das técnicas são diretamente associadas à interface de tarefa, uma serve como tarefa supervisora e as outras duas servem como suporte. Os detalhas específicos de cada técnica serão abordados na seção de *Algoritmos e Técnicas*.

Para executar a injeção lógica em software será utilizado um ambiente virtual (QEMU) emulando a mesma arquitetura de processador juntamente com o debugger GDB e funções de injeção implementadas diretamente nos programas utilizando callbacks para disparar uma falha, a emissão de falhas ocorrerá periodicamente de forma parametrizada. A injeção lógica em software não é o objetivo final do trabalho mas serve como uma validação prévia durante o processo de desenvolvimento assim como uma possível contingência.

A injeção lógica em hardware é realizada com ferramentas do próprio fabricante do microcontrolador (detalhas na seção seguinte), o fluxo geral da injeção consiste em carregar o binário executável (no formato ELF) no micro controlador utilizando o ST-LINK, após isso, o programa será iniciado e será feita uma injeção de falhas via sessão do depurador GDB associado ao link.

A coleta de métricas é realizada com os mecanismos de profiling do sistema FreeRTOS juntamente com contadores de incremento atômico, o tempo de execução das tasks, seu espaço de memória utilizado e o número de falhas detectadas (e causadas) será armazenado em uma estrutura singleton que residirá em um segmento de memória que é deliberadamente isento de falhas, servindo similarmente à uma "caixa preta" do sistema.

Para simular uma carga de trabalho mais condizente com a aplicações reais, serão utilizados 2 programas de exemplo, um processador de sinal digital assíncrono e um programa que realiza uma convolução bidimensional, estes programas são executados e expostos à falhas que espera-se que os mecanismos de tolerância sejam capazes de detectar. Detalhamento destes programas pode ser encontrado no capítulo do *Plano de Verificação*.

Visando a reutilização de código e abstração, será utilizada uma interface que generaliza um objeto de tarefa, como um objeto que realiza despache dinâmico necessita de uma tabela de despache virtual (V-Table), é necessário tomar cuidado adicional pois a própria tabela pode ser sujeita à falhas. Será aplicado uma replicação simples dos ponteiros de função da V-Table, com o custo de overhead de 2 comparações por chamada de método. Espera-se que este overhead não será significativo pois os métodos da interface não são chamados com uma frequência alta.

=== Materiais

// TODO: Trocar a ordem, sumarizar, mais diagramas, melhorar coesao
// deixar um pouco mais segmentado e com conexoes entre os topicos, aqui e em metodos.
// referenciar as figuras

Será utilizada a linguagem C++ (Versão 14 ou acima) com o compilador GCC (ou
Clang), o alvo principal do trabalho será um microcontrolador (STM32F103C8T6
"Bluepill") 32-bits da arquitetura ARMv7-M.

#sourced_image(
  caption: [Diagrama do STM32F103C8T6 ("Bluepill")],
  source: "STMBoardProductPage",
  image("assets/stm32_bluepill.png"))

Para a injeção de falhas será utilizado um depurador como o GDB em conjunto com
uma ferramenta de depuração do hardware (ST-LINK), a comunição do ST-LINK é
feita via USB com o host e via JTAG com o microcontrolador alvo, também será
usado em conjunto uma IDE fornecida pelo mesmo fabricante, a STM32Cube IDE.

#sourced_image(
  caption: [ST-LINK/V2],
  source: "STLinkProductPage",
  image("assets/st_link.png"))

#sourced_image(
  caption: [STMCube IDE],
  source: "STMCubeProductPage",
  image("assets/stmcube_ide.png"))

Durante a fase de desenvolvimento dos algoritmos será utilizado o QEMU
juntamente com as ferramentas anteriormente citadas, assim como
AddressSanitizer e ThreadSanitizer para auxiliar na detecção de erros mais cedo
durante o desenvolvimento.

O sistema operacional de tempo real escolhido foi o FreeRTOS, por ser
extensivamente testado e documentado e prover um escalonador totalmente
preemptivo com um custo espacial relativamente pequeno, além disso, os
contribuidores do FreeRTOS mantém uma lista grande de ports para diferentes
arquiteturas e controladores, facilitando drasticamente o trabalho ao não ter
que criar uma HAL do zero.

== Análise de Requisitos

// TODO: Refazer essa porra toda
Após a seleção dos objetivos, foram coletados os requisitos funcionais e não funcionais, que são apresentados nos quadros seguintes.

#figure(caption: [Requisitos funcionais], table(
	columns: (auto, 1fr),

	table.header([*Requisito*], [*Descrição*]),

	[*RF 1*], [Todos os algoritmos da seção *Algoritmos e Técnicas* implementados],
	[*RF 2*], [Implementação da interface para execução de tarefas com TF],
	[*RF 3*], [Programa de exemplo implementado com diferentes técnicas e executado],
	[*RF 4*], [Implementação da interface para as tarefas do programa de exemplo],
	[*RF 5*], [Injeção de falhas lógicas em software (callbacks de injeção)],
	[*RF 6*], [Injeção de falhas lógicas em hardware (ST-LINK + GDB)],
	[*RF 7*], [Funções de medição e observabilidade das métricas: uso de CPU, uso de memória, falhas injetadas, falhas detectadas, quantia de tasks instanciadas],
	[*RF 8*], [Interface de resiliência precisa ter uso de memória com limite superior determinado em tempo de compilação ou imediatamente no início do programa],
))

#figure(caption: [Requisitos Não-funcionais], table(
	columns: (auto, 1fr),

	table.header([*Requisito*], [*Descrição*]),
	[*RNF 1*], [Trabalho deve ser realizado em C++ (versão 14 ou acima)],
	[*RNF 2*], [Deve ser compatível com arquitetura ARMv7-M ou ARMv8-M],
	[*RNF 3*], [Deve ser capaz de rodar em um microcontrolador utilizando um HAL (Hardware abstraction layer), seja do RTOS ou de terceiros.],
	[*RNF 4*], [Precisa fazer uso de múltiplos núcleos quando presentes],
	[*RNF 5*], [Deve ser capaz de executar em cima do escalonador do FreeRTOS ou outro RTOS preemptivo sem mudanças significativas],
	[*RNF 6*], [V-Tables das interfaces devem possuir redundância para evitar pulos corrompidos ao chamar métodos],
))

=== Programas exemplos

Serão utilizados 2 programas de teste durante a execução das falhas, um
realizará um filtro passa-banda com no domínio da frequência (transformada de
Fourier) e outro aplicará uma convolução bidimensional.

A escolha da primeira aplicação serve primariamente testar uma
operação que dependa de múltiplos acessos e modificações à memória e que possa
demonstrar capacidades de processamento assíncronas (padrão
produtor/consumidor), que são particularmente importantes ao se lidar com
múltiplas interrupções causadas por timers ou IO.

Já o segundo programa, de natureza mais simples, visa causar alto estresse em
termos de loads,juntamente com muitas operações aritméticas, mas com menos
ênfase em comunicação entre tarefas. O objetivo é testar o impacto das técnicas
em um caso mais extremo que requer muito processamento.

==== Processador de Sinal digital

A aplicação recebe um vetor de valores de forma periódica simulando um sensor
externo, uma tarefa receberá o lote e realizará uma transformada rápida de
Fourier, após concluir, enviará o payload para outra tarefa que aplica um
filtro passa-banda, que por sua vez, envia o payload para uma última tarefa que
realiza a FFT inversa e despeja os resultados para depuração.

#figure(caption: "Resumo do fluxo do programa exemplo com FFT",
  image("assets/diagrama_sequencia_fft.png", height: 300pt))

==== Convolução Bidimensional

O segundo programa de teste consiste em aplicar uma convolução 2D sobre uma imagem providenciada como input, será aplicado um kernel de blur gaussiano de ordem $N$, onde $N$ será testado com os valores: ${3, 5, 7}$ em uma imagem de dimensões arbitrárias (mas com limite superior de tamanho). O objetivo deste programa é testar situações com alto estresse de memória e processamento, o processo de convolução envolve operações de janelamento com multiplicações e adições, devido à quantidade maior de dados, espera-se que esse algoritmo represente algo mais próximo de um pior-caso em termos de acessos à memória.

#figure(caption: "Fluxo da convolução Bidimensional com redundância de tarefas",
  image("assets/convolucao_2d.png", height: 450pt))

=== Algoritmos e Técnicas

- CRC: Será implementado o CRC32 para a checagem do payload de mensagens.

- Heartbeat Signal: Um sinal periódico será enviado para a tarefa em
  paralelo, a tarefa necessita responder ao sinal dentro de uma deadline pré determinada com o contador do sinal incrementado.

- Redundância Modular: Uma mesma task será disparada diversas vezes, em sua
  conclusão, será realizado um consenso dentre as respostas.

- Replicação Temporal: Uma mesma task será re-executada N-vezes, tendo suas N
  respostas catalogadas e verificadas, a resposta correta será decidida por
  consenso.

- Asserts: Serão utilizados asserts para checar invariantes específicas ao
  algoritmo, especialmente na entrada e na saída das funções.

=== Interface

Uma tarefa (task) é uma unidade de trabalho com espaço de stack dedicado e uma
deadline de conclusão.

// TODO: Trocar por desenho
O "corpo" de um tarefa é simplesmente a função que executa após a task ter sido
inicializada. Será utilizado uma assinatura simples permitindo a passagem de um
parâmetro opaco por referência. Este parâmetro pode ser o argumento primordial
da task ou um contexto de execução. Tarefas são expressas na forma da interface
`FT_Task`, que contém métodos que podem ser implementados de acordo com a
necessidade da tarefa. O fornecimento de uma interface genérica, apesar de
introduzir um pouco de overhead com a indireção por meio de tabela de despache
dinâmico permite maior flexibilidade.


#figure(caption: "Mensagens e IDs", [
```cpp
using Time_Point = size_t; // Deve ser suficiente para conter o valor de um timer monotônico

using Task_Id = unsigned int;

template<typename Payload>
struct FT_Message {
    uint32_t   check_value;
    Task_Id    sender;
    Task_Id    receiver;
    Time_Point sent_at;
    Time_Point deadline; // 0 - Sem deadline de entrega
    Payload    payload;
};
```
])

// TODO: Termos em ingles
Uma mensagem é um wrapper ao redor um payload qualquer, o ordenamento dos tipos
aqui é importante, o payload _precisa_ ser o último membro para serialização de
estruturas de tamanho arbitrário. O valor `check_value` é o valor de checagem
do CRC que será utilizado para detectar corrupções e é computado com base em
todos os outros campos. Os campos `sender` e `receiver` servem a função de
remetente e destinatário, mesmo nos casos em que há apenas um destinatário ou
remetente, a informação adicional serve como uma camada extra que pode ser
assegurada com asserts (e também é representada no valor de checagem). Já os
pontos de tempo servem para definir uma deadline de entrega, caso exista.

// TODO: Trocar por desenho
#figure(caption: "Interface básica de uma tarefa")[
```cpp
using FT_Handler = bool (*)(FT_Task*);

struct FT_Task_Info {
	Task_Id    id;
	FT_Handler handler;
	Time_Point started_at;
	Time_Point deadline; // 0 - Sem deadline
};

struct FT_Task {
	virtual Task_Id execute(void* param) = 0;
	virtual void attach_heartbeat_watchdog(uint32_t* sequence_addr, Time_Point interval) = 0;
	virtual FT_Task_Info info() = 0;
};
```]

Uma tarefa é uma unidade de execução com um espaço de pilha dedicado, mas que
não necessariamente está em um espaço de memória diferente, um tipo tarefa pode
ser implementado de qualquer forma contanto que conforme com a interface
`FT_Task` que define um método para inicialização da task e outro para ler seu
status. A interface impõe pouca restrição sobre seu modelo exato de execução, o
objetivo desta escolha é primariamente facilitar a implementação das técnicas
de maneira independente, ao manter uma abstração pequena, se sacrifica um grau
de garantias em troca de uma implementação simples. Dado que tasks não serão
criadas e destruídas numa frequência alta, entende-se que o overhead de uma
indireção de chamada virtual não será significativo. Manter a interface simples
também facilita sua transformação em uma V-Table com redundância.

A função de tipo `FT_Handler` é invocada imediatamente após a detecção de uma
falha na tarefa, ela não é parte da interface diretamente pois tarefas podem
compartilhar um mesmo handler, e para facilitar compor múltiplos handlers,
estes são mantidos desacoplados da interface.

== Plano de Verificação

=== Testes Unitários

Para validar a maioria dos requisitos funcionais serão utilizados de testes
unitários, os testes são considerados como um artefato do trabalho e serão
distribuídos juntamente ao mesmo. A validação, primariamente das técnicas
implementadas, serão feitas da seguinte forma:

*CRC*: Será utilizado como referência uma implementação correta do algoritmo,
payloads com resultados já conhecidos serão comparados para garantir a
implementação correta.

*Heartbeat Signal*: Um cenário reduzido de apenas 2 tarefas com um
canal de comunicação será utilizado para testar essa técnica, o algoritmo deve
ser capaz de rodar por $N$ vezes e capturar $F$ falhas por timeouts. $N$ e $F$
serão especificados como parâmetros do teste.

*Redundância Modular*: Uma tarefa será disparada $R$ vezes de forma concorrente
para executar, durante o teste serão deliberadamente incluídos falhas no código
fonte para validar o algoritmo de consenso no final. Será utilizado $R = 3$,
mas é possível que qualquer $R$ ímpar positivo seja usado. O número de
execuções e probabilidade de falha serão parâmetros do teste.

*Replicação temporal*: Uma tarefa será disparada $R$ vezes de forma sequencial
para executar, durante o teste serão deliberadamente incluídos falhas no código
fonte para validar o algoritmo de consenso no final. Será utilizado $R = 3$
para paridade com o algoritmo de redundância modular, mas é possível que
qualquer $R$ positivo seja usado. O número de execuções e probabilidade de
falha serão parâmetros do teste.

*Asserts*: Apenas será testado um exemplo trivial para garantir o disparo da
rotina de tratamento caso o assert encontre uma condição falsa, como asserts
são extremamente simples e dependem do contexto lógico da função em que estão
inseridos, não há como realizar um teste "genérico" externo à aplicação geral.

*Fila de Mensagens*: Não é uma técnica de tolerância, mas será testada offline
com múltiplas threads se comunicando e causando estresse de memória na fila. A
fila MPMC escolhida é baseada em uma implementação lockless do algoritmo. @BoundedMPMCQueue

*Programa exemplo*: Será testado em um ambiente hosted primeiro a implementação
dos componentes complexos (FFT, convolução, passa-banda), sendo comparados com
resultados implementações já bem estabelecidas.

=== Outros testes

Serão realizados testes ponta a ponta com os dois programas de exemplo para
garantir sua validade lógica antes de ser realizada sua execução definitiva. As
técnicas de detecção também passarão por teste de integração juntamente ao
teste dos programas com injeção de falhas em software. O objetivo é produzir
uma exemplo prova de conceito que já contém grande parte da implementação, para
que erros inesperados e mudanças de design sejam feitas anteriormente dos
testes com o microcontrolador para diminuir a quantidade de fricção na análise
final (mas mantendo ainda um limite superior de uso de recursos). Todos os
testes são artefatos que serão distribuídos juntamente com o trabalho.

=== Campanha de Injeção de Falhas

Para testar a injeção de falhas serão utilizados mecanismos lógicos em software
e em hardware com com o auxílio do depurador STLink. As falhas serão de
natureza transiente e focarão no segmento de memória com leitura e escrita.

As falhas injetadas serão principalmente upsets de memória onde $N$ bytes a
partir de um endereço base são escolhidos e escritos com dados pseudo
aleatórios ou zeros, as regiões de memória escolhidas serão o segmento estático
com escrita, o stack das tarefas e registradores de propósito geral. Os
programas exemplo serão executados por um número fixo de rounds (e.x: 200) e
terão suas métricas coletadas até o final dos rounds ou caso os erros
cumulativos causem um reset total do sistema.

Falhas detectadas serão armazenadas com contadores atômicos, com um contador
dedicado para cada tipo de técnica. A região de coleta das métricas será
reservada previamente na seção estática da imagem do executável e será isenta
de falhas. Um dump da imagem será extraído e os contadores e métricas
deserializados no host para análise.

#figure(caption: [Combinações de técnicas utilizadas], table(
  columns: (auto, auto, auto, auto, auto, 1fr),
  // column-gutter: (auto, 4pt, auto),
  table.header([*Comb.*], [*Reexecução*], [*Redundância modular*], [*Heartbeat Signal*], [*CRC*], [*Asserts*]), 
  "1", "-","-","-","-","-",
  "2", "-","-","-","✓","✓",
  "3", "✓","-","-","✓","✓",
  "4", "✓","-","✓","✓","✓",
  "5", "-","✓","-","✓","✓",
  "6", "-","✓","✓","✓","✓",
  // "7", "✓","✓","✓","✓","✓",
))

A combinação 1 é apenas um grupo controle, para checar a execução sem
tolerância alguma, já a combinação 2 visa comparar com as técnicas de
tolerância que não envolvem modificação do processo de execução da task. As
combinações 3 à 6  visam comparar Reexecução e Redundância modular, com e sem
Heartbeat Signals (que incorrem em uma task adicional). Asserts e CRCs serão
mantidos ativos em todas as execuções por 2 razões principais: Asserts serão
utilizados para validar as chamadas virtuais da interface, e CRCs tornam falhas
na transmissão de mensagens detectáveis, não seria proveitoso realizar passagem
de mensagens para os Heartbeat Signals se as mensagens por si só não são
confiáveis.

==== Injeção Lógica com Software

// TODO: Diagrama do fluxo de injecao, separar diagrama das metricas?

Será criado uma task com um "micro heap" associado à mesma, a task executará de
forma paralela à todas as outras, a cada ciclo de preempção, a task injetora
acessa sua fila de candidatos e invoca um callback associado para causar N
bytes de corrupção de memória. É importante notar que por consistência, será
necessário "fixar" esta tarefa monitora em um núcleo. Como complemento, será
introduzido uma lista de injetores de falhas que as tasks podem invocar,
primariamente para testes.

A escolha da injeção lógica com software permite que já sejam feitos testes
preliminares das técnicas durante o desenvolvimento, possivelmente mitigando
certos erros de design. Uma outra vantagem é que será possível
reutilizar parte da funcionalidade da geração de injeções e upsets para
realizar testes com o depurador de hardware.

#figure(caption: "Rascunho da estrutura de métricas", ```cpp
#include <atomic>

using AtomicInt = std::atomic<int32_t>;

struct Fault_Metrics {
    AtomicInt assertion_counter;
    AtomicInt watchdog_counter;
    AtomicInt crc_counter;
    AtomicInt modular_redundancy_consensus_checks;
    AtomicInt reexecution_consensus_check;
};
```)

==== Injeção Lógica com Hardware
// TODO: Diagrama do fluxo de injecao

Utilizando do depurador dedicado do microcontrolador (ST-Link), serão injetadas
as mesmas falhas, com exceção dos endereços para a coleta de métricas, será
utilizada uma sessão do depurador GDB (GNU Debugger) que é fornecida pelo
ST-Link para executar os comandos remotamente, para automatizar a injeção assim
como na versão lógica baseada em software, será emitido a lista de comandos
para o depurador executar com um programa externo, que pode reutilizar uma
quantia significativa da lógica de geração em software.

// TODO: Botar diagrama aqui do processo basico

== Análise de riscos

O trabalho é de risco baixo, dado que constrói em cima de fundações técnicas previamente exploradas, porém dentro dos principais riscos que possam alterar ou causar problemas durante a realização encontram-se:

#figure(caption: [Análise de riscos], table(
	columns: (auto,) * 5,
	// column-gutter: (auto, 4pt, auto),
	table.header([*Risco*], [*Probabilidade*], [*Impacto*], [*Gatilho*], [*Contingência*]),
	[Funcionalidades e API do RTOS é incompatível com a interface proposta pelo trabalho.], [Baixo], [Alto], [Implementar interface no RTOS], [Utilizar outro RTOS, modificar o FreeRTOS, adaptar a interface],

	[Problemas para injetar falhas com depurador em hardware], [Baixa], [Alto], [Realizar injeção no microcontrolador], [Utilizar de outro depurador, depender de falhas lógicas em software como última alternativa],

	[Não conseguir coletar métricas de performance com profiler do FreeRTOS], [Baixa], [Médio], [Teste em microcontrolador ou ambiente virtualizado], [Inserir pontos de medição manualmente],
))

// TODO: Deixar mais refinado, apos ajeitar o resto
=== Cronograma para o TCC3

#set par(justify: false, leading: 0.5em)
#figure(caption: "Cronograma para o TCC3", table(
  columns: (1fr,) + (auto,) * 6,
  table.header([*Atividade*], [*07/2025*], [*08/2025*], [*09/2025*], [*10/2025*], [*11/2025*], [*12/2025*]),
  [Escrita da Monografia],                           [`XXXX`], [`XXXX`], [`XXXX`], [`XXXX`],  [`XXXX`], [`X___`],
  [Implementação dos Algoritmos],                    [`XXXX`], [`XX__`], [`____`], [`____`],  [`____`], [`____`],
  [Testes dos Algoritmos],                           [`XXXX`], [`XX__`], [`____`], [`____`],  [`____`], [`____`],
  [Implementação dos Programas Exemplo],             [`____`], [`__XX`], [`XXX_`], [`____`],  [`____`], [`____`],
  [Teste dos Programas Exemplo],                     [`____`], [`__XX`], [`XXX_`], [`____`],  [`____`], [`____`],
  [Implementação da Injeção com Software],           [`____`], [`____`], [`XXXX`], [`____`],  [`____`], [`____`],
  [Implementação da Injeção com Hardware],           [`____`], [`____`], [`__XX`], [`XXX_`],  [`____`], [`____`],
  [Execução microcontrolador e coleta das métricas], [`____`], [`____`], [`____`], [`__XX`],  [`XXXX`], [`____`],
  [Revisão Textual],                                 [`____`], [`____`], [`____`], [`____`],  [`__XX`], [`XXXX`],
))

