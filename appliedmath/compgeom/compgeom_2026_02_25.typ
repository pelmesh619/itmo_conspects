#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [25.02.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

==== 1.6.3 Конструирование кривой по Безье

// история кривых Безье

#block(
  stroke: (left: 4pt + gray, rest: none),
  inset: 1em,
  width: 100%,
)[
Во Франции конца 1950-х годов автомобилестроение переживало эпоху расцвета дизайна, и инженерам нужен был способ описывать сложные, плавные изгибы кузовов автомобилей не на чертежной доске, а с помощью первых компьютеров для станков с ЧПУ. Традиционных инструментов для этой задачи было недостаточно

В этот период сразу два французских автогиганта, Citroën и Renault, независимо друг от друга работали над решением этой проблемы

Пьер Безье из Renault, инженер-механик и электрик, пришел к решению к 1962 году, разработав свою систему для компьютерного проектирования кузовов автомобилей, аэродинамические свойства которых легко задаются
]

#Def Кривая Безье $n$-ого порядка в параметрической форме описывается функцией $B(t) = sum_(i = 0)^n P_i b_(i, n)(t)$, где 

- $0 <= t <= 1$, 
- $P_i = (x_i (t), y_i (t))$ -- координаты опорных точек, 
- а $b_(i, n) (t) = C_n^i t^i (1 - t)^(n - i)$ -- полиномы Бернштейна, где $i$ -- порядковый номер опорной точки

#Nota Упорядоченное множество опорных точек $(P_0, P_1, dots, P_n)$ называется характеристической ломаной

#Nota Прямое вычисление $B(t)$ как пару функций $B_x (t)$ и $B_y (t)$, определяющих точки кривой, - сложная задача, поэтому чаще используют алгоритм Кастельжо:

#proof([
Заданы точки $P_0, P_1, dots, P_n$ нулевого порядка

Тогда $P^j_i (t) = (1 - t) P_i^(j - 1) (t) + t P^(j - 1)_(i + 1) (t)$, где $i$ -- номер вершины, а $j$ - порядок вершины])

#block(
  stroke: (left: 4pt + gray, rest: none),
  inset: 1em,
  width: 100%,
)[
Поль де Кастельжо, работая в Citroën, разработал независимо от Безье в 1959 году алгоритм для построения кривой, однако его разработки оставались коммерческой тайной, поэтому кривые получили название в честь Безье
]

Рассмотрим примеры:

#ExN(1) $n = 1$, даны $P_0$ и $P_1$

#grid(columns: (auto, auto), [
Для точки первого порядка $P_0^1 = (1 - t) P_0^(1 - 1) + t P_1^(1 - 1) = (1 - t) P_0 + t P_1$
], [
  #pad(x: 1em)[
    #cetz.canvas(length: 1.5cm, {
      import cetz.draw: *

      set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 1pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
      )

      let dots = ((-1, 0), (1, 0), (0, 0))

      line(dots.at(0), dots.at(2))
      line(dots.at(1), dots.at(2))

      bezier(..dots, stroke: (paint: blue, thickness: 3pt))

      point(dots.at(0))
      content((), [$P_0$], anchor: "east", padding: 0.15)
      point(dots.at(1))
      content((), [$P_1$], anchor: "west", padding: 0.15)
    })
  ]
])

В $t = 0$ $P_0^1 = P_0$, в $t = 1$ $P_0^1 = P_1$. При $0 < t < 1$ $P_0^1(t)$ -- точка, пробегающая отрезок

В данном случае (так как меньше двух точек нельзя задать) $P_0^1 (t) = B(t)$, то есть при $n = 1$ кривая Безье -- отрезок $P_0 P_1$

#ExN(2) $n = 2$, даны $P_0, P_1, P_2$

По определению $B(t) = sum_(i = 0)^2 P_i C^i_2 t^i (1 - t)^(2 - i) = P_0 (1 - t)^2 + 2 P_1 t (1 - t) + P_2 t^2$

