#set page(
    "presentation-4-3",
    margin: (
        left: 1.5cm,
        top: 1.5cm,
        bottom: 0.5cm,
        right: 1cm,
    ),
)
#let colors = (
    heading: rgb(20%, 20%, 50%),
    highlight: rgb(209, 86, 4),
)
#show heading: set text(fill: colors.heading)

#set table(
    fill: (x, y) => if y == 0 { luma(75%) },
)

#set text(size: 20pt)

#let slide_counter = counter("slide")
#show heading: set block(below: 0.5em)
#show heading.where(level: 2): set block(below: 1em)

#show heading.where(level: 1): (h) => context {
    pagebreak()
    slide_counter.step()

    set text(size: 28pt)

    set block(below: 8pt, above: 12pt)

    h.body
    line(length: 100%, stroke: colors.heading)
    v(20pt)
}

#let initialism(word) = {
    set text(weight: "bold")
    text(fill: colors.highlight, word.slice(0, 1))
    word.slice(1)
}

#let center_sentence(body) = {
    set text(style: "italic")
    v(12pt)
    align(center, body)
    v(8pt)
}

// Code listings
#set raw(theme: "assets/light.tmTheme")
#show figure.where(kind: raw): (fig) => {
    set align(left)
    set text(top-edge: 0.7em)
    box()[
        #fig.caption
        #set par(first-line-indent: 0pt, leading: 0.5em)
        #box(stroke: (paint: black, thickness: 1pt), inset: 8pt, width: 100%)[
            #fig.body
        ]
    ]
}

#show image: set align(center)
#show table: set align(center)

// Main title

#let title = [Detecção de erros em sistema operacional de tempo real]
#let author = [Marcos Augusto Fehlauer Pereira]
#let university = [Universidade do Vale do Itajaí (UNIVALI)]
#let supervisor = [Felipe Viel]
#let course = [Escola Politécnica - Ciência da computação]

#[
    #v(2fr)
    #align(center, text(weight: "bold", size: 28pt, upper(title)))

    #line(length: 100%, stroke: colors.heading)

    #align(center, university)
    #align(center, course)
    #v(1.5fr)
    #align(right)[Aluno: #author #linebreak() Orientador: #supervisor]
    #v(2fr)
]

= Introdução

- Sistemas embarcados estão presentes diversas áreas, tipicamente utilizando de
  um sistema operacional de tempo real

- É provável que a adoção destes sistemas, particularmente sistemas COTS
  continue a crescer

== Problematização

- Existem diversas técnicas para tornar um sistema tolerante à falhas, mas seus
  tradeoffs nem sempre são claros.

- Pode ser vantajoso de um ponto de vista competitivo e social, que estes
  sistemas apresentem melhor dependabilidade.

- Portanto, é necessário conhecer os tradeoffs de performance em relação ao seu
  ganho de tolerância.

== Solução Proposta

- Implementar técnicas de tolerância à falhas próximas do escalonador do
  sistema operacional, analisar o impacto de performance causado e criar uma
  interface para o uso das técnicas.

= Objetivos

== Geral

#center_sentence[
  Explorar o uso de técnicas de escalonamento de tempo real com detecção de erros.
]

== Específicos

- Selecionar técnicas de detecção de falhas em nível de software

- Aplicar como prova de conceito em um RTOS as técnicas selecionadas

- Avaliar por meio de métricas a técnica durante a execução em um RTOS

- Avaliar por meio de métricas a técnica uso de memória em um RTOS

= Definições Principais

*Dependabilidade*: Propriedade do sistema que pode ser sumarizada pelos critérios RAMS

- #initialism("Reliability") (Confiabilidade): Probabilidade de um sistema executar corretamente em um período

- #initialism("Availability") (Disponibilidade): Razão entre o tempo em que o sistema não consegue prover seu serviço (downtime) e o e seu tempo total de operação

- #initialism("Maintainability") (Capacidade de Manutenção): Probabilidade de que um sistema em um estado quebrado consiga ser reparado com sucesso, antes de um tempo $t$.

- #initialism("Safety") (Segurança): Probabilidade do sistema funcione ou não sem causar danos à integridade humana ou à outros patrimônios

