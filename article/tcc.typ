#import "conf.typ": conf

#show: conf.with()

#outline(
	title: "Sumário",
	target: heading.where(depth: 1).or(heading.where(depth: 2))
)

#pagebreak()

#include "01_introducao.typ"

#include "02_fundamentacao_teorica.typ"

#include "03_projeto.typ"