#grid(columns: (auto, auto), [
По Кастельжо $P_0 (t = 0)$, $P_2 (t = 1)$:

- $P_0^1 (t) = (1 - t) P_0 + t P_1$
- $P_1^1 (t) = (1 - t) P_1 + t P_2$
- $P_1^2 (t) = (1 - t) P_0^1 + t P_1^1 $

  $#hide($P_1^2 (i)$) &= (1 - t)^2 P_0 + 2 (1 - t) t P_1 + t^2 P_2 \ &= B(t)$

В случае $n = 2$ кривая Безье -- это парабола (в частной случае прямая)
], [
  #pad(x: 1.8em)[
    #cetz.canvas(length: 1.5cm, {
      import cetz.draw: *

      set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 1pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
      )

      let dots = ((-1, 0), (2, -2), (1.5, 0.8))

      line(dots.at(0), dots.at(2))
      line(dots.at(1), dots.at(2))

      bezier(..dots, stroke: (paint: blue, thickness: 3pt))

      point(dots.at(0))
      content((), [$P_0$], anchor: "east", padding: 0.15)
      point(dots.at(1))
      content((), [$P_2$], anchor: "west", padding: 0.15)
      point(dots.at(2))
      content((), [$P_1$], anchor: "south", padding: 0.15)
    })
  ]
])

По алгоритму Кастельжо становится видно, что характеристическая ломаная является касательной к кривой Безье. Сами точки первого порядка при разных $t$ дают отрезки, которые касаются кривой, а точка второго порядка лежит непосредственно на кривой Безье:

#let bezier_walk(t) = [
#cetz.canvas(length: 1.37cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round"),
    content: (padding: 1pt, font: 17pt)
  )

  let dots = ((-1, 0), (2, -2), (1.5, 0.8))

  line(dots.at(0), dots.at(2))
  line(dots.at(1), dots.at(2))

  bezier(..dots, stroke: (paint: blue, thickness: 3pt))

  point(dots.at(0))
  content((), [$P_0$], anchor: "east", padding: 0.15)
  point(dots.at(1))
  content((), [$P_2$], anchor: "west", padding: 0.15)
      point(dots.at(2))
      content((), [$P_1$], anchor: "south", padding: 0.15)

  let Q_1 = vecsum(veck(dots.at(0), (1 - t)), veck(dots.at(2), t))
  let Q_2 = vecsum(veck(dots.at(2), (1 - t)), veck(dots.at(1), t))

  line(Q_1, Q_2, stroke: (dash: "dashed", paint: luma(50%), thickness: 2pt))
  point(Q_1)
  content((), [$P_0^1$], anchor: "south", padding: 0.15)
  point(Q_2)
  content((), [$P_1^1$], anchor: "west", padding: 0.15)

  content((vecsum(dots.at(0), dots.at(1)).at(0) / 2, -2.5), [$t = #t$])

  let T_1 = vecsum(veck(Q_1, (1 - t)), veck(Q_2, t))
  point(T_1, fill: blue)
  content((), [$P_0^2$], anchor: "south-west", padding: 0.15)
})
]