#center_sentence[
  Tolerar falhas influencia positivamente nos critétrios *R* e *A*, melhorando a dependabilidade.
]

= Definições Principais

Definições em português segundo a IEEE:

- *Erro* (_Error_): A diferença entre um valor esperado e um valor obtido.

- *Defeito* (_Fault_): Estado irregular do sistema, que pode provocar (ou não) erros que levam à falhas

- *Falha* (_Failure_): Incapacidade observável do sistema de cumprir sua função designada, constituindo uma degradação total ou parcial de sua qualidade de serviço.

#center_sentence[
    Para os propósitos deste trabalho, o termo "Falha" será utilizado como um termo mais abrangente, representando um estado ou evento no sistema que causa uma degradação da qualidade de serviço.
]

= Sistemas Embarcados

- Família vasta de sistemas computacionais que capacitam um dispositivo maior.
- Características comuns: Especificidade, Limitação de Recursos, Critério temporal (Soft ou Hard real time)

#box(height: 140pt)[
#grid(
  columns: (1fr,) * 2,
  gutter: 8pt,

  align(horizon, image("assets/sdn_router.png")),
  image("assets/nf15b_plane.png"),
  image("assets/uc_keyboard.png"),
  image("assets/abs.png"),
)
]

= Sistemas Operacionais de Tempo Real

Sistemas comumente usados para diversos tipos de sistemas embarcados, possuem
escalonadores totalmente preemptivos. Tipicamente possuem poucas features,
dependendo apenas de uma HAL (_Hardware Abstraction Layer_)

== Escalonador

Componente do Sistema Operacional responsável por gerenciar o tempo da CPU entre das tarefas.

#image("assets/freertos_task_diagram.png")

= Falhas

Falhas podem ser classificadas em 3 grupos de acordo com seu padrão de ocorrência:

- Falhas *Transientes*: Ocorrem aleatoriamente e possuem um impacto temporário.

- Falhas *Intermitentes*: Assim como as transientes possuem impacto temporário, porém re-ocorrem periodicamente.

- Falhas *Permanentes*: Causam uma degradação permanente no sistema da qual não pode ser recuperada, potencialmente necessitando de intervenção externa.

#center_sentence[
    Este trabalho focará na tolerância à falhas transientes.
]

= Mecanismos de Detecção
- CRC (Cyclic Redundancy Check): Um valor de checagem é criado com base em um
  polinômio gerador e verificado, utilizado primariamente para verificar
  integridade de pacotes ou mensagens.

- Asserts: Checagem de uma condição invariante que dispara uma falha, simples e
  muito flexível, pode ser automaticamente inserido como pós e pré condição na
  chamada de funções

```cpp
void assert(bool predicate, string message){
    [[unlikely]]
    if(!predicate){
        log_error(message); // Opcional: imprimir uma mensagem de erro
        trap(); // Emitir exceção
    }
}
```

= Mecanismos de Detecção
- Heartbeat signal: Sinal de Checagem, tipicamente baseado em uma deadline

#image("assets/heartbeat_signal.png")

= Mecanismos de Tratamento
*Redundância*: Pode ser inserida em diversos estágios, depende do fato que é menos provável que uma falha ocorra em $N$ lugares dentro de um período $t$.

#image("assets/redundancia_tmr.png")

= Mecanismos de Tratamento

*Reexecução*: Um tipo de redundância temporal, pode ser utilizado para condições de transparência, depende do fato que é improvável que uma falha transiente ocorra $N$ vezes em sucessão.

#image("assets/redundancia_reexec.png")

= Escalonamento Tolerante à Falhas

Grafo tolerante à falhas de um programa simples (3 processos, 1 mensagem) e sua
versão que tolera até uma falha transiente.

#align(center, grid(
  columns: (auto, auto),
  column-gutter: 40pt,
  image("assets/ftg_simples.png", height: 1fr),
  image("assets/ftg_expandido.png", height: 1fr),
))

= Escalonamento Tolerante à Falhas

Com condição de transparência (através de reexecução) inserida.

#image("assets/ftg_transparencia.png", height: 1fr)

