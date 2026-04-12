#import "@preview/cetz:0.4.2"
#import "@preview/itemize:0.1.2" as el
#import "@preview/suiji:0.5.1"

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

#let dashed_gray = (dash: "dashed", paint: luma(50%))

#let default-style = {
  cetz.draw.set-style(
    mark: (fill: black, scale: 1),
    stroke: (thickness: 1pt, cap: "round")
  )
  cetz.draw.register-mark("||", style => {
    import cetz.draw: anchor

    let w = style.width
    let i = style.length

    let pts1 = if style.harpoon {
      ((-i / 2, w / 2), (-i / 2, 0))
    } else {
      ((-i / 2, w / 2), (-i / 2, -w / 2))
    }
    let pts2 = if style.harpoon {
      ((i / 2, w / 2), (i / 2, 0))
    } else {
      ((i / 2, w / 2), (i / 2, -w / 2))
    }

    cetz.draw.line(..pts1, stroke: style.stroke, fill: style.fill)
    cetz.draw.line(..pts2, stroke: style.stroke, fill: style.fill)
    // cetz.draw.line(..pts, stroke: style.stroke, fill: style.fill)
    cetz.draw.anchor("center", (0, 0))
  })
}

#let vecsum(x, y) = cetz.vector.add(x, y)
#let veck(x, k) = cetz.vector.scale(x, k)

#let vec_sign(vec1, origin, vec2) = {
    return cetz.vector.cross(cetz.vector.sub(vec1, origin) + (0, ), cetz.vector.sub(vec2, origin) + (0, )).at(2)
}

#let vec_angle(vec1, origin, vec2) = {
    if vec1 == origin or vec2 == origin {
        return 0deg
    }
    let a = cetz.vector.angle(vec1, origin, vec2)
    let b = vec_sign(vec1, origin, vec2)
    
    return if b == 0 { 0deg } else { a * b / calc.abs(b) }
}

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

#let hatching-fill(
  step: 10pt,           // размер ячейки паттерна
  angle: 45deg,         // угол наклона линий (0° – горизонталь, 90° – вертикаль)
  stroke-style: (dash: "dashed", paint: luma(50%))
) = {
  let rad = -angle.rad()
  let is-vertical = calc.abs(calc.cos(rad)) < 1e-6

  let get-ends() = {
    if is-vertical {
      return ((0.5, 0), (0.5, 1))
    }
    let tan-a = calc.tan(rad)
    let points = ()

    // Пересечение с левой границей (x = 0)
    let y-left = 0.5 - tan-a * 0.5
    if y-left >= 0 and y-left <= 1 {
      points.push((0, y-left))
    }
    // Пересечение с правой границей (x = 1)
    let y-right = 0.5 + tan-a * 0.5
    if y-right >= 0 and y-right <= 1 {
      points.push((1, y-right))
    }
    // Пересечение с нижней границей (y = 0)
    if tan-a != 0 {
      let x-bottom = 0.5 - 0.5 / tan-a
      if x-bottom >= 0 and x-bottom <= 1 {
        points.push((x-bottom, 0))
      }
    }
    // Пересечение с верхней границей (y = 1)
    if tan-a != 0 {
      let x-top = 0.5 + 0.5 / tan-a
      if x-top >= 0 and x-top <= 1 {
        points.push((x-top, 1))
      }
    }

    let unique = ()
    for p in points {
      if not unique.any(q =>
        calc.abs(q.at(0) - p.at(0)) < 1e-6 and
        calc.abs(q.at(1) - p.at(1)) < 1e-6
      ) {
        unique.push(p)
      }
    }

    if unique.len() >= 2 {
      (unique.at(0), unique.at(1))
    } else {
      ((0, 0.5), (1, 0.5))
    }
  }

  let (start, end) = get-ends()
  tiling(size: (step, step))[
    #place(line(
      start: (start.at(0) * 100%, start.at(1) * 100%),
      end:   (end.at(0) * 100%,   end.at(1) * 100%),
      stroke: (..stroke-style, cap: "round")
    ))
  ]
}
