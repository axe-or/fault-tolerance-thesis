#import "conf.typ": conf

#show: conf.with(
	title: "Exploração de detecção de falhas em tempo real com técnicas no escalonador",
	local: "Itajaí (SC)",
	data: "25 de Março",
	author: "Marcos Augusto Fehlauer Pereira",
	supervisor: "Felipe Viel",
)

// Abstract (Native language)
#align(center, heading(numbering: none, "RESUMO"))
Sistemas de computador são presentes em múltiplas áreas da vida humana, alguns
destes sistemas, possuidores de um propósito específico no contexto de um
dispositivo maior (sistemas embarcados), necessitam em alguns casos operar
sobre condições com falhas enquanto oferecem sua funcionalidade esperada. Um
tipo de programa que permite a execução de diferentes tarefas concorrente é um
sistema operacional em tempo real (RTOS), que são frequentemente utilizados em
dispositivos embarcados. Neste trabalho, uma variedade de técnicas de
tolerância à falhas que operam perto de um sistema operacional de tempo real
são exploradas e comparadas para melhor entender os tradeoffs feitos entre
performance e tolerância à falhas.
#pagebreak()

// Abstract (English)
#align(center, heading(numbering: none, "ABSTRACT"))
_Computer systems are present in many facets of human life, some computer
systems, which have a particular purpose within a wider device (embedded
systems) may have to operate under faulty conditions while still providing
their expected functionality. One type of program which allows for the
concurrent execution of different tasks is a real time operating system (RTOS),
which are frequently used in embedded devices. In this work, a variety of fault
tolerance techniques that operate closely with a real time operating system
scheduler are explored and compared to better understand the tradeoffs between
performance and tolerance against faults._
#pagebreak()

// Code listings & figures
#outline(
	title: "LISTA DE FIGURAS",
	target: figure,
	depth: 1,
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