#grid(columns: (1fr, 1fr, 1fr), 
  align(center)[#bezier_walk(0.2)],
  align(center)[#bezier_walk(0.5)],
  align(center)[#bezier_walk(0.8)]
)

#grid(columns: (auto, 1fr), [
#ExN(3) $n = 3$, даны $P_0, P_1, P_2, P_3$

$B(t) = (1 - t)^3 P_0 + 3 t (1 - t)^2 P_1 + 3 t^2 (1 - t) P_2 + t^3 P_3$

Или в матричном виде $B(t) = (t^3, t^2, t, 1) dot M_B dot vec(P_0, P_1, P_2, P_3)$

Здесь $M_B = mat(-1, 3, -3, 1; 3, -6, 3, 0; -3, 3, 0, 0; 1, 0, 0, 0)$ -- матрица Безье
], align(center)[
#cetz.canvas(length: 1.3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round"),
    content: (padding: 1pt, font: 17pt)
  )

  let dots = ((0, 0), (3, 0), (1.5, 1), (1.5, -2))

  line(dots.at(0), dots.at(2))
  line(dots.at(2), dots.at(3))
  line(dots.at(1), dots.at(3))

  bezier(..dots, stroke: (paint: blue, thickness: 3pt))

  point(dots.at(0))
  content((), [$P_0$], anchor: "east", padding: 0.15)
  point(dots.at(1))
  content((), [$P_3$], anchor: "west", padding: 0.15)
  point(dots.at(2))
  content((), [$P_1$], anchor: "south", padding: 0.15)
  point(dots.at(3))
  content((), [$P_2$], anchor: "north", padding: 0.15)
})
])


// #let bezier_cubic_walk(t) = [
// #cetz.canvas(length: 1.8cm, {
//   import cetz.draw: *

//   set-style(
//     mark: (fill: black, scale: 2),
//     stroke: (thickness: 1pt, cap: "round"),
//     content: (padding: 1pt, font: 17pt)
//   )

//   let dots = ((0, -0.5), (3, 0), (1.5, 1), (1.5, -2))

//   line(dots.at(0), dots.at(2))
//   line(dots.at(2), dots.at(3))
//   line(dots.at(1), dots.at(3))

//   bezier(..dots, stroke: (paint: blue, thickness: 3pt))

//   point(dots.at(0))
//   content((), [$P_0$], anchor: "east", padding: 0.15)
//   point(dots.at(1))
//   content((), [$P_3$], anchor: "west", padding: 0.15)
//   point(dots.at(2))
//   content((), [$P_1$], anchor: "south", padding: 0.15)
//   point(dots.at(3))
//   content((), [$P_2$], anchor: "north", padding: 0.15)

//   let Q_1 = vecsum(veck(dots.at(0), (1 - t)), veck(dots.at(2), t))
//   let Q_2 = vecsum(veck(dots.at(2), (1 - t)), veck(dots.at(3), t))
//   let Q_3 = vecsum(veck(dots.at(3), (1 - t)), veck(dots.at(1), t))

//   line(Q_1, Q_2, stroke: (dash: "dashed", paint: luma(50%), thickness: 2pt))
//   line(Q_2, Q_3, stroke: (dash: "dashed", paint: luma(50%), thickness: 2pt))
//   point(Q_1)
//   content((), [$P_0^1$], anchor: "south", padding: 0.15)
//   point(Q_2)
//   content((), [$P_1^1$], anchor: "west", padding: 0.15)
//   point(Q_3)
//   content((), [$P_2^1$], anchor: "west", padding: 0.15)

//   content((vecsum(dots.at(0), dots.at(1)).at(0) / 2, -2.5), [$t = #t$])


//   let T_1 = vecsum(veck(Q_1, (1 - t)), veck(Q_2, t))
//   let T_2 = vecsum(veck(Q_2, (1 - t)), veck(Q_3, t))
//   line(T_1, T_2, stroke: (dash: "dashed", paint: luma(50%), thickness: 2pt))
//   point(T_1)
//   content((), [$P_0^2$], anchor: "south-west", padding: 0.15)
//   point(T_2)
//   content((), [$P_1^2$], anchor: "south-west", padding: 0.15)

//   let P = vecsum(veck(T_1, (1 - t)), veck(T_2, t))
//   point(P, fill: blue)
//   content((), [$P_0^3$], anchor: "north", padding: 0.2)
// })
// ]


// #grid(columns: (1fr, 1fr, 1fr), 
//   align(center)[#bezier_cubic_walk(0.2)],
//   align(center)[#bezier_cubic_walk(0.4)],
//   align(center)[#bezier_cubic_walk(0.7)]
// )


