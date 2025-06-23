#set page(
    "presentation-4-3",
    margin: (
        left: 2cm,
        top: 1cm,
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

= Definições Principais

Definições segundo a IEEE:

- *Erro*: A diferença entre um valor esperado e um valor obtido.

- *Defeito*: Estado irregular do sistema, que pode provocar (ou não) erros que levam à falhas

- *Falha*: Incapacidade do sistema de cumprir sua função designada, constituindo uma degradação de sua qualidade de serviço.

#let center_sentence(body) = {
    set text(style: "italic")
    align(horizon, align(center, body))
}

#center_sentence[
    Para os propósitos deste trabalho, o termo "Falha" será utilizado como um termo mais abrangente, representando um estado ou evento no sistema que causa uma degradação da qualidade de serviço.
]

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

= Definições Principais
 

*Dependabilidade*: Propriedade do sistema que pode ser sumarizada pelos critérios RAMS

- #initialism("Reliability") (Confiabilidade): Probabilidade de um sistema executar corretamente em um período

- #initialism("Availability") (Disponibilidade): Razão entre o tempo em que o sistema não consegue prover seu serviço (downtime) e o e seu tempo total de operação

- #initialism("Maintainability") (Capacidade de Manutenção): Probabilidade de que um sistema em um estado quebrado consiga ser reparado com sucesso, antes de um tempo $t$.

- #initialism("Safety") (Segurança): Probabilidade do sistema funcione ou não sem causar danos à integridade humana ou à outros patrimônios


= Falhas

Falhas podem ser classificadas em 3 grupos de acordo com seu padrão de ocorrência:

- Falhas *Transientes*: Ocorrem aleatoriamente e possuem um impacto temporário.

- Falhas *Intermitentes*: Assim como as transientes possuem impacto temporário, porém re-ocorrem periodicamente.

- Falhas *Permanentes*: Causam uma degradação permanente no sistema da qual não pode ser recuperada, potencialmente necessitando de intervenção externa.

#center_sentence[
    Este trabalho focará na tolerância à falhas transientes.
]

= Mecanismos de Detecção
- CRC (Cyclic Redundancy Check): Um valor de checagem é criado com base em um polinômio gerador e verificado

- Asserts: Checagem de uma condição invariante que dispara uma falha, simples e muito flexível

#align(horizon)[
```cpp
void assert(bool predicate, string message){
    [[unlikely]]
        if(!predicate){
        // Opcional: imprimir uma mensagem de erro
        log_error(message);
        trap(); // Emitir exceção
    }
}
```
]

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

= Sistemas Operacionais de Tempo Real

Sistemas comumente usados para diversos tipos de sistemas embarcados, possuem escalonadores totalmente preemptivos. Tipicamente possuem poucas features, dependendo apenas de uma HAL (_Hardware Abstraction Layer_)


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

#show text: set align(left)

#table(
    columns: (auto,) * 3,
    table.header([*Técnica*], [*Vantagens*], [*Desvantagens*]),
    
    [Física], [
        - Alta fidelidade à falhas reais
        - Possível injetar em partes pré definidas do chip
    ], [
        - Alto custo monetário
        - Menos controle sobre o tipo particular de falha
        - Requisita de especialistas
    ],
    [Lógica em Hardware], [], [],
    [Lógica em Software], [], [],
    [Simulada], [], [],
)

= Trabalhos Relacionados I

= Trabalhos Relacionados II

= Trabalhos Relacionados III

= Projeto: Visão Geral e Premissas
#image("assets/visao_geral.png", height: 1fr)

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
