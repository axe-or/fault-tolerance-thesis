#let conf(doc) = {
	set page(
		paper: "a4",
		margin: (
			top: 3cm,
			left: 3cm,
			right: 2cm,
			bottom: 2cm,
		),
	)

	set text(
		font: ("Times New Roman", "Nimbus Roman"),	
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
	show heading: set block(below: 18pt, above: 18pt)

	// Main content
	doc

	// Bibliography
	heading("Bibliografia")
	bibliography(
    	"bibliografia.bib",
		title: none,
		style: "assets/ufrj-abnt.csl",
	)
}
