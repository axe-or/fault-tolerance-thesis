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

= Mecanismos de Tratamento

= Sistemas Embarcados

= Sistemas Operacionais de Tempo Real

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
