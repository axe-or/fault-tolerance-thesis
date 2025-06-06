= PROJETO

A etapa mais fundamental do projeto é a implementação dos algoritmos e da API
de resiliência, dado o contexto de real time, cuidados devem ser tomados no
quesito da performance e uso de memória (que pode indiretamente degradar a CPU
na presença de erros de cachê). Dado estas restrições, o uso de despache
dinâmico será mantido baixo, e para reduzir o tamanho do executável não será
utilizado mecanismo de exceção com stack unwinding ou RTTI (Runtime Type
Information), ao invés, erros de validação devem ser cuidados explicitamente ou
através de callbacks.

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

// TODO: Mencionar que sistemas como o QNX usam isso tbm?

== Visão Geral e Premissas

=== Premissas

Será partido do ponto que ao menos o processador que executa o scheduler terá
registradores de controle (Stack Pointer, Program Counter, Return Address) que
sejam capazes de mascarar falhas, apesar de ser possível executar os algoritmos
reforçados com análise de fluxo do programa e adicionar redundância aos
registradores, isso adiciona um grau a mais de complexidade que foge do escopo
do trabalho, e, como mencionado na seção de *trabalhos relacionados*, a memória
fora do banco de registradores pode ser 2 ordens de magnitude mais sensível
à eventos disruptivos, portanto, todos os testes subsequentes assumirão ao
menos uma quantia mínima de tolerância do núcleo monitor. Pretende-se
portanto, focar na detecção de falhas de memória, passagem de mensagens e
resultados dos co-processadores dado que são maioria nas falhas.

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

=== Requisitos Não-Funcionais

+ Implementação deve ser realizada em uma linguagem que possua controle
  granular de layout de memória e não necessite de suporte à floats em hardware (C, C++, Rust)

+ Técnicas não devem utilizar RTTI ou exceções com stack-unwinding

+ Deve ser compatível com arquitetura ARMv7-M ou ARMv8-M

+ Deve ser capaz de rodar em um microcontrolador utilizando um HAL (Hardware
  abstraction layer), seja do RTOS ou de terceiros.

+ Precisa fazer uso de múltiplos núcleos quando presente

+ Interface de resiliência precisa ter uso de memória com limite superior determinado

+ Deve ser capaz de executar em cima do escalonador do FreeRTOS ou outro RTOS
  preemptivo sem mudanças significativas

+ TODO: V-Tables com redundância

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

```cpp
struct Mem_Layout {
	uint32_t size;
	uint32_t align;
};

template<typename T>
constexpr Mem_Layout memory_layout = { sizeof(T), alignof(T) };

using FT_Handler = void (*)(FT_Task*);

using Time_Point = size_t; // Deve ser suficiente para conter o valor de um timer monotônico

using Task_Id = unsigned int;

constexpr Task_Id BROADCAST = ~ Task_Id(0);

struct FT_Task {
  virtual void execute(void* param) = 0;
  virtual FT_Handler handler() = 0;

  virtual Task_Id id() = 0;
  virtual Time_Point start_time() = 0;
  virtual Time_Point deadline() = 0;
};

template<typename T>
struct FT_Message {
	uint32_t check_value;
	Task_Id  sender;
	Task_Id  receiver;
	T        payload;
};
```

DESCREVER INTERFACE COMPLETA COM UML E PA

=== Análise de riscos

== Plano de Verificação

+ Implementar os algoritmos fora do RTOS para testar sua corretude lógica e
  executar sanitizadores de memória e condições de corridas

+ Realizar teste com debugger em ambiente virtualizado com o RTOS

+ Teste final em microcontrolador ARM rodando um RTOS com injeção de falhas e
  coleta das métricas

+ Análise das métricas e comparação com as projeções dos testes virtuais

== Projeto para o TCC2

=== Metodologia

=== Cronograma

=== Análise De Requisitos


