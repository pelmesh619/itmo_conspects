#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [18.03.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

=== 2.2 Локализация точки в многоугольнике

==== 2.2.1 Локализация точки в прямоугольнике

Задача состоит в том, чтобы понять, находится ли точка на плоскости внутри прямоугольника, стороны которого ориентированы параллельно координатным осям

// картинка прямоугольника и точки


#align(center)[#cetz.canvas(length: 1.3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  line((0, -0.3), (0, 5), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "east")
  line((-0.3, 0), (7, 0), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  let dots = ((0.5, 0.7), (3.5, 4.5), (3, 2), (6, 4), (4.2, 2.4), (1.1, 4), (3.8, 1.3), (5.4, 0.8), (2, 0.15), (1, 2.4), (4, 0.3), (6.5, 2.6))

  let rect_dots = ((1.5, 1), (5, 3.5))
  rect(..rect_dots, stroke: (paint: luma(30%), thickness: 2pt))

  for (i, p) in dots.enumerate() {
    point(p)
    content((), [$P_(#(i + 1))$], anchor: "south", padding: 0.18)
  }

  line((rect_dots.at(0).at(0), 0), (rect_dots.at(0).at(0), rect_dots.at(0).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((rect_dots.at(0).at(0), 0), [$a$], anchor: "north", padding: 0.18)

  line((rect_dots.at(1).at(0), 0), (rect_dots.at(1).at(0), rect_dots.at(0).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((rect_dots.at(1).at(0), 0), [$b$], anchor: "north", padding: 0.18)

  line((0, rect_dots.at(0).at(1)), (rect_dots.at(0).at(0), rect_dots.at(0).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((0, rect_dots.at(0).at(1)), [$c$], anchor: "east", padding: 0.23)

  line((0, rect_dots.at(1).at(1)), (rect_dots.at(0).at(0), rect_dots.at(1).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((0, rect_dots.at(1).at(1)), [$b$], anchor: "east", padding: 0.23)

})]

Для точки $P_i (x, y)$ принадлежность определяется условиями $cases(a <= x <= b, c <= y <= d)$

Можно упорядочиться процесс для определения принадлежности $P_i$ ячейки прямоугольной сетки. Вводим отношение -- "точка $M$ доминирует над точкой $N$" или $N^M arrow.l.r.long.double cases(x_N <= x_M, y_N <= y_M)$

Тогда найдем в прямоугольнике доминирующую вершину $hat(R)$ (правый верхний угол). Обозначим $M(R)$ как множество точек, доминируемых вершиной $R$, а $Q(R)$ как количество этих точек

// картинка прямоугольник hat(R), R_0, R_1, R_2

#align(center)[#cetz.canvas(length: 1.3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let dots = ((0.5, 0.7), (3.5, 4.5), (3, 2), (6, 4), (4.2, 2.4), (1.1, 4), (3.8, 1.3), (5.7, 0.8), (2, 0.15), (1, 2.4), (4, 0.3), (6.5, 2.6))

  let rect_dots = ((1.5, 1), (5, 3.5))

  hatching((0, 0), rect_dots.at(0), 0.3, angle: 90deg, stroke-style: (paint: blue, dash: "dashed"))
  hatching((0, 0), rect_dots.at(1), 0.45, angle: 0deg, stroke-style: (paint: green, dash: "dashed"))
  hatching((0, 0), (rect_dots.at(1).at(0), rect_dots.at(0).at(1)), 0.45, angle: 30deg, stroke-style: (paint: red, dash: "dashed"))
  hatching((0, 0), (rect_dots.at(0).at(0), rect_dots.at(1).at(1)), 0.45, angle: -30deg, stroke-style: (paint: orange, dash: "dashed"))

  line((0, -0.3), (0, 5), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "east")
  line((-0.3, 0), (7, 0), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  rect(..rect_dots, stroke: (paint: luma(30%), thickness: 2pt))

  for (i, p) in dots.enumerate() {
    let fill_color = if (p.at(0) < rect_dots.at(0).at(0) and p.at(1) < rect_dots.at(0).at(1)) {
      blue
    } else if (p.at(0) < rect_dots.at(0).at(0) and p.at(1) < rect_dots.at(1).at(1)) {
      orange
    } else if (p.at(0) < rect_dots.at(1).at(0) and p.at(1) < rect_dots.at(0).at(1)) {
      red
    } else if (p.at(0) < rect_dots.at(1).at(0) and p.at(1) < rect_dots.at(1).at(1)) {
      green
    } else {
      gray
    }

    point(p, fill: fill_color)

    content((), text(0.7em)[$P_(#(i + 1))$], anchor: "south", padding: 0.18)
  }

  line((rect_dots.at(0).at(0), 0), (rect_dots.at(0).at(0), rect_dots.at(0).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((rect_dots.at(0).at(0), 0), [$a$], anchor: "north", padding: 0.18)

  line((rect_dots.at(1).at(0), 0), (rect_dots.at(1).at(0), rect_dots.at(0).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((rect_dots.at(1).at(0), 0), [$b$], anchor: "north", padding: 0.18)

  line((0, rect_dots.at(0).at(1)), (rect_dots.at(0).at(0), rect_dots.at(0).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((0, rect_dots.at(0).at(1)), [$c$], anchor: "east", padding: 0.23)

  line((0, rect_dots.at(1).at(1)), (rect_dots.at(0).at(0), rect_dots.at(1).at(1)), stroke: (dash: "dashed", paint: luma(60%)))
  content((0, rect_dots.at(1).at(1)), [$b$], anchor: "east", padding: 0.23)

  point(rect_dots.at(0), fill: luma(30%))
  content((), [$R_0$], anchor: "south-west", padding: 0.1)
  point((rect_dots.at(1).at(0), rect_dots.at(0).at(1)), fill: luma(30%))
  content((), [$R_2$], anchor: "south-west", padding: 0.1)
  point((rect_dots.at(0).at(0), rect_dots.at(1).at(1)), fill: luma(30%))
  content((), [$R_1$], anchor: "south-west", padding: 0.1)
  point(rect_dots.at(1), fill: luma(30%))
  content((), [$hat(R)$], anchor: "south-west", padding: 0.1)

})]


Тогда, чтобы найти, сколько точек находятся в прямоугольнике, воспользуемся формулой $#text(green)[$Q(hat(R))$] - #text(orange)[$Q(R_1)$] - #text(red)[$Q(R_2)$] + #text(blue)[$Q(R_0)$]$. А само множество задается как $#text(green)[$M(hat(R))$] - #text(orange)[$M(R_1)$] - #text(red)[$M(R_2)$] + #text(blue)[$M(R_0)$]$

==== 2.2.2 Локализация точки в $n$-угольнике

Есть несколько методов:

1. Габаритный метод

    Пусть есть выпуклый $n$-угольник $cal(N)$, нужно понять, находится ли точка внутри многоугольника

    // картинка 

    #align(center)[#cetz.canvas(length: 1.3cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        line((0, -0.3), (0, 5), mark: (end: ">"))
        content((), [$x$], padding: 0.15, anchor: "east")
        line((-0.3, 0), (7, 0), mark: (end: ">"))
        content((), [$y$], padding: 0.15, anchor: "north")
        point((0, 0), name: "O")
        content((), [$O$], padding: 0.15, anchor: "north-east")

        let dots = ((1.5, 3.5), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 0.8), (1, 1.7))

        rect((calc.min(..dots.map(it => it.at(0))), calc.min(..dots.map(it => it.at(1)))), (calc.max(..dots.map(it => it.at(0))), calc.max(..dots.map(it => it.at(1)))), stroke: (thickness: 1.5pt, dash: "dashed", paint: luma(50%)))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "p0"
        for (i, p) in dots.enumerate() {
            point(p, name: "p" + str(i))

            let anch = if (p.at(1) >= y_avg) { "south" } 
            else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
            else if (p.at(0) < x_avg) { "-east" } 
            else { "" }

            content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
            if (i != 0) {
                line(prev, "p" + str(i), stroke: (thickness: 2pt, paint: luma(30%)))
                prev = "p" + str(i)
            }
        }
        line(prev, "p0", stroke: (thickness: 2pt, paint: luma(30%)))

        point((6, 3), name: "P1", fill: blue)
        content((), [$P$], anchor: "south", padding: 0.18)
        point((3, 2), name: "P2", fill: green)
        content((), [$P'$], anchor: "south", padding: 0.18)
        point((4, 1), name: "P3", fill: blue)
        content((), [$P''$], anchor: "north", padding: 0.22)

    })]

    Необходимым условием принадлежности точки внутри многоугольника -- принадлежность точки внутри прямоугольника, которые описывает многоугольник. То есть можно проверить условия $x_P < x_(min)$, $x_P > x_(max)$, $y_P < y_(min)$, $y_P > y_(max)$

    Такой метод работает всего лишь для отсева непринадлежащих точек, но не поможет различить принадлежность точек $P'$ и $P''$

2. Угловой метод

    Возьмем произвольную точку $T$ внутри выпуклого многоугольника, например, центр тяжести одного из вписанного треугольника или угодно другую, которую легко определить 

    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        line((0, -0.3), (0, 5), mark: (end: ">"))
        content((), [$x$], padding: 0.15, anchor: "east")
        line((-0.3, 0), (7, 0), mark: (end: ">"))
        content((), [$y$], padding: 0.15, anchor: "north")
        point((0, 0), name: "O")
        content((), [$O$], padding: 0.15, anchor: "north-east")

        let dots = ((1.5, 3.5), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 0.8), (1, 1.7))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "N0"
        for (i, p) in dots.enumerate() {
            let name = "N" + str(i)
            point(p, name: name)

            let anch = if (p.at(1) >= y_avg) { "south" } 
            else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
            else if (p.at(0) < x_avg) { "-east" } 
            else { "" }

            content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
            if (i != 0) {
                line(prev, name, stroke: (thickness: 2pt, paint: luma(30%)))
                prev = name
            }
        }
        line(prev, "N0", stroke: (thickness: 2pt, paint: luma(30%)))

        point((4, 3.2), name: "P", fill: green)
        content((), [$P$], anchor: "south", padding: 0.18)

        line("N0", "N3", stroke: (dash: "dashed", paint: luma(60%)))
        line("N5", "N3", stroke: (dash: "dashed", paint: luma(60%)))

        get-ctx(ctx => {
            let (ctx, ..d) = cetz.coordinate.resolve(ctx, "N0", "N3", "N5")

            point((
                d.map(it => it.at(0)).sum() / d.len(),
                d.map(it => it.at(1)).sum() / d.len()
            ))
            content((), [$T$], anchor: "north-west", padding: 0.18)
        })
    })]

    Из этой точки выпускаем лучи $T N_i$ и луч $T P$
    
    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        line((0, -0.3), (0, 5), mark: (end: ">"))
        content((), [$x$], padding: 0.15, anchor: "east")
        line((-0.3, 0), (7, 0), mark: (end: ">"))
        content((), [$y$], padding: 0.15, anchor: "north")
        point((0, 0), name: "O")
        content((), [$O$], padding: 0.15, anchor: "north-east")

        let dots = ((1.5, 3.5), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 0.8), (1, 1.7))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "N0"
        for (i, p) in dots.enumerate() {
            let name = "N" + str(i)
            point(p, name: name)

            let anch = if (p.at(1) >= y_avg) { "south" } 
            else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
            else if (p.at(0) < x_avg) { "-east" } 
            else { "" }

            content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
            if (i != 0) {
                line(prev, name, stroke: (thickness: 2pt, paint: luma(30%)))
                prev = name
            }
        }
        line(prev, "N0", stroke: (thickness: 2pt, paint: luma(30%)))

        point((4, 3.2), name: "P", fill: green)
        content((), [$P$], anchor: "south", padding: 0.18)

        get-ctx(ctx => {
            let (ctx, ..d) = cetz.coordinate.resolve(ctx, "N0", "N3", "N5")

            let T = (
                d.map(it => it.at(0)).sum() / d.len(),
                d.map(it => it.at(1)).sum() / d.len()
            )
            point(T, name: "T")
            content((), [$T$], anchor: "north-west", padding: 0.18)

            let cont_ks = (2, 1.5, 1.5, 2, 2, 2)
            for (i, N_i) in dots.enumerate() {
                let cont = veck(vecsum(N_i, veck(T, -1)), cont_ks.at(i))
                line("T", vecsum(cont, T), stroke: (dash: "dashed", paint: luma(40%)))
                point(N_i)
            }
        })
    })]

    В выпуклом многоугольнике углы между лучами к вершинам и осью $O x$ будут упорядочены (такое не работает для невыпуклого многоугольника), поэтому, записав порядок углов для вершин $N_i$, находим угол $phi_P$ для луча $T P$ и углы $phi_i$, $phi_(i + 1)$ такие, что $phi_i <= phi_P <= phi_(i + 1)$

    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        line((0, -0.3), (0, 5), mark: (end: ">"))
        content((), [$x$], padding: 0.15, anchor: "east")
        line((-0.3, 0), (7, 0), mark: (end: ">"))
        content((), [$y$], padding: 0.15, anchor: "north")
        point((0, 0), name: "O")
        content((), [$O$], padding: 0.15, anchor: "north-east")

        let dots = ((1.5, 3.5), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 0.8), (1, 1.7))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "N0"
        for (i, p) in dots.enumerate() {
            let name = "N" + str(i)
            point(p, name: name)

            let anch = if (p.at(1) >= y_avg) { "south" } 
            else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
            else if (p.at(0) < x_avg) { "-east" } 
            else { "" }

            content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
            if (i != 0) {
                line(prev, name, stroke: (thickness: 2pt, paint: luma(30%)))
                prev = name
            }
        }
        line(prev, "N0", stroke: (thickness: 2pt, paint: luma(30%)))

        point((4, 3.2), name: "P", fill: green)
        content((), [$P$], anchor: "south", padding: 0.18)

        get-ctx(ctx => {
            let (ctx, ..d) = cetz.coordinate.resolve(ctx, "N0", "N3", "N5")

            let T = (
                d.map(it => it.at(0)).sum() / d.len(),
                d.map(it => it.at(1)).sum() / d.len()
            )
            point(T, name: "T")
            content((), [$T$], anchor: "north-west", padding: 0.18)

            let cont_ks = (2, 1.5, 1.5, 2, 2, 2)
            for (i, N_i) in dots.enumerate() {
                let cont = veck(vecsum(N_i, veck(T, -1)), cont_ks.at(i))
                line("T", vecsum(cont, T), stroke: (dash: "dashed", paint: luma(40%)))
                point(N_i)
            }
            
            line("T", vecsum(T, (5, 0)), mark: (end: ">", stroke: (thickness: 0pt)), stroke: (dash: ("dot", 5pt, 5pt)), name: "Tx")

            let cont_P = veck(vecsum(cetz.coordinate.resolve(ctx, "P").at(1), veck(T, -1)), 2.3)
            line("T", vecsum(cont_P, T), stroke: (dash: "dashed", paint: luma(40%)))

            cetz.angle.angle("T", "Tx.end", "P", label: text(0.7em)[$phi_P$], label-radius: 1.55, radius: 1.25)
            cetz.angle.angle("T", "Tx.end", "N2", label: text(0.7em)[$phi_2$], label-radius: 2.3, radius: 2)
            cetz.angle.angle("T", "Tx.end", "N1", label: text(0.7em)[$phi_1$], label-radius: 1, radius: 0.7)

            point("P", fill: green)
            
        })
    })]


    Тогда точка $P$ лежит в секторе $N_i T N_(i + 1)$. Далее с помощью косого произведения определяем, лежит ли точка $P$ в треугольнике $N_i T N_(i + 1)$, то не пересекаются ли отрезки $T P$ и $N_i N_(i + 1)$

    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        let dots = ((1.5, 3.5), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 0.8), (1, 1.7))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "N0"
        for (i, p) in dots.enumerate() {
            let name = "N" + str(i)

            let anch = if (p.at(1) >= y_avg) { "south" } 
            else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
            else if (p.at(0) < x_avg) { "-east" } 
            else { "" }

            if (i >= 1 and i <= 2) {
                point(p, name: name)
                content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
                if (i != 1) {
                    line(prev, name, stroke: (thickness: 2pt, paint: luma(30%)))
                }
                prev = name
            }
        }

        point((4, 3.2), name: "P", fill: green)
        content((), [$P$], anchor: "south", padding: 0.18)

        let d = (dots.at(0), dots.at(3), dots.at(5))
        let T = (
            d.map(it => it.at(0)).sum() / d.len(),
            d.map(it => it.at(1)).sum() / d.len()
        )
        point(T, name: "T")
        content((), [$T$], anchor: "north-west", padding: 0.18)

        let cont_ks = (2, 1.5, 1.5, 2, 2, 2)
        for (i, N_i) in dots.enumerate() {
            if (i == 1 or i == 2) {
                let cont = veck(vecsum(N_i, veck(T, -1)), cont_ks.at(i))
                line("T", vecsum(cont, T), stroke: (dash: "dashed", paint: luma(40%)))
                point(N_i)
            }
        }

        line("T", "P")
        point((5.2, 5), name: "Pp")
        content((), [$P'$], anchor: "north-west", padding: 0.12)
        line("T", "Pp", stroke: (paint: red))
    })]

    #grid(columns: (1fr, auto),
        [
            В звездчатом многоугольнике такой метод также работает, если выбрать точку в центре, но в произвольном невыпуклом (особенно с самопересечениями) такое не сработает

            Если работа с углами представляет неудобства (так как синусы большинства углов -- величины трансцендентные), то можно сравнивать ориентированные площади
        ],
        [
        #align(center)[#cetz.canvas(length: 1.2cm, {
            import cetz.draw: *

            set-style(
                mark: (fill: black, scale: 2),
                stroke: (thickness: 1pt, cap: "round")
            )

            let radius = 2
            let angle = 90deg
            let dangle = 360deg / 5

            n-star((0,0), 5, angle: -360deg / 20, radius: radius, name: "star")

            point((0.1, -0.2), name: "T")
            content((), [$T$], anchor: "south", padding: 0.18)

            for i in range(5) {
                point((radius * calc.cos(angle), radius * calc.sin(angle)), name: "cor" + str(i))
                angle += dangle
                line("T", "cor" + str(i), stroke: (thickness: 0.7pt, dash: "dashed", paint: luma(60%)))
            }

            let angle = 360deg / 10 + 90deg
            for i in range(5) {
                point((radius / 2 * calc.cos(angle), radius / 2 * calc.sin(angle)), name: "cen" + str(i))
                angle += dangle
                line("T", "cen" + str(i), stroke: (thickness: 0.7pt, dash: "dashed", paint: luma(60%)))
            }
        })]
        ]
    )

    Ориентированная площадь имеет знак в зависимости от направление обхода ломаной, поэтому, если площади треугольников $triangle P T N_i$, $triangle P N_i N_(i + 1)$ и $triangle P N_(i + 1) T$ одних знаков, то точка находится внутри $triangle T N N_(i + 1)$