Для кривых Безье справедливы свойства:

- Порядок кривой Безье инвариантен при аффинных преобразованиях

  #proof[
    Пусть $P_0, dots, P_n$ содержит $k$ коллинеарных точек. $cal(F)(P_0, dots, P_n) = P'_0, dots, P'_n$ -- образы точек при аффинном преобразовании. И так как матрица $F$ не вырождена, среди $P'_0, dots, P'_n$ останется $k$ коллинеарных, таким образом порядок кривой сохранится
  ]

  То есть можно не подвергать всю кривую аффинному преобразованию, а всего лишь ее ломаную

- Непрерывность

- Вся кривая лежит внутри многоугольника $P_0, dots, P_n$ или выпуклой оболочки

  // картинка

  #grid(columns: (1fr, 1fr), 
    align(center)[
        #cetz.canvas(length: 1.3cm, {
            import cetz.draw: *

            set-style(
                mark: (fill: black, scale: 2),
                stroke: (thickness: 1pt, cap: "round"),
                content: (padding: 1pt, font: 17pt)
            )

            let dots = ((0, 0), (1.5, 1), (3, 0), (2.33, -1.5), (0.66, -1.5))

            line(dots.at(0), dots.at(1))
            line(dots.at(1), dots.at(2))
            line(dots.at(2), dots.at(3))
            line(dots.at(3), dots.at(4))

            bezier_custom(..dots, stroke: (paint: blue, thickness: 3pt), iters: 100)

            point(dots.at(0))
            content((), [$P_0$], anchor: "east", padding: 0.15)
            point(dots.at(1))
            content((), [$P_1$], anchor: "south", padding: 0.15)
            point(dots.at(2))
            content((), [$P_2$], anchor: "west", padding: 0.15)
            point(dots.at(3))
            content((), [$P_3$], anchor: "north", padding: 0.15)
            point(dots.at(4))
            content((), [$P_4$], anchor: "north", padding: 0.15)

            line(dots.at(4), dots.at(0), stroke: (dash: "dashed", paint: luma(50%)))

            content((1.5, -2.7), align(center)[Кривая находится \ в пятиугольнике $P_0 P_1 P_2 P_3 P_4$])
        })
    ], align(center)[
        #cetz.canvas(length: 1.3cm, {
            import cetz.draw: *

            set-style(
                mark: (fill: black, scale: 2),
                stroke: (thickness: 1pt, cap: "round"),
                content: (padding: 1pt, font: 17pt)
            )

            let dots = ((0, 0), (3, 0), (1.5, 1), (2.33, -1.5), (0.66, -1.5))

            line(dots.at(0), dots.at(1))
            line(dots.at(1), dots.at(2))
            line(dots.at(2), dots.at(3))
            line(dots.at(3), dots.at(4))

            bezier_custom(..dots, stroke: (paint: blue, thickness: 3pt), iters: 100)

            point(dots.at(0))
            content((), [$P_0$], anchor: "east", padding: 0.15)
            point(dots.at(1))
            content((), [$P_1$], anchor: "west", padding: 0.15)
            point(dots.at(2))
            content((), [$P_2$], anchor: "south", padding: 0.15)
            point(dots.at(3))
            content((), [$P_3$], anchor: "north", padding: 0.15)
            point(dots.at(4))
            content((), [$P_4$], anchor: "north", padding: 0.15)

            line(dots.at(0), dots.at(2), stroke: (dash: "dashed", paint: luma(50%)))
            line(dots.at(1), dots.at(3), stroke: (dash: "dashed", paint: luma(50%)))
            line(dots.at(4), dots.at(0), stroke: (dash: "dashed", paint: luma(50%)))

            content((1.5, -2.7), align(center)[Кривая находится \ в пятиугольнике $P_0 P_2 P_1 P_3 P_4$])
        })
    ],
  )

- Симметрия при смене порядка обхода ломаной

