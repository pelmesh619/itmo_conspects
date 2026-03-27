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

  show emptyset: text(features: ("cv01",), $emptyset$)

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


#let hatching(anchor_point, square_size, step, angle: 45deg, stroke-style: (dash: "dashed", paint: luma(50%))) = {
  let (x0, y0) = anchor_point
  let (dx, dy) = square_size
  let x1 = x0 + dx
  let y1 = y0 + dy

  let eps = 1e-6
  let cos_a = calc.cos(angle)
  let sin_a = calc.sin(angle)

  if calc.abs(cos_a) < eps {
    // вертикальные линии
    let n = int((x1 - x0) / step) + 1
    for i in range(0, n) {
      let x = x0 + i * step
      cetz.draw.line((x, y0), (x, y1), stroke: stroke-style)
    }
  } else {
    // невертикальные линии
    let k = sin_a / cos_a  // tan θ
    let step_b = step / calc.abs(cos_a)  // шаг по параметру b

    // вычисляем b_min и b_max по углам
    let corners = (
      (x0, y0), (x0, y1), (x1, y0), (x1, y1)
    )
    let b_vals = corners.map(((x, y)) => y - k * x)
    let b_min = calc.min(..b_vals)
    let b_max = calc.max(..b_vals)

    let n = int((b_max - b_min) / step_b) + 1
    for i in range(0, n) {
      let b = b_min + i * step_b

      // интервал x, дающий y внутри [y0, y1]
      let (x_low, x_high) = if k > 0 {
        ((y0 - b) / k, (y1 - b) / k)
      } else if k < 0 {
        ((y1 - b) / k, (y0 - b) / k)
      } else {
        (x0, x1)
      }

      let x_start = calc.max(x0, x_low)
      let x_end   = calc.min(x1, x_high)

      if x_start < x_end {
        let p1 = (x_start, k * x_start + b)
        let p2 = (x_end,   k * x_end   + b)
        cetz.draw.line(p1, p2, stroke: stroke-style)
      }
    }
  }
}
