#let section-idx = counter("section-idx")
#let logical-slide = counter("logical-slide")

#let icolor = (
  deep-blue: rgb("#261CA3"),
)

#let slides(
  title: none,
  author: none,
  short-title: none,
  short-author: none,
  date: none,
  color: teal,
  background: none,
  document_body,
) = {
  short-author = author

  show heading.where(level: 1): h => {
    section-idx.step()
    pagebreak()
  }

  show heading.where(level: 2): h2 => {
    logical-slide.step()
    pagebreak(weak: true)
    set text(font: "Heiti SC", fill: color)
    h2
  }

  let fonts = (
    "Songti SC",
    "Times New Roman",
  )

  set text(
    font: fonts,
    size: 25pt,
  )

  let decoration(position, body) = {
    let border = 0.3mm + color
    let strokes = (
      header: (bottom: border),
      footer: (top: border),
    )
    block(
      stroke: strokes.at(position),
      width: 100%,
      inset: .3em,
      text(.5em, body),
    )
  }

  set page(
    paper: "presentation-4-3",
    margin: (x: 1em, top: 2em, bottom: 1.5em),
    header: context {
      if counter(page).at(here()).first() > 1 {
        decoration("header")[
          #context {
            let headings = query(
              heading.where(level: 1)
            ).map(h => {
              let page = locate(
                heading.where(level: 1, body: h.body),
              ).position().page
              link((page: page, x: 0pt, y: 0pt))[#h.body]
            })
            let now = section-idx.at(here()).last() - 1
            headings.at(now) = text(blue, size: 1.25em, weight: "bold")[#headings.at(now)]
            headings.join(" / ")
          }
        ]
      }
    },
    header-ascent: 1em,
    footer: context {
      if counter(page).at(here()).first() > 1 {
        decoration("footer")[
          #grid(
            columns: (10%, 80%, 10%),
            align: (left, center, right),
            [#short-author], [#short-title], context [#here().position().page],
          )
        ]
      }
    },
    footer-descent: 0.5em,
    background: context {
      if counter(page).at(here()).first() > 1 {
        background
      }
    },
  )

  [
    #align(
      center + horizon,
      block(
        inset: 1em,
        radius: 1em,
        breakable: false,
        [
          #text(
            font: fonts,
            color,
            1.5em,
          )[#title] \
          #v(1em)
          #text(1em)[#author] \
          #v(1em)
          #date
        ],
      ),
    )
    #document_body
  ]
}