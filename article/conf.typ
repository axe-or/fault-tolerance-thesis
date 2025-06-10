#let conf(doc,
	title: "<SEM TÍTULO>",
	local: "<SEM LOCAL>",
	data: "<SEM DATA>",
	author: "<SEM AUTOR>",
	research_area: "<SEM ÁREA>",
	supervisor: "<SEM ORIENTADOR>",
) = {
	// Page
	set page(
		paper: "a4",
		margin: (
			top: 3cm,
			left: 3cm,
			right: 2cm,
			bottom: 2cm,
		),
	)

	// Paragraph
	set par(
		justify: true,
		leading: 12pt,
		first-line-indent: (
			amount: 1.25cm,
			all: true,
		),
	)

	set text(
		font: ("Times New Roman", "Nimbus Roman"),	
		lang: "pt",
		size: 12pt,
	)

	// Headings
	set heading(numbering: "1.1.")
	show heading.where(level: 1): set text(size: 16pt)
	show heading.where(level: 2): set text(size: 14pt)
	show heading.where(level: 3): set text(size: 14pt)
	show heading.where(level: 4): set text(size: 12pt)
	show heading: set block(below: 18pt, above: 18pt)

	// Code listings
  	set raw(theme: "assets/light.tmTheme")
	show figure.where(kind: raw): (fig) => {
		set text(top-edge: 0.7em)
		set par(first-line-indent: 0pt)
		
		box(width: 90%, stroke: (paint: luma(0), thickness: 1.5pt), {
			set align(left)
				grid(
					rows: (auto, auto),
					box(
						fill: luma(85%),
						width: 100%,
						inset: 5pt,
						stroke: (bottom: luma(0)),
					)[
						#text(weight: "bold", fig.caption)
					],
					box(
						fill: luma(94%),
						width: 100%,
						inset: (left: 16pt, right: 8pt, bottom: 8pt, top: 8pt),
						align(left, [
							#set par(first-line-indent: 0pt, leading: 0.5em)
							#fig.body
						]),
					)
				)
			}
		)
	}


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

		por #linebreak()
		#text(weight: "bold", author)

		#v(1fr)

		#set align(center)
		#text(local + ", " + data)
	]
	pagebreak()

	// 2nd Front page

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

		Área de #research_area

		por #linebreak()
		#text(weight: "bold", author)

		#v(0.40fr)

		#h(50%) #box(width: 50%)[
			#set text(size: 12pt)
			#set align(left)
			#set par(justify: true)
			Relatório apresentado à Banca Examinadora do Trabalho de Conclusão de Curso de Ciências da Computação, para análise e aprovação. #linebreak()
			Orientador: #supervisor
		]

		#v(1fr)

		#set text(size: 14pt)
		#set align(center)
		#text(local + ", " + data)
	]
	pagebreak()


	// Main content
	doc

	// References
	heading("REFERÊNCIAS")
	bibliography(
    	"bibliografia.bib",
		title: none,
		style: "assets/ufrj-abnt.csl",
		full: true,
	)

	pagebreak()

}

