#let conf(doc,
	title: "SEM TÍTULO",
	local: "SEM LOCAL",
	data: "SEM DATA",
	author: "SEM AUTOR",
) = {
	set page(
		paper: "a4",
		margin: (
			top: 3cm,
			left: 3cm,
			right: 2cm,
			bottom: 2cm,
		),
	)

	set par(
		justify: true,
		leading: 12pt,
		first-line-indent: (
			amount: 1.25cm,
			all: true,
		),
	)

	set heading(numbering: "1.1.")
	show heading.where(level: 1): set text(size: 16pt)
	show heading.where(level: 2): set text(size: 14pt)
	show heading.where(level: 3): set text(size: 14pt)
	show heading.where(level: 4): set text(size: 12pt)
	show heading: set block(below: 18pt, above: 18pt)

	set text(
		font: ("Times New Roman", "Nimbus Roman"),	
		lang: "br",
	)


	// Front page
	[
		#set align(center)
		#set text(size: 14pt)
		#set par(justify: false, first-line-indent: 0pt)

		*UNIVERSIDADE DO VALE DO ITAJAÍ* #linebreak()
		*ESCOLA POLITÉCNICA* #linebreak()
		*CURSO DE CIÊNCIA DA COMPUTAÇÃO*

		#v(0.8fr)

		#text(weight: "bold", upper(title))
		#v(28pt)

		#set align(left)

		#h(50%) por #linebreak()
		#h(50%) #text(weight: "bold", author) 

		#v(1fr)

		#set align(center)
		#text(local + ", " + data)
	]

	pagebreak()

	// Table of Contents
	outline(
		title: "SUMÁRIO",
		target: heading,
		depth: 2,
	)
	pagebreak()


	// Main content
	doc

	// Bibliography
	heading("BIBLIOGRAFIA")
	bibliography(
    	"bibliografia.bib",
		title: none,
		style: "assets/ufrj-abnt.csl",
	)
}