- Кусочная гладкость. Польза этого свойства заключается в том, что кривые Безье допускают гладкое сочленение двух кривых

#Def Сплайн -- составная кривая, гладкая в точках стыка


#align(center)[#cetz.canvas(length: 1.5cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 1pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
    )

    // First cubic Bézier curve (blue)
    let dots1 = ((0,0), (1,1.5), (2,1.5), (3,0))

    // Second cubic Bézier curve (red), sharing endpoint with first
    let dots2 = ((3,0), (3.5,-0.75), (5,1), (6,1))

    // Control polygon of first curve
    line(dots1.at(0), dots1.at(1))
    line(dots1.at(1), dots1.at(2))
    line(dots1.at(2), dots1.at(3))

    // Control polygon of second curve
    line(dots2.at(0), dots2.at(1))
    line(dots2.at(1), dots2.at(2))
    line(dots2.at(2), dots2.at(3))

    // Draw the two Bézier segments
    bezier_custom(..dots1, stroke: (paint: blue, thickness: 3pt), iters: 100)
    bezier_custom(..dots2, stroke: (paint: red, thickness: 3pt), iters: 100)

    // Label control points
    point(dots1.at(0))
    content((), [$P_0$], anchor: "east", padding: 0.15)
    point(dots1.at(1))
    content((), [$P_1$], anchor: "south", padding: 0.15)
    point(dots1.at(2))
    content((), [$P_2$], anchor: "south", padding: 0.15)

    point(dots1.at(3))               // junction point
    content((), [$attach(limits(P_3 = Q_0), b: "точка стыка")$], anchor: "east", padding: 0.15)

    point(dots2.at(1))
    content((), [$Q_1$], anchor: "north", padding: 0.15)
    point(dots2.at(2))
    content((), [$Q_2$], anchor: "south", padding: 0.15)
    point(dots2.at(3))
    content((), [$Q_3$], anchor: "south", padding: 0.15)
})]

#Nota Геометрически, гладкость эквивалентна спрямляемости, то есть в малой окрестности кривая - это почти прямая

Тогда сформулируем правило: чтобы построить сплайн Безье, нужно состыковать кривые $B_1 (t)$ и $B_2 (t)$ так, что предпоследняя опорная точка $P_(n - 1)$ кривой $B_1 (t)$, вторая опорная точка $Q_1$ кривой $B_2 (t)$ и точка стыка $P_n = Q_0$ были расположены на одной прямой (то есть коллинеарно)

#Nota Окружность и эллипс нельзя в точности представить кривыми Безье

==== 1.6.4 Дискретизация (растровое изображение) линий

Рассмотрим построение отрезка прямой с известным наклоном или проходящей через две данные точки на экране в пикселях

#let hatching(anchor_point, square_size, step) = {
    let (x0, y0) = anchor_point
    let x1 = x0 + square_size
    let y1 = y0 + square_size

    let c_min = y0 - x1
    let c_max = y1 - x0
    let n = int((c_max - c_min) / step) + 1

    for i in range(0, n) {
        let c = c_min + i * step
        let x_start = if x0 >= y0 - c { x0 } else { y0 - c }
        let x_end   = if x1 <= y1 - c { x1 } else { y1 - c }
        if x_start < x_end {
            cetz.draw.line((x_start, x_start + c), (x_end, x_end + c), stroke: (dash: "dashed", paint: luma(50%)))
        }
    }
}

