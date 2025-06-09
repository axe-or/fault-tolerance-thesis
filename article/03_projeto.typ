= PROJETO

A etapa mais fundamental do projeto é a implementação dos algoritmos e da API
de resiliência, dado o contexto de real time, cuidados devem ser tomados no
quesito da performance e uso de memória (que pode indiretamente degradar a CPU
na presença de erros de cachê). .

// TODO: Citar sobre coisa orientada a mensagem, pode ser ate documetation de outro RTOS

A arquitetura será primariamente orientada à passagem de mensagens, pois
permite uma generalização para mecanismos de I/O assíncrono e possível
distribuição da arquitetura, permite também um desacoplamento  entre a lógica
de detecção e transporte das mensagens, potencialmente permitindo otimizações
futuras na diminuição da ociosidade dos núcleos. O estilo de implementação
orientado à mensagens naturalmente oferece um custo adicional em termos de
latência quando comparado à alternativas puramente baseadas em compartilhamento
de memória, apesar deste custo poder ser amortizado com a utilização de filas
concorrentes bem implementadas e com a criação de um perfil de uso para melhor
ajuste do sistema.

== Visão Geral e Premissas

=== Premissas

Será partido do ponto que ao menos o processador que executa o scheduler terá
registradores de controle (Stack Pointer, Program Counter, Return Address) que
sejam capazes de mascarar falhas. Apesar de ser possível executar os algoritmos
reforçados com análise de fluxo do programa e adicionar redundância aos
registradores, isso adiciona um grau a mais de complexidade que foge do escopo
do trabalho, e, como mencionado na seção de *trabalhos relacionados*, a memória
fora do banco de registradores pode ser 2 ordens de magnitude mais sensível
à eventos disruptivos @ReliabilityArmCortexUnderHeavyIons. Portanto, todos os testes subsequentes assumirão ao
menos uma quantia mínima de tolerância do núcleo monitor, tendo foco na detecção de falhas de memória, passagem de mensagens e
resultados dos co-processadores.

Com o fim de reduzir o tamanho do executável e manter o fluxo de execução mais previsível não será utilizado mecanismo de exceção com stack unwinding ou RTTI (Runtime Type Information), ao invés, erros de validação devem ser cuidados explicitamente com valores ou através de callbacks.

Necessariamente, é preciso também presumir que testes sintéticos possam ao
menos *aproximar* a performance do mundo real, ou ao menos prever o pior caso
possível com grau razoável de acurácia. O uso de testes sintéticos não deve ser
um substituto para a medição em uma aplicação real, porém, uma bateria de
testes com injeção artificial de falhas pode ser utilizada para verificar as
tendências e overheads relativos introduzidos, mesmo que não necessariamente
reflitam as medidas absolutas do produto final.

Portanto, será assumido que os resultados extraídos de injeção de falhas
artificiais, apesar de menos condizentes com os valores absolutos de uma
aplicação e não sendo substitutos adequados na fase de aprovação de um produto
real, são ao menos capazes para realizar uma análise quanto ao overhead
proporcional introduzido, e devido à sua facilidade de realização e
profundidade de inspeção possível, serão priorizados inicialmente neste
projeto.

== Análise de Requisitos

=== Requisitos Funcionais

+ Algoritmos da seção *Algoritmos e Técnicas* implementados.

+ Interface para execução com diferentes políticas de resiliência das tarefas definidas

+ Programa de exemplo implementado com diferentes técnicas e executado

+ Implementação da interface para as tarefas do programa de exemplo

+ Injeção de falhas na memória com um depurador (GDB)

+ Fila MPMC (Multi producer, Multi consumer) para passagem de mensagens com checagem de erro

+ Funções de medição e observabilidade das métricas: uso de CPU, uso de
  memória, falhas injetadas, falhas detectadas, quantia de tasks instanciadas e
  cache hit rate (caso presente).

+ Interface de resiliência precisa ter uso de memória com limite superior determinado em tempo de compilação ou imediatamente no início do programa.

=== Requisitos Não-Funcionais

+ Implementação deve ser realizada em uma linguagem que possua controle
  granular de layout de memória e não necessite de suporte à floats em hardware. Neste trabalho será utilizado C++ (Versão 14 ou acima)

+ Deve ser compatível com arquitetura ARMv7-M ou ARMv8-M

+ Deve ser capaz de rodar em um microcontrolador utilizando um HAL (Hardware
  abstraction layer), seja do RTOS ou de terceiros.

+ Precisa fazer uso de múltiplos núcleos quando presentes

+ Deve ser capaz de executar em cima do escalonador do FreeRTOS ou outro RTOS
  preemptivo sem mudanças significativas

+ V-Tables das interfaces devem possuir redundância para evitar pulos corrompidos ao chamar métodos

=== Programa exemplo

Para explorar o uso computacional será utilizado uma aplicação exemplo que
recebe uma série de números gerados pseudo-aleatoriamente de forma periódica
simulando um sensor externo, um núcleo realizará uma transformada de Fourier
rápida (FFT) e enviará uma mensagem indicando a conclusão de um lote de
processamento, o segundo núcleo realizará uma filtragem passa-banda e realiza a
transformada inversa de Fourier e notifica o primeiro núcleo, que neste caso,
apenas irá despejar os resultados para debugging.

