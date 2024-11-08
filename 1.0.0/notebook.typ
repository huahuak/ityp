#let font_size = (
  title: 26pt,
  h1: 18pt,
  h2: 16pt,
  h3: 13pt,
  body: 12pt,
  footnote: 8pt,
  small: 10pt,
)

#let section_h1 = state("h1", none)
#let section_h2 = state("h2", none)

#let notebook(
  title: "",
  doc,
) = {
  set text(
    font: ("Times New Roman", "Songti SC"),
    size: font_size.body,
  )
  // MARK: render rule
  // table
  show table.cell.where(y: 0): strong
  show table: t => {
    set text(size: 0.9em)
    set table.cell(breakable: false)
    t
  }
  set table(
    inset: (x: 0.5em, y: 1em),
    stroke: 0.35pt,
    align: horizon,
  )
  // link
  show link: set text(blue)
  // footnote
  show footnote.entry: set text(size: font_size.footnote)
  // quote
  set quote(block: true)

  // MARK: section
  let locate_section() = {
    context [
      #section_h1.at(here()) · #section_h2.at(here())
    ]

  }

  // MARK: page
  set page(
    paper: "us-letter",
    margin: (left: 0.696in, right: 0.929in, top: 1in, bottom: 1.125in),
    header-ascent: 27.9pt,
    footer-descent: 23.4pt,
    header: [
      // reset footnote counter
      #counter(footnote).update(0)
    ],
    footer: [
      #set text(size: font_size.small)
      #show link: set text(fill: black, style: "italic")
      #context if here().page() > 2 {
        [
          #link(<outline>)[#locate_section()]
          #h(1fr)
          #context here().page()
        ]
      }

    ],
  )

  // MARK: title
  {
    set par(justify: true)
    set text(size: font_size.title)
    set align(center + horizon)
    [* #title *]
  }

  // MARK: outline
  pagebreak()
  {
    show outline.entry.where(level: 1): it => {
      v(1em, weak: true)
      it
    }
    show outline.entry: it => {
      v(1em, weak: true)
      it.level * h(0.5em)
      it
    }
    let toc = [#outline(depth: 2)<outline>]
    columns(2, toc)
  }
  pagebreak()

  // MARK: heading
  set heading(bookmarked: true)
  show heading.where(level: 1): h => {
    pagebreak(weak: true)
    set align(center)
    set text(size: font_size.h1)
    underline[#h.body #label(h.body.text)]
    // for section record.
    section_h1.update(h.body)
  }
  show heading.where(level: 2): h => {
    set align(center)
    set text(size: font_size.h2)
    set text(style: "italic")
    section_h2.update(h.body)
    [#h.body #label(h.body.text)]
    // for section record.
  }

  // MARK: document
  {
    set par(justify: true)
    doc
  }
}

// MARK: Function
#let article(
  title: "",
  from: "",
  url: none,
  path: none,
) = {
  let content() = {
    let content = title
    if path != none {
      let PDF = link(path)[PDF]
      content = [#content #super(PDF)]
    }
    if url != none {
      let HTML = link(url)[HTML]
      content = [#content #super(HTML)]
    }
    content
  }
  [
    // for tittle
    #set par(justify: false)
    #v(1em)
    #table(
      columns: (4fr, 1fr),
      align: (left, right + horizon),
      stroke: none,
      inset: 0pt,
      [
        === #content()
      ],
      [#from],
    )
  ]
}

#let callout(body) = {
  rect(inset: 1em)[
    #body
  ]
}

#let h2link(name) = {
  set par(justify: true)
  [#name#super(link(label(name.text))[\*])]
}
