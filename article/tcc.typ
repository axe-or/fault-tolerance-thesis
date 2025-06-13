#import "conf.typ": conf

#show: conf.with(
	title: "Exploração de detecção de falhas em tempo real com técnicas no escalonador",
	local: "Itajaí (SC)",
	data: "25 de Março",
	author: "Marcos Augusto Fehlauer Pereira",
    research_area: "Tolerância à Falhas, Sistemas Operacionais",
	supervisor: "Felipe Viel",
)

// Abstract (Native language)
#align(center, heading(numbering: none, "RESUMO"))
Sistemas embarcados são sistemas especializados tipicamente encontrados como um componente lógico de um dispositivo maior, estes sistemas utilizam-se com frequência um tipo especializado de sistema operacional: Sistemas operacionais de tempo real, que permitem que múltiplas tarefas executem de forma concorrente. Em diversas situações é necessário que esses dispositivos operem em condições adversas (como radiação ionizante e interferência eletromagnética) que alteram seu comportamento esperado e degradam sua qualidade de serviço, para operar dentro de tais condições, técnicas de tolerância à falhas são aplicadas, que visam permitir a operação razoável do sistema mesmo na presença de falhas.

Para viabilizar tolerância à falhas é possível utilizar de diversos mecanismos, dentre eles, aqueles que operam em conjunto com o escalonador do sistema operacional de tempo real podem permitir um grau de resiliência maior enquanto visando reduzir a ociosidade dos núcleos da máquina. Este trabalho visa explorar técnicas de tolerância à falhas (Redundância Modular, Reexecução, Heartbeat Signal, CRCs e Asserts) que realizam um interface com o escalonador do sistema operacional, com o objetivo de fornecer uma análise dos custos e vantagens associados à cada combinação de técnicas.

#pagebreak()

// Abstract (English)
#align(center, heading(numbering: none, "ABSTRACT"))

#pagebreak()

// Code listings & figures
#outline(
	title: "LISTA DE FIGURAS",
	target: figure.where(kind: image).or(figure.where(kind: raw)),
	depth: 1,
)

// Forumlas
#outline(
	title: "LISTA DE FÓRMULAS",
	target: figure.where(kind: "formula"),
)

// Tables
#outline(
	title: "LISTA DE TABELAS",
	target: figure.where(kind: table),
)

#pagebreak()

// Table of Contents
#outline(
	title: "SUMÁRIO",
	target: heading,
	depth: 2,
)
#pagebreak()

#include "01_introducao.typ"

#include "02_fundamentacao_teorica.typ"

#include "03_projeto.typ"

#include "04_consideracoes_finais.typ"