A escolha dos programas de exemplo serve como principal propósito testar uma
operação que dependa de múltiplos acessos e modificações à memória e que possa
demonstrar capacidades de processamento assíncronas (padrão
produtor/consumidor), que são particularmente importantes ao se lidar com
múltiplas interrupções causadas por timers ou IO.

=== Algoritmos e Técnicas

- CRC: Será implementado o CRC32 para a checagem do payload de mensagens.

- Heartbeat Signal (simples): Um sinal periódico será enviado para a tarefa em
  paralelo, apenas uma resposta sequencial será necessária.

- Heartbeat Signal (com proof of work): Um sinal periódico juntamente com um
  payload com um comando a ser executado e devolvido, para garantir não somente
  a presença da task mas seu funcionamento esperado.

- Redundância Modular: Uma mesma task será disparada diversas vezes, em sua
  conclusão, será realizado um consenso dentre as respostas.

- Replicação temporal: Uma mesma task será re-executada N-vezes, tendo suas N
  respostas catalogadas e verificadas, a resposta correta será decidida por
  consenso.

- Asserts: Serão utilizados asserts para checar invariantes específicas ao
  algoritmo, especialmente na entrada e na saída das funções.

=== Interface

Uma tarefa (task) é uma unidade de trabalho com espaço de stack dedicado e uma
deadline de conclusão.

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

Uma mensagem é um wrapper ao redor um payload qualquer, o ordenamento dos tipos aqui é importante, o payload _precisa_ ser o último membro para serialização de estruturas de tamanho arbitrário. O valor `check_value` é o valor de checagem do CRC que será utilizado para detectar corrupções e é computado com base em todos os outros campos. Os campos `sender` e `receiver` servem a função de remetente e destinatário, mesmo nos casos em que há apenas um destinatário ou remetente, a informação adicional serve como uma camada extra que pode ser assegurada com asserts (e também é representada no valor de checagem). Já os pontos de tempo servem para definir uma deadline de entrega, caso exista.


#figure(caption: "Interface básica de uma tarefa")[
```cpp
using FT_Handler = void (*)(FT_Task*);

struct FT_Task_Info {
    Task_Id    id;
    FT_Handler handler;
    Time_Point started_at;
    Time_Point deadline; // 0 - Sem deadline
};

struct FT_Task {
  virtual Task_Id execute(void* param) = 0;
  virtual FT_Task_Info info() = 0;
};

```]

Será utilizado uma interface para a implementação de uma tarefa, 

=== Análise de riscos

== Plano de Verificação

=== Testes Unitários

Para validar a maioria dos requisitos funcionais serão utilizados de testes unitários, os testes são considerados como um artefato do trabalho e serão distribuídos juntamente ao mesmo. A validação, primariamente das técnicas implementadas, serão validadas da seguinte forma:

*CRC*: Será utilizado como referência uma implementação correta do algoritmo, payloads com resultados já conhecidos serão comparados para garantir a implementação correta.

*Heartbeat Signal (simples)*: Um cenário reduzido de apenas 2 tarefas com um canal de comunicação será utilizado para testar essa técnica, o algoritmo deve ser capaz de rodar por $N$ vezes e capturar $F$ falhas por timeouts. $N$ e $F$ serão especificados como parâmetros do teste.

*Heartbeat Signal (com proof of work)*: Um cenário reduzido de apenas 2 tarefas com um canal de comunicação e uma tabela de consulta para a função de prova será utilizado para testar essa técnica, o algoritmo deve ser capaz de rodar por $N$ vezes e capturar $F$ falhas por timeouts ou por erro da função de prova. $N$ e $F$ serão especificados como parâmetros do teste.

*Redundância Modular*: Uma tarefa será disparada $R$ vezes de forma concorrente para executar, durante o teste serão deliberadamente incluídos falhas no código fonte para validar o algoritmo de consenso no final. Será utilizado $R = 3$, mas é possível que qualquer $R$ ímpar positivo seja usado. O número de execuções e probabilidade de falha serão parâmetros do teste.

*Replicação temporal*: Uma tarefa será disparada $R$ vezes de forma sequencial para executar, durante o teste serão deliberadamente incluídos falhas no código fonte para validar o algoritmo de consenso no final. Será utilizado $R = 3$ para paridade com o algoritmo de redundância modular, mas é possível que qualquer $R$ positivo seja usado. O número de execuções e probabilidade de falha serão parâmetros do teste.

*Asserts*: Apenas será testado um exemplo trivial para garantir o disparo da rotina de tratamento caso o assert encontre uma condição falsa, como asserts são extremamente simples e dependem do contexto lógico da função em que estão inseridos, não há como realizar um teste "genérico" externo à aplicação geral.

*Fila de Mensagens*: Não é uma técnica de tolerância, mas será testada offline com múltiplas threads se comunicando e causando estresse de memória na fila. A fila MPMC escolhida é baseada em uma implementação lockless do algoritmo @BoundedMPMCQueue

Será também realizado uma validação da 

=== Campanha de Injeção de Falhas

== Projeto para o TCC2

=== Metodologia

=== Cronograma

=== Análise De Requisitos