+ Естественный алгоритм

  Нам известно уравнение прямой $(x - x_A)/(x_B - x_A) = (y - y_A)/(y_B - y_A)$

  Если выразим $y$ через $x$, получим $y = y_A + (y_B - y_A)/(x_B - x_A) (x - x_A)$ -- деление, из-за которого мы вынуждены округлять при выборе пикселя для $y$

  #align(center)[#cetz.canvas(length: 2cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 1pt, cap: "round"),
        content: (padding: 0.13, font: 17pt),
    )

    line((-0.2, 0), (3, 0), mark: (end: "stealth"))
    content((), [$x$], anchor: "north")
    line((0, -0.2), (0, 2), mark: (end: "stealth"))
    content((), [$y$], anchor: "east")

    point((0, 0), name: "O")
    content((), [$O$], anchor: "north-east")
    
    let dots = ((0.4, 0.7), (2.2, 1.4))

    let incline = vecsum(dots.at(1), veck(dots.at(0), -1))

    grid((0.5,0), (2,2), step: .5, stroke: (dash: "dashed", paint: luma(50%)))

    hatching((0.5, 0.5), 0.5, 0.133)
    hatching((1, 0.5), 0.5, 0.133)
    hatching((1, 1), 0.5, 0.133)
    hatching((1.5, 1), 0.5, 0.133)

    line(vecsum(dots.at(0), veck(incline, -0.5)), vecsum(dots.at(1), veck(incline, 0.8)), stroke: (thickness: 2.5pt))

    point(dots.at(0), name: "A")
    content((), [$A$], anchor: "south-east")
    point(dots.at(1), name: "B")
    content((), [$B$], anchor: "south")
  })]

  Лучше использовать алгоритм Брезенхэма

