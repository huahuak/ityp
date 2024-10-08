#let section-idx = counter("section-idx")
#let subslide = counter("subslide")
#let logical-slide = counter("logical-slide")
#let repetitions = counter("repetitions")
#let cover-mode = state("cover-mode", "hide")

#let cover-mode-hide = cover-mode.update("hide")
#let cover-mode-mute = cover-mode.update("mute")

// avoid "#set" interferences
#let full-box(obj) = {
  box(
    width: 100%,
    height: auto,
    baseline: 0%,
    fill: none,
    stroke: none,
    radius: 0%,
    inset: 0%,
    outset: 0%,
    obj,
  )
}

#let slide(max-repetitions: 10, body) = {
  pagebreak(weak: true)
  logical-slide.step()
  locate(loc => {
    subslide.update(1)
    repetitions.update(1)
    show heading.where(level: 2): h => full-box(h.body)

    for _ in range(max-repetitions) {
      locate(loc-inner => {
        let curr-subslide = subslide.at(loc-inner).first()
        if curr-subslide <= repetitions.at(loc-inner).first() {
          if curr-subslide > 1 {
            pagebreak(weak: true)
          }
          body
        }
      })
      subslide.step()
    }
  })
}

#let slides-custom-hide(body) = {
  locate(loc => {
    let mode = cover-mode.at(loc)
    // wrap in box to avoid hiding issues with list, equation and other types
    if mode == "hide" {
      hide(full-box(body))
    } else if mode == "mute" {
      text(gray.lighten(50%), full-box(body))
    } else {
      panic("Illegal `cover-mode`: " + mode)
    }
  })
}

#let only(visible-slide-number, body) = {
  repetitions.update(rep => calc.max(rep, visible-slide-number))
  locate(loc => {
    if subslide.at(loc).first() == visible-slide-number {
      full-box(body)
    } else {
      slides-custom-hide(body)
    }
  })
}

#let beginning(first-visible-slide-number, body) = {
  repetitions.update(rep => calc.max(rep, first-visible-slide-number))
  locate(loc => {
    if subslide.at(loc).first() >= first-visible-slide-number {
      full-box(body)
    } else {
      slides-custom-hide(body)
    }
  })
}

#let until(last-visible-slide-number, body) = {
  repetitions.update(rep => calc.max(rep, last-visible-slide-number))
  locate(loc => {
    if subslide.at(loc).first() <= last-visible-slide-number {
      full-box(body)
    } else {
      slides-custom-hide(body)
    }
  })
}

#let one-by-one(start: 1, ..children) = {
  repetitions.update(rep => calc.max(rep, start + children.pos().len() - 1))
  for (idx, child) in children.pos() {
    beginning(start + idx, child)
  }
}

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
  short-title = title

  show heading.where(level: 1): h => {
    section-idx.step()
  }

  show heading.where(level: 2): h => {
    pagebreak(weak: true)
    logical-slide.step()
    text(font: "Heiti SC", fill: color, h)
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
    header: locate(loc => {
      if counter(page).at(loc).first() > 1 {
        decoration("header")[
          #context {
            let headings = query(heading.where(level: 1)).map(h => h.body.text)
            let now = section-idx.at(loc).last() - 1
            headings.at(now) = text(blue)[#headings.at(now)]
            headings.join(" / ")
          }
        ]
      }
    }),
    header-ascent: 1em,
    footer: locate(loc => {
      if counter(page).at(loc).first() > 1 {
        decoration("footer")[
          #short-author #h(1fr)
          #h(1fr)
          #logical-slide.display()
        ]
      }
    }),
    footer-descent: 0.5em,
    background: locate(loc => {
      if counter(page).at(loc).first() > 1 {
        background
      }

    }),
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