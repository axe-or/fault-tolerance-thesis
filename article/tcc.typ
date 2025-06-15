#import "conf.typ": conf, sourced_image

#show: conf.with(
	title: "Exploração de detecção de falhas em tempo real com técnicas no escalonador",
	local: "Itajaí (SC)",
	data: "15 de Junho, 2025",
	author: "Marcos Augusto Fehlauer Pereira",
    research_area: "Sistemas Operacionais",
	supervisor: "Felipe Viel",
)

// Abstract (Native language)
#align(center, heading(numbering: none, "RESUMO"))
#[
	#set par(first-line-indent: 0pt)

	Sistemas embarcados são sistemas especializados tipicamente encontrados como um componente lógico de um dispositivo maior, estes sistemas utilizam-se com frequência um tipo especializado de sistema operacional: Sistemas operacionais de tempo real, que permitem que múltiplas tarefas executem de forma concorrente. Em diversas situações é necessário que esses dispositivos operem em condições adversas (como radiação ionizante e interferência eletromagnética) que alteram seu comportamento esperado e degradam sua qualidade de serviço, para operar dentro de tais condições, técnicas de tolerância à falhas são aplicadas, que visam permitir a operação razoável do sistema mesmo na presença de falhas. Para viabilizar tolerância à falhas é possível utilizar de diversos mecanismos, dentre eles, aqueles que operam em conjunto com o escalonador do sistema operacional de tempo real podem permitir um grau de resiliência maior enquanto visando reduzir a ociosidade dos núcleos da máquina. Este trabalho visa explorar e aplicar técnicas de tolerância e detecção de falhas (Redundância Modular, Reexecução, Heartbeat Signal, CRCs e Asserts) com uma interface voltada ao escalonador do sistema operacional, com o objetivo de fornecer uma análise dos custos e vantagens associados à cada combinação de técnicas.

	Palavras-Chave: Sistemas Embarcados. Sistemas Operacionais. Tolerância a Falhas. FreeRTOS. Escalonador.
]
#pagebreak()

// Abstract (English)
#align(center, heading(numbering: none, "ABSTRACT"))

#[
	#set text(style: "italic")
	#set par(first-line-indent: 0pt)

	Embedded Systems are specialized systems that are typically found as a logical component of a greater device, these systems are frequently equipped with a special kind of operating system: a Real Time Operating System, that allow for multiple tasks to be executed concurrently. In many situations, it is required that such devices operate in adverse or volatile conditions (e.g. ionizing radiation and electromagnetic interference) that alter its behavior, causing a degradation in its quality of service. Thus, to be able to operate within these contexts, fault tolerance techniques are applied, with the goal of allowing reasonable system operation even within the presence of faults. Many mechanisms may be used to achieve fault tolerance, among them, there are those that operate in conjunction with the real time operating system's scheduler to offer a greater degree of reliability while also decreasing idle time of them machine's cores. This work shall explore and apply techniques of fault tolerance (Modular Redundancy, Re-execution, Heartbeat Signal and Asserts) that have an interface focused on the scheduler's capabilities, with the main objective of providing an analysis over the tradeoffs attached to permutations of those techniques.

	Keywords: Embedded Systems. Operating Systems. Fault Tolerance. FreeRTOS. Scheduler.
]
#pagebreak()

// Code listings & figures
#outline(
	title: "LISTA DE FIGURAS",
	target: figure.where(kind: image).or(figure.where(kind: raw)),
	depth: 1,
)
#pagebreak()

// Tables
#outline(
	title: "LISTA DE QUADROS",
	target: figure.where(kind: "quadro"),
)
#pagebreak()


// Forumlas
#outline(
	title: "LISTA DE EQUAÇÕES",
	target: figure.where(kind: "equation"),
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
#pagebreak()

#include "02_fundamentacao_teorica.typ"
#pagebreak()

#include "03_projeto.typ"
#pagebreak()

#include "04_consideracoes_finais.typ"

