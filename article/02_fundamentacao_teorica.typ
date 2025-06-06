= FUNDAMENTAÇÃO TEÓRICA

== Falhas e Tolerância

Uma _falha_ pode ser compreendida como um defeito fora do controle do sistema
que pode provocar comportamento que resulta degradação na sua qualidade de
serviço neste caso, chamado "erro", seja ao afetar a validade dos resultados ou
com uma degradação na forma de aumento de latência. @FaultTolerantSystems
Falhas podem ser classificadas em 3 grupos principais quanto ao seu padrão de
ocorrência:

- Falhas *Transientes*: Ocorrem aleatoriamente e possuem um impacto temporário.

- Falhas *Intermitentes*: Assim como as transientes possuem impacto temporário,
  porém re-ocorrem periodicamente.

- Falhas *Permanentes*: Causam uma degradação permanente no sistema da qual não
  pode ser recuperada, potencialmente necessitando de intervenção externa.

Existem diversas fontes de falhas que podem afetar um sistema, exemplos
incluem: Radiação ionizante, Interferência Eletromagnética, Harmônicas, Impacto
Físico, Oscilação elétrica (picos de tensão e/ou corrente).

Para que o sistema possa ser _Tolerante à Falhas_, isto é, ser capaz de manter
uma qualidade de serviço aceitável mesmo na presença de falhas são necessários
2 principais mecanismos:

1. *Detecção de Falhas*: Capacidade de perceber a ocorrência de uma falha e
  executar a rotina de tratamento. Métodos comuns de detecção incluem: Bits de
  paridade, Funções hash, Sinais heartbeat e Limites de tempo (timeouts ou
  deadlines).

2. *Tratamento de Falhas*: Capacidade de reagir as falhas, com uma correção,
  re-execução ou rotina de mitigação. Falhas permanentes podem necessitar de um
  desligamento gracioso do sistema ou reorganização para manter o máximo de
  qualidade de serviço possível.

// TODO: Citar mais algum livro aqui?
A detecção e o tratamento podem ser implementados em hardware ou em software,
implementações em hardware conseguem fazer garantias físicas mais fortes com
melhor revestimento e redundância implementada diretamente no circuito, e
prover transparência de execução para o programador, a desvantagem é custo
elevado de espaço no silício possível degradação de performance geral e menor
flexibilidade. O processo de tornar o design e a implementação de um hardware
com estas características é chamado de "hardening".

// TODO: Mencionar NASA fazendo live patching
Implementações em software não são capazes de fornecer todas as garantias
fortes do hardware, em contrapartida, não ocupam espaço extra no chip e são
mais flexíveis, com software é possível implementar lógica de detecção
recuperação e estruturas de dados mais complexas, e até mesmo realizar
atualizações remotas com o sistema ativo (live patching).

// TODO: Citar paper de solucoes hybridas
Para que um sistema possa ser resiliente à falhas, ambas soluções de hardware e
software precisam ser consideradas, é possível utilizar hardware com
hardening para um núcleo que realiza atividades críticas, e delegar núcleos
menos protegidos para atividades em que o tratamento em software é suficiente.
Balancear a troca de espaço em chip, uso de memória, flexibilidade de
implementação, tempo de execução, vazão de dados e garantias de transparência é
indispensável para a criação de um sistema que seja resiliente à falhas e que
forneça uma boa qualidade de serviço pelo menor custo possível.

== Mecanismos de Detecção

// TODO: Ctiar livro, wikipedia etc.
Os mecanismos de detecção, permitem que um sistema detecte uma inconsistência
em seus dados, causada por falha externa ou por erro lógico de outra parte no
caso de sistemas distribuídos. Os mecanismos de detecção são essenciais para a
tolerância à falhas. Ao detectar uma falha o sistema deve tomar uma ação
corretiva para o tratamento da falha, mecanismos de tratamento serão abordados
posteriormente.

=== CRC (Cyclic Redundancy Check)

