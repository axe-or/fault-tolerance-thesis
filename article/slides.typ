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

#set text(size: 20pt)

#let slide_counter = counter("slide")
#show heading: set block(below: 0.5em)

#show heading.where(level: 1): (h) => context {
    if array.at(slide_counter.get(), 0) > 0 {
        pagebreak()
    }
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

= Introdução

= Definições Principais

Definições segundo a IEEE

- *Erro*:

- *Defeito*:

- *Falha*:

#let center_sentence(body) = {
    set text(style: "italic")
    align(horizon, align(center, body))
}

#center_sentence[
    Para os propósitos deste trabalho, o termo "Falha" será utilizado como um termo mais genérico, representando um estado do sistema que causa uma degradação da qualidade de serviço.
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

#align(center)[
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

#image("assets/freertos_task_diagram.png")

= Escalonador

= Escalonamento Tolerante à Falhas

= Injeção de Falhas

= Trabalhos Relacionados I

= Trabalhos Relacionados II

= Trabalhos Relacionados III

= Projeto: Visão Geral e Premissas

= Métodos

= Materiais

= Requisitos Funcionais

= Requisitos Não Funcionais

= Programas Exemplo: Processador de Sinal digital

= Programas Exemplo: Convolução Bidimensional

= Algoritmos e Técnicas

= Interface

= Plano de Verificação

= Campanha de Injeção de Falhas

= Análise de Riscos

= Considerações Finais

= Cronograma
