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

#show heading.where(level: 1): (h) => context {
    // if array.at(slide_counter.get(), 0) > 0 {
    // }
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
#show raw: set align(center)
#show table: set align(center)
#show table: set align(horizon)

/*
  TODO:
  - introducao
  - botar os 3 trabalho relacionado

  - metodologia
    - metodos

  - premissas

  - algoritmos & tecnicas
  - interface
  - plano de verificacao (testes unitarios + execucao)

  - Campanha de injecao de falhas: software logico, hardware logico
  - analise de risco
  - cons. final
  - como grama
*/

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

- Sistemas embarcados estão presentes diveras áreas, tipicamente utilizando de um sistema operacional de tempo real
- É provável que a adoção destes sistemas, particularmente sistemas COTS continue à crescer

== Problematização

- Existem diversas técnicas para tornar um sistema tolerante à falhas, mas seus tradeoffs nem sempre são claros.
- Pode ser vantajoso de um ponto de vista competitivo e social, que estes sistemas apresentem melhor dependabilidade.
- Portanto, é necessário conhecer os tradeoffs feitos visando facilitar a implementação e escolha correta de técnicas para garantir qualidade de serviço.

= Introdução

== Solução Proposta

- Implementar técnicas de tolerância à falhas próximas do escalonador do
  sistema operacional, analisar o impacto de performance causado e fornecer uma
  interface para o uso das técnicas.


== Objetivo Geral

#center_sentence[
  Explorar o uso de técnicas de escalonamento de tempo real com detecção de erros.
]

== Objetivos Específicos

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

= Definições Principais

Definições em português segundo a IEEE:

- *Erro* (_Error_): A diferença entre um valor esperado e um valor obtido.

- *Defeito* (_Fault_): Estado irregular do sistema, que pode provocar (ou não) erros que levam à falhas

- *Falha* (_Failure_): Incapacidade observável do sistema de cumprir sua função designada, constituindo uma degradação total ou parcial de sua qualidade de serviço.

#center_sentence[
    Para os propósitos deste trabalho, o termo "Falha" será utilizado como um termo mais abrangente, representando um estado ou evento no sistema que causa uma degradação da qualidade de serviço.
]

= Falhas

Falhas podem ser classificadas em 3 grupos de acordo com seu padrão de ocorrência:

- Falhas *Transientes*: Ocorrem aleatoriamente e possuem um impacto temporário.

- Falhas *Intermitentes*: Assim como as transientes possuem impacto temporário, porém re-ocorrem periodicamente.

- Falhas *Permanentes*: Causam uma degradação permanente no sistema da qual não pode ser recuperada, potencialmente necessitando de intervenção externa.

#center_sentence[
    Este trabalho focará na tolerância à falhas transientes.
]

= Mecanismos de Detecção
- CRC (Cyclic Redundancy Check): Um valor de checagem é criado com base em um polinômio gerador e verificado, utilizado primariamente para verificar integridade de pacotes ou mensagens.

- Asserts: Checagem de uma condição invariante que dispara uma falha, simples e muito flexível, pode ser automaticamente inserido como pós e pré condição na chamada de funções

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

= Sistemas Embarcados

- Família vasta de sistemas computacionais que capacitam um dispositivo maior.
- Características comuns: Especificidade, Limitação de Recursos, Critério temporal (Soft ou Hard real time)

#grid(
  columns: (1fr,) * 2,
  gutter: 8pt,

  align(horizon, image("assets/sdn_router.png")),
  image("assets/nf15b_plane.png"),
  image("assets/uc_keyboard.png"),
  image("assets/abs.png"),
)

= Sistemas Operacionais de Tempo Real

Sistemas comumente usados para diversos tipos de sistemas embarcados, possuem
escalonadores totalmente preemptivos. Tipicamente possuem poucas features,
dependendo apenas de uma HAL (_Hardware Abstraction Layer_)

== Escalonador

Componente do Sistema Operacional responsável por gerenciar o tempo da CPU entre das tarefas.

#image("assets/freertos_task_diagram.png")

= Escalonamento Tolerante à Falhas

Grafo tolerante à falhas de um programa simples (3 processos, 1 mensagem)
#image("assets/ftg_simples.png", height: 1fr)

= Escalonamento Tolerante à Falhas

Mesmo grafo, tolerando até uma falha transiente
#image("assets/ftg_expandido.png", height: 1fr)

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

= Trabalhos Relacionados 1
*Reliability Assessment of Arm Cortex-M Processors under Heavy Ions and Emulated Fault Injection*

- Utiliza injeção física de íons pesados e injeção emulada em hardware posteriormente

- Utiliza de redundância nos registradores e usa menos registradores

- Resultados favoráveis para detecção em software

- Usa do sistema FreeRTOS

- Observou-se que a memória é 2 ordens de magnitude mais suscetível à falhas transientes

#image("assets/related_works_heavy_ion_reliability.png", height: 1fr)

= Trabalhos Relacionados II
*Application-Level Fault Tolerance in Real-Time Embedded System*

- Cria interface de alto nível para TF no sistema operacional BOSS

- Resultados favoráveis para a detecção, foi possível adquirir resiliência
  desejada com um par de processadorres com auto checagem (PSP)

- Utiliza de injeção lógica e simulada em software em um setup de múltiplas máquinas

#image("assets/related_works_psp_perf.png", height: 1fr)

= Trabalhos Relacionados III

*A Software Implemented Comprehensive Soft Error Detection Method for Embedded Systems*

- Utiliza de checagens de jump e análise de controle de fluxo do programa

- Depende pesadamente de adicional do compilador

- Forma mais distinta de detecção em software deste trabalho

- Complementa análise de fluxo com checagem de deadlines

- Utiliza de injeção lógica em hardware

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

= Métodos

= Materiais

- STLink: Depurador de hardware
- STM32F103C8T6 "Bluepill": Microcontrolador para a execução do código
- GCC: Compilador
- STCubeIDE, QEMU: IDE e ferramenta de virtualização para auxílio

#box(height: 350pt)[
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

// TODO: tacar isso pra baixo?
= Requisitos Funcionais

#table(
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
)

= Requisitos Não Funcionais

#table(
	columns: (auto, 1fr),

	table.header([*Requisito*], [*Descrição*]),
	[*RNF 1*], [Trabalho deve ser realizado em C++ (versão 14 ou acima)],
	[*RNF 2*], [Deve ser compatível com arquitetura ARMv7-M ou ARMv8-M],
	[*RNF 3*], [Deve ser capaz de rodar em um microcontrolador utilizando um HAL (Hardware abstraction layer), seja do RTOS ou de terceiros.],
	[*RNF 4*], [Precisa fazer uso de múltiplos núcleos quando presentes],
	[*RNF 5*], [Deve ser capaz de executar em cima do escalonador do FreeRTOS ou outro RTOS preemptivo sem mudanças significativas],
	[*RNF 6*], [V-Tables das interfaces devem possuir redundância para evitar pulos corrompidos ao chamar métodos],
)

= Teste 1: Processador de Sinal digital

#image("assets/diagrama_sequencia_fft.png", height: 1fr)

= Teste 2: Convolução Bidimensional

#image("assets/convolucao_2d.png", height: 1fr)

= Algoritmos e Técnicas

= Interface

= Plano de Verificação

= Campanha de Injeção de Falhas

= Análise de Riscos

= Considerações Finais

= Cronograma