// TODO: Citar livro
Os CRCs são códigos de detecção de erro comumente utilizados em redes de
computador e armazenamento não volátil para detectar falhas. Para cada segmento
de dado é concatenado um valor (denominado "check value" ou simplesmente o
valor CRC) que é calculado com base no resto da divisão de um polinômio
previamente acordado entre remetente e destinatário (chamado de "polinômio
gerador").

Ao receber o segmento, o receptor calcula seu próprio valor CRC com base nos
dados do segmento (sem incluir o CRC do destinatário), caso ocorra diferença
entre os CRCs isso indica a ocorrência de um erro. CRCs são comumente
utilizados devido à serem simples de implementar, ocuparem pouco espaço
adicional no segmento e serem resilientes à "burst errors", falhas
transientes que alteram uma região de bits próximos.

=== Heartbeat signals

// TODO: Citar livro e talvez aquele artigo de survey
É possível determinar se uma falha ocorreu com um nó de execução através de um
critério temporal, os sinais de heartbeat ("batimento cardíaco") são sinais
periódicos para garantir se um nó computacional está ativo. Basta enviar um
sinal simples e verificar se uma resposta correta chega em um tempo pré
determinado. Sinais heartbeat são baratos porém não garantem uma
detecção ou correção de erro mais granular, portanto são usados como um
complemento para detectar falhas de forma concorrente a outros métodos mais
robustos.

O custo de memória de um sinal heartbeat tende a ser pequeno, porém possui o
custo temporal de tolerância limite no pior caso e o custo da viagem ida e
volta no melhor caso. Este método é aplicado em datacenters, também chamado de
"health signal" ou "health check", o sinal e sua resposta desejada podem conter
outros metadados para análise de falhas, caso desejado. 

Também é possível usar os próprios prazos de execução como um mecanismo de
detecção, um timer pode ser utilizado para alertar prematuramente a um erro que causou
um aumento inesperado no tempo de uma tarefa. @FaultTolerantSystems

=== Asserts

A utilização de asserts é um mecanismo simples que é particularmente útil, um
assert trata-se de checar se uma condição é verdadeira, caso não seja, o
programa é interrompido e entra um estado de pânico. Utilizar asserts
automáticos na entrada e saída de funções é denominado pré/pós-condições.
Asserts não previnem erros do hardware ou geram reexecuções, mas tratam-se de
um mecanismo de uso extremamente fácil que pode ser inserido pelos
desenvolvedores para detectar falhas de design cedo, o uso de asserts podem
detectar um defeito externo, mas por serem mecanismos exclusivamente de fluxo
de controle, não são muito robustos em suas garantias, mas ainda assim, seu
custo baixo e fácil inserção/deleção os fazem um mecanismo que não deve ser
ignorado @PowerOf10Rules.

== Mecanismos de Tratamento

Uma vez que uma falha tenha sido detectada o sistema precisa *tratar* a falha o
mais rápido possível para manter a qualidade de serviço, alguns mecanismos de
detecção também fornecem a possibilidade de correção dos dados, como é o caso
dos códigos Reed-Solomon, nestes casos, fica à critério da aplicação se a
correção deve ser tentada ou outro tratamento deve ser usado.

=== Redundância

// TODO: Citar survey e alguma coisa do isosimov
Adicionar redundância ao sistema é uma das formas mais intuitivas e mais
antigas de aumentar a tolerância à falhas, a probabilidade de N falhas
transientes ocorrendo simultaneamente em um sistema é mais baixa do que a
probabilidade de apenas 1 falha.

Uma técnica de redundância comum é o uso de TMR (Triple Modular Redundancy)
onde essencialmente a tarefa é executada 3 vezes em paralelo, e uma porta de
consenso utiliza a resposta gerada por pelo menos 2 das unidades. O uso de TMR
é elegante em sua simplicidade e consegue atingir um bom grau de resiliência,
porém com o custo adicional de triplicar a superfície.

Sistemas distribuídos também podem aproveitar de sua redundância natural por
serem sistemas com múltiplos nós computacionais, falhas transientes em um nó
podem ser propagadas e no caso de falhas permanentes em um nó, os outros podem
suplantar a execução de suas tarefas mantendo a qualidade média de serviço, o
uso de sistemas capazes de auto reparo é vital para a existência de
telecomunicação em larga escala e computação em nuvem.

=== Re-execução

// TODO: Citar isosimov ou outro
Re-executar uma tarefa é uma outra forma simples de recuperar-se de uma falha,
a probabilidade de *k* falhas intermitentes ocorrem em sequência é menor do que
a probabilidade de apenas ocorrer *k - 1* vezes no intervalo de execução. Ao
re-executar, espera-se que a falha não ocorra novamente na N-ésima tentativa.

Portanto, é sacrificado um tempo maior de execução caso a falha ocorra, em
troca de um tempo menor de execução médio sem necessitar de componentes extras.
Em contraste com a técnica de redundância tripla, é possível entender que a
redundância tripla ou "tradicional", depende de uma resiliência "espacial" (É
improvável que uma falha ocorra em vários lugares ao mesmo tempo), enquanto a
re-execução depende de uma resiliência "temporal" (É improvável que múltiplas
falhas ocorram repetidamente em *N* execuções)

=== Correção de Erro

// TODO: Citar alguem aqui
Existem também algoritmos que permitem detectar e corrigir erros dentro de um
payload, em troca de um custo de espaço e tempo para a detecção, dentro da
família de algoritmos que possibilitam detecção e correção, são encontrados os
códigos como os de: Reed-Solomon, Turbo Codes, LDPCs.

Este trabalho não abordará algoritmos de correção de forma aprofundada pois
foge do escopo de foco nas técnicas de escalonamento (execução) e detecção, mas
se trata de um tópico importante que complementa qualquer implementação de
sistemas resilientes particularmente no processo de envio e recebimento de
mensagens.

== Sistemas embarcados

// TODO: citar livro aqui, tanembaum ou algo de embeededede
Sistemas embarcados são uma família vasta de sistemas computacionais, algumas
das principais características de sistemas embarcados são:

*Especificidade*:
Diferente de um sistema de computação mais generalizado como um computador
pessoal ou um servidor, sistemas embarcados são especializados para uma solução
de escopo restrito. Um exemplo de um sistema embarcado são microcontroladores
encontrados em dispositivos como mouses, teclados e eletrodomésticos.

*Limitação de recursos*:
Um corolário da natureza especialista destes sistemas, é que recursos alocados
para o sistema são definidos previamente. No caso de microcontroladores tanto o
poder computacional quanto a disponibilidade de memória são restritas.
Importante notar que existem sistemas embarcados com acesso maior à recursos,
como equipamentos de rede e hardware aceleradores que podem ter acesso a
quantias maiores de poder computacional ou memória, mas os recursos do sistema
continuam estaticamente delimitados para cumprir sua função específica.

*Critério Temporal*:
Sistemas embarcados, por serem parte de um todo maior, devem realizar sua
função com o mínimo de interrupção para a funcionalidade geral do contexto
externo. A importância do tempo de execução de uma tarefa de um sistema pode
ser classificada em duas categorias: Soft real time, e Hard real time, a
distinção entre estas categorias é explicada na seção seguinte.

== Sistemas Operacionais de Tempo-Real

Um sistema operacional é um conjunto conjunto de software que permitem o
gerenciamento e interação com os recursos da máquina através de uma camada de
abstração, no contexto deste trabalho, o componente fundamental é o *kernel*, a
parte sistema operacional que sempre está executando, o trabalho principal do
kernel é permitir a coexistência de diferentes tarefas no sistema que precisam
acessar as capacidades do hardware, especialmente tempo na CPU e memória, o
kernel pode ser descrito de maneira simplificada como a "cola" entre a
aplicação e os recursos do hardware @OperatingSystemConcepts.

Já um sistema operacional de tempo real (RTOS) é um tipo de sistema operacional
mais especializado, tipicamente pequeno, que possui como característica central
cumprir o requisito temporal, que divide-se em 2 categorias:

- *Soft Real Time*: Um sistema que garante essa propriedade precisa sempre
  garantir que tarefas de  maior importância tenham prioridade sobre as de
  menor importância. Sistemas soft real-time tipicamente operam na escala de
  milissegundos, isto é, percepção humana @SchedAndOptOfDistributedFT.
  O atraso de uma tarefa em um sistema soft real-time não é desejável,
  mas não constitui um erro. _Exemplos_: Player de DVD, videogames, kiosks de atendimento.

- *Hard Real Time*: Precisam garantir as propriedades de soft real time, além
  disso, o atraso de uma tarefa de seu prazo (deadline), é inaceitável, para
  um sistema hard real time uma resposta com atraso é o mesmo que resposta
  nenhuma. Cuidado adicional deve ser utilizado ao projetar sistemas hard real
  time, pois muitas vezes aparacem em contextos críticos. _Exemplos_: Software
  para sistema de frenagem, Sistemas de navegação em aplicações aeroespaciais,
  software de trading de alta frequência, broker de mensagens de alta
  performance. @ModernOperatingSystems

Como sistemas Hard Real Time cumprem os requisitos de sistemas Soft Real Time,
os sistemas operacionais de tempo real tem seu design orientado a serem capazes
de cumprir o critério Hard Real Time.

Em contraste com sistemas operacionais focados em uso geral que são encontrados
em servidores e computadores pessoais (como Windows, Linux e OSX), o objetivo
do primário de um RTOS não é dar ao usuário a sensação de fluidez dinamicamente
escalonando os recursos da máquina, sistemas em tempo real buscam ser
simples, confiáveis e determinísticos @OperatingSystemConcepts. É essencial que
um RTOS execute as tarefas do sistema com um respeito estrito aos prazos de execução
fornecidos e que faça de maneira resiliente à flutuações de tempo causadas
por IO e outras interrupções.

Drivers em RTOSes são tipicamente adicionados previamente de maneira _ad-hoc_,
não havendo necessidade de carregamento dinâmico de drivers ou de bibliotecas
pois muitas aplicações que necessitam de um RTOS, o hardware ja é conhecido e
definido de antemão.

Devido à suas características de simplicidade, baixo custo e previsibilidade,
os sistemas operacionais de tempo real são extensivamente usados em aplicações
de sistemas embarcados. Exemplos incluem: FreeRTOS, VxWorks, Zephyr e LynxOS.

== Escalonador

O escalonador (scheduler) é o componente do sistema operacional responsável
por gerenciar múltiplas tarefas que desejam executar @OperatingSystemConcepts,
sendo um componente extramente crucial, a implementação do escalonador deve
garantir que tarefas de alta prioridade executem antes e que a troca entre
tarefas (context switching) seja o mais rápido possível, o algoritmo de
escalonamento é o fator central para o comportamento do escalonador, sendo
categorizados em 2 grandes grupos:

- *Cooperativos*: Tarefas precisam voluntariamente devolver o controle da CPU
  (com exceção de certas interrupções de hardware) para que as outras tarefas
  possam executar, isso pode ser feito explicitamente por uma função de
  "largar" (yield) ou implicitamente ao utilizar uma rotina assíncrona do
  sistema, como ler arquivos, receber pacotes de rede ou aguardar um evento
  @OperatingSystemConcepts

- *Preemptivos*: Além de poderem transferir a CPU manualmente, o escalonador
  forçará trocas de contexto caso uma condição para a troca seja satisfeita. O
  algoritmo mais comum que serve de base para diversos escalonadores
  preemptivos é o _Round-Robin_ onde tarefas possuem uma quantia de tempo
  máximo alocada para sua execução contínua, nomeada "time slice" ou "quantum"
  @ModernOperatingSystems. Tarefas ainda podem possuir relações de prioridade,
  alterando a ordem que o escalonador realiza seu despache assim como o tamanho
  de sua time slice.

Sistemas operacionais de tempo-real são tipicamente executados no modo totalmente
preemptivo, mas o uso cooperativo também é viável e possui a vantagem de possuir
o controle mais previsível e menos suporte de runtime para o gerenciamento de tarefas,
mas é importante que seja tomado o cuidado adequado para que nenhum prazo de
execução hard real time seja violado por uma tarefa inadvertidamente utilizando
a CPU por uma quantidade longa de tempo.

== Escalonamento tolerante à falhas

// TODO: Isosimov e mais algunm survey
Durante a execução de um sistema tolerante à falhas, existem alguns tipos
principais de overheads que independente da presença de uma falha vão ocorrer e
precisam ser considerados pelo escalonador.

1. *Mudança de contexto*: Trocar entre tarefas possui um custo inerente pois é
  necessário salvar o estado da máquina e fazer alterações no TCB (Task control
  block) da tarefa.

2. *Envio de mensagens*: Para comunicar entre tasks ou entre componentes
  fisicamente distintos do sistema, seja por bus ou por mecanismo de rede, existe
  um custo inerente à serialização e ao meio de transmissão da mensagem.

3. *Detecção de Erro*: É necessário um overhead fixo para detectar a presença
  de falhas, um bom algoritmo de detecção possui um equilíbrio entre minimizar
  esse custo e conseguir detectar falhas com uma alta taxa de acerto, sem
  presença de falsos positivos.

Na ocorrência de uma falha com uma política de re-execução, existe um overhead
extra, similar à de uma mudança de contexto, para restaurar o estado anterior
da tarefa.

Uma consequência natural de possuir diversos processos se comunicando com até
*k* falhas, é uma explosão combinatória de possíveis caminhos de execução e
reexecução, além de drasticamente aumentar o tempo de execução de algoritmos de
escalonamento (seja online ou offline), o sistema se torna excessivamente
complicado, afetando negativamente duas das características desejáveis de
sistemas de tempo real, como o determinismo e as fortes garantias de prazo de
execução.

Pode-se reduzir o grau de possíveis combinações e garantir maior
previsibilidade do sistema utilizando-se de pontos de transparência, também
chamadas de freezing @SchedAndOptOfDistributedFT.  Para uma tarefa qualquer,
considera-se que a tarefa é transparente se para uma deadline especificada e
dado um limite de até $k$ falhas, se sua execução é finalizada no prazo
independente do número de falhas que ocorreram. Para o caso onde nenhuma falha
ocorra, existe a presença de um tempo (potencialmente ocioso) extra onde a
tarefa está "congelada". Pontos de transparência podem ser estrategicamente
escolhidos para garantir o tempo de execução entre as principais macro etapas
sem a necessidade de redundância de replicação. É importante ressaltar que a
troca fundamental que ocorre na inserção de um ponto de transparência é a troca
de maior gasto temporal para o caso sem falhas de uma tarefa, em troca de uma
garantia sistêmica de sua conclusão, outras tarefas ou nós no sistema são
capazes de confiar na conclusão de uma tarefa transparente dado que seu prazo
esteja cumprido.

=== Grafos de execução tolerantes à falha

Para melhor visualização de um fluxo de execução com falhas, é possível
utilizar de um mecanismo de diagramação denominado grafos resilientes à falhas.
Nesta representação, os nós são tarefas, que podem estar executando na mesma
CPU ou não, arestas indicam o fluxo de execução, uma aresta não marcada indica
execução incondicional, já arestas demarcadas com notação de mensagem,
representam execução que depende de uma transmissão de mensagem. Mensagens e
tarefas indicados com um símbolo circular representam pontos ordinários no
grafo, já pontos com símbolos quadrados indicam as condições de transparência.
@SchedAndOptOfDistributedFT

Dado um grafo direcionado não ponderado acíclico, será utilizado a notação $T_X
[N]$, onde $X$ é o número identificador da tarefa, e $N$ corresponde à sua
$N$-ésima re-execução, por exemplo $T_2 [1]$ indica a primeira execução da
tarefa $T_2$, enquanto $T_1 [3]$ indica a terceira reexecução da tarefa $T_1$.
Uma notação similar será utilizada para mensagens entre tarefas, $m_X [N]$,
mensagens, assim como tarefas, estão sujeitas à falhas e overheads de detecção,
mas ao invés de re-execução, mensagens são re-enviadas ou restauradas no caso
algoritmos de recuperação de erro estejam disponíveis.
@SchedFTWithSoftAndHardConstraints

- *TODO*: >> Grafo simples aqui <<

- *TODO*:>> Grafo com múltiplas mensagens aqui <<

O escalonamento tolerante à falhas é a combinação de métodos que permitem que o
escalonador reaja à ocorrência de falhas e agende as tarefas de forma a
minimizar tempo ocioso e overhead de recuperação e detecção. A rotina de
escalonamento pode ser executada online, onde existe a possibilidade de criar e
suspender tarefas dinamicamente ou offline, onde o número e prazos das tarefas
são determinados previamente. Este trabalho será focado na execução offline,
pois fornece garantias mais fortes de transparência e previsibilidade, é
importante mencionar que um método offline de boa qualidade também pode ser
adaptado para um contexto online.

== Trabalhos Relacionados

=== Reliability Assessment of Arm Cortex-M Processors under Heavy Ions and Emulated Fault Injection

Neste trabalho conjunto de pesquisadores da USP e UFRGS utilizam de um sistema
COTS e criam um perfil de falhas com exposição a íons pesados assim como
injeção artificial de falhas para posteriormente realizar uma adição de formas
de detecção de falhas para melhorar a confiabilidade do sistema. Foi possível
detectar mais da metade das falhas funcionais apenas com técnicas de software
no banco de registradores. @ReliabilityArmCortexUnderHeavyIons.

#figure(
	image("assets/related_works_heavy_ion_reliability.png"),
	caption: "Análise de resiliência, dividida por categoria",
)