#center_sentence[
    Inserir condições de transparência pode drasticamente reduzir a complexidade do grafo de execução.
]

= Injeção de Falhas

Tipos de injeção e suas desvantagens (Mamone, 2018)
#[
#show text: set align(left)
#show list: set align(left)
#set par(leading: 8pt)
#set text(size: 19pt)

#table(
    columns: (auto,) * 3,
    table.header([*Técnica*], [*Vantagens*], [*Desvantagens*]),

    [Física],
    [
    - Alta fidelidade à falhas reais
    - Possível injetar em partes específicas do chip
    ],
    [
    - Alto custo
    - Menos controle sobre o tipo particular de falha
    - Especialistas para lidar com equipamentos
    ],

    [Lógica em Hardware], [
    - Boa aproximação de falhas reais
    - Altamente precisa e oferece controle sobre dados injetados
    - Overhead pequeno no tempo de execução
    ],
    [
    - Necessita de uma unidade extra(depurador/injetor)
    - Necessita de um sistema de comunicação
    - Pode necessitar de pinos ou modificações adicionais no sistema alvo
    ],

    [Lógica em Software],
    [
    - Baixo custo
    - Flexível e precisa
    - Altamente portável
    ], [
    - Overhead no tamanho do código e no tempo de execução
    ],
    [Simulada], [
    - Zero intrusividade
    - Hardware alvo não necessário
    - Flexível e precisa
    ],
    [
      - Custo de ferramenta de simulação pode ser alto
      - Nem sempre uma descrição HDL do sistema está acessível
    ],
    )
]


= Comparação dos Trabalhos Relacionados

#[
#set text(size: 15.5pt)
#table(
	columns: (auto,) * 6,

	table.header([*N*], [*Trabalho*], [*Sistema*], [*Hardware*], [*Injeção*], [*Técnicas*]),

	[1], [*Reliability Assessment of Arm Cortex-M Processors under Heavy Ions and Emulated Fault Injection*], [Bare Metal, #linebreak()FreeRTOS], [CY8CKIT-059], [Física & Lógica em Software], [Redundância de Registradores, Deadlines, Redução de Registradores, Asserts],

	[2], [*Application-Level Fault Tolerance in Real-Time Embedded System*], [BOSS], [Máquinas PowerPC 823 e um PC x86_643 não especificado], [Simulada em Software], [Redundância Modular, Deadlines, Rollback/Retry],

	[3], [*A Software Implemented Comprehensive Soft Error Detection Method for Embedded Systems*], [MicroC/OS-ii], [MPC555 Evaluation Board], [Lógica em Hardware], [Análise de fluxo de controle e de dados com sensibilidade à deadlines],

	[-], [*Este Trabalho*], [FreeRTOS], [STM32 Bluepill], [Lógica em Software e Hardware], [Deadlines, Heartbeat, Asserts, Reexecução e Redundância de Tarefas],
)
]

= Visão Geral
#image("assets/visao_geral.png", height: 1fr)

= Premissas

- Registradores de controle (Stack Pointer, Return Address, Program Counter,
  Thread Pointer) serão isentos de falhas diretas.

- Será assumido que testes sintéticos possam ao menos aproximar a medição de um
  cenário com falhas físicas.

- Não será utilizado RTTI ou exceções baseadas em stack unwinding.

= Métodos

- Técnicas de detecção e tolerância baseadas em software.

- Injeção lógica em software durante desenvolvimento.

- Injeção lógica em hardware para teste final com depurador de hardware.

- Métricas coletadas com o profiler do FreeRTOS e mecanismos de código (contadores)

- Interface de tarefa com fortificação em sua V-Table

- Arquitetura orientada à passagem de mensagens

- Serão desenvolvidos dois programas de teste simples, para servir de exemplo
  para a coleta das métricas.

= Materiais

- STLink: Depurador de hardware
- STM32F103C8T6 "Bluepill": Microcontrolador para a execução do código
- GCC: Compilador para a linguagem C++ (Versão 14 ou acima)
- STCubeIDE, QEMU: IDE e ferramenta de virtualização para auxílio