3. Лучевой метод

    Лучевой метод заключается в выпускании луча из данной точки в произвольном направлении (например, в направлении $O x$). Считаем, что если луч пересек ребра выпуклого многоугольника нечетное число раз (то есть ровно один), то точка находится внутри многоугольника

    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        let dots = ((1.5, 3), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 0.8), (1, 1.7))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "p0"

        group(name: "polygon", {
            for (i, p) in dots.enumerate() {
                point(p, name: "p" + str(i))

                let anch = if (p.at(1) >= y_avg) { "south" } 
                else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
                else if (p.at(0) < x_avg) { "-east" } 
                else { "" }

                content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
                if (i != 0) {
                    line(prev, "p" + str(i), stroke: (thickness: 2pt, paint: luma(30%)))
                    prev = "p" + str(i)
                }
            }

            line(prev, "p0", stroke: (thickness: 2pt, paint: luma(30%)))
        })

        point((6, 3), name: "P1", fill: blue)
        content((), [$P_1$], anchor: "south", padding: 0.18)
        line("P1", (rel: (3, 0)), stroke: (paint: luma(60%), dash: "dashed"), mark: (end: ">", stroke: (thickness: 0pt), fill: luma(60%)), name: "line1")

        point((3, 2), name: "P2", fill: green)
        content((), [$P_2$], anchor: "south", padding: 0.18)
        line("P2", (rel: (3, 0)), stroke: (paint: luma(60%), dash: "dashed"), mark: (end: ">", stroke: (thickness: 0pt), fill: luma(60%)), name: "line2")

        intersections("i2", "polygon", "line2")
        for-each-anchor("i2", (name) => {
            mark("i2." + name, (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        })

        point((1.4, 4), name: "P3", fill: blue)
        content((), [$P_3$], anchor: "south", padding: 0.22)
        line("P3", (rel: (5, 0)), stroke: (paint: luma(60%), dash: "dashed"), mark: (end: ">", stroke: (thickness: 0pt), fill: luma(60%)), name: "line3")

        intersections("i3", "polygon", "line3")
        for-each-anchor("i3", (name) => {
            mark("i3." + name, (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        })
    })]

    Здесь есть случай с подвохом: луч пересекает какую-либо вершину многоугольника (в том числе какое-либо ребро). В этом случае ординату вершины уменьшаем или увеличиваем на бесконечно малую величину:

    // картинка

    #grid(align: center, columns: (1fr, 1fr),
    [
    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        let dots = ((2.5, 4.5), (3.5, 4.5), (5, 3), (4.4, 1.6), (2, 1.2), (1, 2.5))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "p0"

        for (i, p) in dots.enumerate() {
            point(p, name: "p" + str(i))

            if (i != 0) {
                line(prev, "p" + str(i), stroke: (thickness: 2pt, paint: luma(30%)))
                prev = "p" + str(i)
            }
        }

        line(prev, "p0", stroke: (thickness: 2pt, paint: luma(30%)))

        for (i, p) in dots.enumerate() {
            let anch = if (p.at(1) >= y_avg) { "south" } 
                else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
                else if (p.at(0) < x_avg) { "-east" } 
                else { "" }
            content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
        }

        point((1, 4.5), name: "P1", fill: blue)
        content((), [$P_1$], anchor: "south", padding: 0.18)
        line("P1", (rel: (5, 0)), stroke: (paint: luma(60%), dash: "dashed"), mark: (end: ">", stroke: (thickness: 0pt), fill: luma(60%)), name: "line1")

        mark("p1", (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        mark("p0", (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        mark(("p0", 25%, "p1"), (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        mark(("p0", 50%, "p1"), (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        mark(("p0", 75%, "p1"), (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
    })]
    ], [
    #align(center)[#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        let dots = ((2.5, 4.7), (3.5, 4.3), (5, 3), (4.4, 1.6), (2, 1.2), (1, 2.5))

        let x_avg = dots.map(it => it.at(0)).sum() / dots.len()
        let y_avg = dots.map(it => it.at(1)).sum() / dots.len()

        let prev = "p0"

        for (i, p) in dots.enumerate() {
            point(p, name: "p" + str(i))

            if (i != 0) {
                line(prev, "p" + str(i), stroke: (thickness: 2pt, paint: luma(30%)), name: prev + "p" + str(i))
                prev = "p" + str(i)
            }
        }

        line(prev, "p0", stroke: (thickness: 2pt, paint: luma(30%)), name: "p5p0")

        for (i, p) in dots.enumerate() {
            let anch = if (p.at(1) >= y_avg) { "south" } 
                else if (p.at(1) < y_avg) { "north" } + if (p.at(0) > x_avg) { "-west" }
                else if (p.at(0) < x_avg) { "-east" } 
                else { "" }
            content(p, [$N_(#(i + 1))$], anchor: anch, padding: 0.18)
        }

        point((1, 4.5), name: "P1", fill: blue)
        content((), [$P_1$], anchor: "south", padding: 0.18)
        line("P1", (rel: (5, 0)), stroke: (paint: luma(60%), dash: "dashed"), mark: (end: ">", stroke: (thickness: 0pt), fill: luma(60%)), name: "line1")

        intersections("i1", "line1", "p0p1")
        for-each-anchor("i1", (name) => {
            mark("i1." + name, (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        })
        intersections("i2", "line1", "p5p0")
        for-each-anchor("i2", (name) => {
            mark("i2." + name, (rel: (0.05, 0)), symbol: "x", stroke: red + 2.5pt)
        })

        line("p0", (rel: (0, 0.5)), mark: (end: ">", fill: luma(60%), stroke: 0pt, scale: 1), stroke: (paint: luma(60%)))
        line("p1", (rel: (0, -0.5)), mark: (end: ">", fill: luma(60%), stroke: 0pt, scale: 1), stroke: (paint: luma(60%)))
        
    })]
    ],
    )



