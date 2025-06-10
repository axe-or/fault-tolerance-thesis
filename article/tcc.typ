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
#pagebreak()

// Abstract (English)
#align(center, heading(numbering: none, "ABSTRACT"))
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