+ Алгоритм Брезенхэма

    Считаем, что $k in [0, 1]$, то есть прямая ближе к оси $O x$, чем к $O y$. При $k in [1, infinity)$ и $k < 0$ алгоритм аналогичен

    #align(center)[
    #cetz.canvas(length: 3cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round"),
            content: (padding: 0.13, font: 17pt),
        )

        let dots = ((0, 0), (2.7, 1.3))

        let incline = vecsum(dots.at(1), veck(dots.at(0), -1))

        grid((1.2,0), (2.2,1.5), step: .5, stroke: (dash: "dashed", paint: luma(50%)))

        let P = (1.2, 0.5)
        let size = 0.5
        let step = 0.1      // шаг между линиями штриховки

        hatching(P, size, step)


        line((-0.2, 0), (3, 0), mark: (end: "stealth"))
        content((), [$x$], anchor: "north")
        line((0, -0.2), (0, 2), mark: (end: "stealth"))
        content((), [$y$], anchor: "east")

        line(vecsum(dots.at(0), veck(incline, -0.1)), vecsum(dots.at(1), veck(incline, 0.1)))

        point(dots.at(1), name: "B")
        content((), [$B (x_2, y_2)$], anchor: "south")
        point((0, 0), name: "O")
        content((), [$O (x_1, y_1)$], anchor: "south-east")

        point((1.7, 0.5))
        content((), [$S_i$], anchor: "north-east", padding: 0.07)
        point((1.7, 1))
        content((), [$T_i$], anchor: "south-east", padding: 0.07)
        point((1.7, 0))
        content((), [$R$], anchor: "south-east", padding: 0.07)
        point((1.2, 0.5))
        content((rel: (0.05, -0.02)), [$P_(i-1)$], anchor: "north-east", padding: 0.07)

        point((1.7, incline.at(1) / incline.at(0) * 1.7), fill: blue)
        content((rel: (0, -0.15)), text(blue)[$M_i$], anchor: "west", padding: 0.01)

        content((1.2, 0), [$r$], anchor: "north")
        content((1.7, 0), [$r + 1$], anchor: "north")

        line((0, 0.5), (1.2, 0.5), stroke: (dash: "dashed", paint: luma(50%)))
        content((0, 0.5), [$q$], anchor: "east")
        line((0, 1), (1.2, 1), stroke: (dash: "dashed", paint: luma(50%)))
        content((0, 1), [$q + 1$], anchor: "east")

        content((1.95, 0.75), [?])
        content((1.95, 1.25), [?])
    })]

    Сделаем допущение, что начало координат находится в точке $(x_1, y_1)$. Пусть на предыдущем шаге мы выбрали пиксель $P_(i-1)$ с координатами $(r, q)$ в системе $O x y$. Тогда соседними кандидатами на следующем шаге будут $S_i (r+1, q)$ и $T_i (r+1, q+1)$

    Алгоритм сводится к тому, что бы из двух пикселей $S_i$ и $T_i$ выбрать тот, который ближе к точке $M_i$

    Введем величину $Delta_i = S - T$, где $S = |S_i - M_i|$, $T = |T_i - M_i|$ -- расстояния от точки $M_i$ до соответствующих пикселей

    Если $Delta_i >= 0$, то есть $S >= T$, выбираем пиксель $T_i$, иначе -- $S_i$

    #v(5mm)

    Из подобия треугольников получаем пропорцию:
    $k = (d y)/(d x) = (M_i R)/(O R) = (q + S)/(r + 1)$

    Отсюда $S = (d x)/(d y) (r+1) - q$

    Так как $S + T = 1$, $T = 1 - S$. Умножая разность $S - T$ на $d x$, получаем $d x (S - T) = 2(r+1) d y - (2q+1) d y$

    Если $d x > 0$, знак $Delta_i = S - T$ совпадает со знаком $d x dot Delta_i$. Обозначим $d_i = d x dot Delta_i$, тогда $d_i = 2(r+1) d y - (2q+1) d x$

    На следующем шаге $(i+1)$ координаты текущего пикселя будут $(x_i, y_i)$, тогда $d_(i+1) = 2x_i d y - 2y_i d x + 2d y - d x$

    Из этого $d_(i+1) - d_i = 2 underbrace((x_i - x_(i-1)), =1) d y - 2(y_i - y_(i-1)) d x$, то есть $d_(i+1) = d_i + 2d y - 2(y_i - y_(i-1)) d x$

    Здесь возможны два случая:
    - Если $d_i >= 0$, выбираем пиксель $T_i$ с координатами $(x_i, y_i)$. Тогда приращение координаты $y$ равно 1, и формула упрощается: $d_(i+1) = d_i + 2(d y - d x)$
    - Если $d_i < 0$, выбираем пиксель $S_i$ с координатами $(x_i, y_(i-1))$. Здесь $y_i = y_(i-1)$, поэтому $d_(i+1) = d_i + 2d y$

    Начальное значение $d_1$ вычисляется для первого шага $i=1$ как $d_1 = 2d y - d x$

    
  #align(center)[#cetz.canvas(length: 2.5cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 1pt, cap: "round"),
        content: (padding: 0.13, font: 17pt),
    )

    line((-0.2, 0), (3.5, 0), mark: (end: "stealth"))
    content((), [$x$], anchor: "north")
    line((0, -0.2), (0, 2), mark: (end: "stealth"))
    content((), [$y$], anchor: "east")

    point((0, 0), name: "O")
    content((), [$O$], anchor: "north-east")
    
    let dots = ((0, 0), (4.2, 1.7))

    let incline = vecsum(dots.at(1), veck(dots.at(0), -1))

    grid((0,0), (4,2), step: .5, stroke: (dash: "dashed", paint: luma(50%)))

    hatching((0, 0), 0.5, 0.133)
    hatching((0.5, 0), 0.5, 0.133)
    hatching((1, 0.5), 0.5, 0.133)
    hatching((1.5, 0.5), 0.5, 0.133)
    hatching((2, 1), 0.5, 0.133)
    hatching((2.5, 1), 0.5, 0.133)
    hatching((3, 1), 0.5, 0.133)
    hatching((3.5, 1.5), 0.5, 0.133)

    line(vecsum(dots.at(0), veck(incline, -0.1)), vecsum(dots.at(1), veck(incline, 0.1)), stroke: (thickness: 2.5pt))

    point(dots.at(0), name: "A")
    content((), [$A$], anchor: "south-east")
    point(dots.at(1), name: "B")
    content((), [$B$], anchor: "south")
  })]