Uma outra observação foi que a quantia de falhas injetadas para ocasionar um
erro de funcionalidade é 2 ordens de magnitude maior na memória em relação ao
banco de registradores, indicando que existe uma necessidade real de poder
detectar e mitigar erros de memória mais rapidamente
@ReliabilityArmCortexUnderHeavyIons.

=== Application-Level Fault Tolerance in Real-Time Embedded System

// TODO: citar o arigo, acho que nao precisa botar o nome dos sujeitos
No artigo de Afonso, Silva, Tavares e Montenegro um framework de execução na
para o sistema operacional BOSS é criado, o trabalho apresenta técnicas de
escalonamento mas não entra em detalhamento profundo na parte de detecção, mas
sim de prover uma biblioteca na forma de classes representando threads
resilientes. O trabalho possui um caso de estudo com sistema de filtragem de
radar, o trabalho demonstra resultados favoráveis para uma forma híbrida de
tolerância com menor uso de CPU em relação à redundância tripla utilizando de
técnicas em software combinado com um par de processadores com auto checagem
(PSP).

#figure(
	image("assets/related_works_psp_perf.png"),
	caption: [Utilização de CPU para diferentes implementações de tolerância],
)

O trabalho demonstra também a viabilidade de prover interfaces mais abstratas
que ainda sejam capazes de rodar em sistemas de recursos restritos, os
pesquisadores realizam uso amplo de herança e padrões orientados à objetos com
chamadas virtuais. Uma possível otimização em termos de memória e coerência do
cachê da CPU é reduzir o uso de despache dinâmico em favor de técnicas de
despache em tempo de compilação, como typeclasses (Presentes em linguagens como
Haskell e Rust) que podem ser também emuladas em C++ com o sistema de
`concepts`.

=== A Software Implemented Comprehensive Soft Error Detection Method for Embedded Systems

// TODO: citar o arigo, acho que nao precisa botar o nome dos sujeitos, botar imagem?

No trabalho realizado pelos pesquisadores Asghari, Marvasti e Daneshtalab
propõem um método de detecção e reação à erros de controle fluxo juntamente com
correção de payloads de dados, o trabalho demonstra resultados positivos e
conclui que a aplicação de técnicas de software podem aprimorar drasticamente a
tolerância de um sistema. O trabalho possui um foco na análise do grafo de
execução do programa, utilizando de IDs para a detecção de jumps errôneos entre
blocos básicos. @SoftwareImplementedSoftErrorDetection

Esse trabalho relacionado possui similaridade na avaliação da troca de overhead
em relação à resiliência com o que será proposto neste artigo, com a principal
diferença sendo o enfoque na análise fina dos grafos de controle de fluxo. O
trabalho de Asghari et. al serve como um exemplo de uma possível extensão
futura da pesquisa apresentada aqui, servindo como uma fonte compreensiva de
diversas técnicas de análise e detecção de fluxo defeituoso.