#box(height: 320pt)[
#grid(
    columns: (1fr,2fr),
    image("assets/stm32_small.png"),
    grid(
        columns: (auto,) * 2,
        image("assets/st_link.png"),
        image("assets/qemu_logo.png", height: 50%),
        image("assets/gcc_logo.png", height: 50%),
        align(horizon, image("assets/freertos_logo.png")),
    )
)
]

= Requisitos

- Implementar os Algoritmos e Técnicas propostos

- Implementar os programas de teste

- Implementar interface de tarefa com TF

- Executar e coletar métricas com injeção lógica em software

- Executar e coletar métricas com injeção lógica em hardware

= Algoritmos e Técnicas

- CRC

- Heartbeat Signal

- Redundância Modular

- Replicação Temporal

- Asserts

= Interface

Exemplo ilustrativo de uma mensagem

```cpp
// Deve ser o suficiente para conter o valor de um timer monotônico
using Time_Point = size_t;

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

= Interface

Interface básica de uma tarefa

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
```

= Programa Teste 1: Processador de Sinal digital

#image("assets/diagrama_sequencia_fft.png", height: 1fr)

= Programa Teste 2: Convolução Bidimensional

#image("assets/convolucao_2d.png", height: 1fr)

= Plano de Verificação

- Testes unitários para:
  - CRC
  - Heartbeat Signal
  - Redundância Modular
  - Replicação temporal
  - Fila de Mensagens (MPMC bounded queue)
  - FFT, iFFT, Passa-Banda (Programa exemplo 1)
  - Convolução (Programa exemplo 2)

- Testes de integração e ponta-a-ponta para os programas de exemplo

- Teste com injeção baseada em software para garantir funcionamento preliminar

- Teste e análise final com injeção lógica em hardware

- É possível reutilizar uma boa parte da lógica de emissão de falhas em
  software para o depurador de hardware

= Campanha de Injeção de Falhas

- Sujeitos à falhas: Maioria da memória, Registradores de propósito geral

- Falhas injetadas: Bit flips com XOR, números aleatórios. Simulando corrupções de memória

- Método de injeção: Task auxiliar durante testes e desenvolvimento, Comandos via sessão GDB para alterar valores no controlador via STLink

Combinações de técnicas a serem usadas:
#table(
  columns: (auto, auto, auto, auto, auto, 1fr),
  table.header([*Comb.*], [*Reexecução*], [*Redundância modular*], [*Heartbeat Signal*], [*CRC*], [*Asserts*]), 
  "1", "-","-","-","-","-",
  "2", "-","-","-","✓","✓",
  "3", "✓","-","-","✓","✓",
  "4", "✓","-","✓","✓","✓",
  "5", "-","✓","-","✓","✓",
  "6", "-","✓","✓","✓","✓",
)

= Análise de Riscos

#table(
	columns: (auto,) * 5,

	table.header([*Risco*], [*Probabilidade*], [*Impacto*], [*Gatilho*], [*Contingência*]),
	[Funcionalidades e API do RTOS é incompatível com a interface proposta pelo trabalho.], [Baixo], [Alto], [Implementar interface no RTOS], [Utilizar outro RTOS, modificar o FreeRTOS, adaptar a interface],

	[Problemas para injetar falhas com depurador em hardware], [Baixa], [Alto], [Realizar injeção no microcontrolador], [Utilizar de outro depurador, depender de falhas lógicas em software como última alternativa],

	[Não conseguir coletar métricas de performance com profiler do FreeRTOS], [Baixa], [Médio], [Teste em microcontrolador ou ambiente virtualizado], [Inserir pontos de medição manualmente],
)

= Cronograma do TCC3

#table(
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
)

= Considerações Finais

- RTOSes são de grande importância e aumentar sua dependabilidade pode ser benéfico

- Integrar a detecção e tolerância à falhas com o processo de escalonamento através de uma interface permite criar abstrações para melhorias incrementais

- O escopo da campanha de falhas do trabalho serão os erros de memória, causados por evento externo ou erro de design

- Dentre as principais limitações do trabalho:

  - Não será realizado teste físico

  - Não será realizado análise de fluxo para pegar corrupções mais sofisticadas de fluxo.
