#import "@preview/cetz:0.4.2"
#import "@preview/itemize:0.1.2" as el

#let basic-template(doc) = {
  // Page & text
  set page(
    margin: 2cm, 
    paper: "a4", 
    numbering: "1",
    footer: context { 
      if(counter(page).get().at(0)== 1) [
        #grid(
          columns: (45%, 10%, 45%),
          [
            #set align(left)
            #set text(9pt)
            исходники найдутся тут: \
            #text(blue, top-edge: "bounds")[#link("https://github.com/pelmesh619/itmo_conspects")]
          ],
          [
            #set align(center) 
            1
          ],
          []
        )
      ] else [
        #set align(center) 
        #counter(page).display()
      ]
    }
  )
  set text(
    lang: "ru",
    top-edge: "ascender",
    bottom-edge: "descender"
  )
  set par(
    leading: 0.5em,
    spacing: 1em
  )
  set text(font: "New Computer Modern", size: 12pt)

  // Headings
  set heading(numbering: none)

  // Lists
  set list(indent: 1em)
  set enum(indent: 1em)
  
  show math.equation.where(block: false): it => math.display(it)
  
  show: doc => el.default-list(doc, label-indent: -1.3em, indent: 2em)
  // show: el.default-enum

  doc
}

#let header-template(subject-name: content, date-header: content, lecturer-name: content, doc) = {
  set page(
    header: [
      #set text(top-edge: "cap-height", bottom-edge: "baseline", size: 12pt)
      #grid(
        columns: (45%, 10%, 45%),
        [
          #set align(left)
          #subject-name
        ],
        [
          #set align(center)
          #date-header
        ],
        [
          #set align(right)
          #lecturer-name
        ]
      )
      #v(-0.5em)
      #line(length: 100%)
    ]
  )

  doc
}

// Blocks
#let theorem(body) = block(
  width: 100%,
  fill: blue.lighten(90%),
  stroke: blue.lighten(40%),
  inset: 14pt,
)[
  #body
]

#let proof(body) = block(
  width: 100%,
  breakable: true,
  fill: gray.lighten(90%),
  stroke: gray.lighten(40%),
  inset: 14pt,
)[
  #body
]

// Inline labels
#let Nota = emph("Nota.")
#let NotaN(N) = [#Nota] + [ ] + emph([#N] + ".")
#let Def = strong("Def.")
#let DefN(N) = [#Def] + [ ] + strong([#N] + ".")
#let Th = strong("Th.")
#let ThN(N) = [#Th] + [ ] + strong([#N] + ".")
#let Mem = emph("Mem.")
#let MemN(N) = [#Mem] + [ ] + emph([#N] + ".")
#let Lab = underline("Lab.")
#let Ex = strong("Ex.")
#let ExN(N) = [#Ex] + [ ] + strong([#N] + ".")

#let equaldef = $attach(=, t: "def")$

#let arc(expr) = $attach(limits(#expr), t: smile)$

#let point(coords, radius: 3pt, fill: gray, name: none) = cetz.draw.circle(coords, radius: radius, fill: fill, name: name)


#let vecsum(x, y) = (x.at(0) + y.at(0), x.at(1) + y.at(1))
#let veck(x, k) = (x.at(0) * k, x.at(1) * k)

#let bezier_custom(start, ..ctrl-style, name: none, iters: 10) = {
  // Extra positional arguments are treated like control points.
  let (ctrl, style) = (ctrl-style.pos(), ctrl-style.named())

  // Control point check
  let len = ctrl.len()
  let coordinates = (start, ..ctrl)

  let compress(points, t) = {
    let new_points = array(points)

    for i in range(new_points.len() - 1) {
      new_points.at(i) = vecsum(veck(new_points.at(i), 1 - t), veck(new_points.at(i + 1), t))
    }

    new_points = new_points.slice(0, count: new_points.len() - 1)

    return new_points
  }

  let step = 1 / iters
  let t = step
  let previous_point = start
  while t < 1 {
    let points = array(coordinates)

    while points.len() > 1 {
      points = compress(points, t)
    }

    cetz.draw.line(previous_point, points.at(0), ..style)

    previous_point = points.at(0)

    t += step
  }
}


