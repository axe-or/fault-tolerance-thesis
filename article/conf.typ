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
		header: context {
			let skip = 6
			if here().page() > skip {
				set align(right)
				counter(page).display("1")
			}
		},
	)

	// Citation tweaks
	show figure: set cite(form: "prose")
	
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
		font: ("Liberation Serif", "Times New Roman"),	
		lang: "pt",
		size: 12pt,
	)

	set table(
		fill: (x, y) => if y == 0 { luma(75%) },
	)
	
	// Headings
	set heading(numbering: "1.1.")
	show heading.where(level: 1): set text(size: 16pt)
	show heading.where(level: 2): set text(size: 14pt)
	show heading.where(level: 3): set text(size: 14pt)
	show heading.where(level: 4): set text(size: 12pt)
	show heading: set block(below: 18pt, above: 18pt)

	show figure.where(kind: "equation"): set figure(supplement: "Equação")
	show figure.where(kind: table)
			.or(figure.where(kind: raw)) : set figure(kind: "quadro", supplement: "Quadro")

	// Equations
	show figure.where(kind: "equation"): (fig) => {
		let fig_num = array.at(counter(figure.where(kind: "equation")).get(), 0)
		grid(
			columns: (1fr, auto),
			fig.body,
			align(left, [(#fig_num)]),
		)
	}

	// Tables
	show figure.where(kind: table): (fig) => {
		set align(left)
		box()[
			#fig.caption
			#fig.body
		]
	}

	// Code listings
	set raw(theme: "assets/light.tmTheme")
	show figure.where(kind: raw): (fig) => {
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
	
	// Images
	show figure.where(kind: image): (fig) => box()[
		#align(center, fig.caption)
		#box(stroke: (paint: black, thickness: 1pt), inset: 2pt, width: 100%)[
			#fig.body
		]
	]

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
	pagebreak()

	// References
	heading("REFERÊNCIAS")
	bibliography(
    	"bibliografia.bib",
		title: none,
		style: "assets/associacao-brasileira-de-normas-tecnicas.csl",
	)
}

#let sourced_image(body, caption: "", source: "") = context {
	set par(justify: false, first-line-indent: 0pt)
	let fig = figure(caption: caption, body)
	box()[
		#fig
		Fonte: #cite(label(source), form: "prose")
	]
}