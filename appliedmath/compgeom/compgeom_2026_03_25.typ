#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [25.03.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

=== 2.3 Выпуклые оболочки

Рассмотрим точечное множество $M = {M_1, dots, M_n}$

#Mem Выпуклое множество -- такое множество, в котором для любых $M_i, M_j in M$ отрезок $M_i M_j$ тоже принадлежит множеству $M$

#grid(columns: (1fr, auto),
    [#Nota Также выпуклое множество -- множество, где линейная (или аффинная) комбинация любых точек принадлежит множеству: $forall M_(i_1), ..., M_(i_k) in M$
    
    $sum_(j = 1)^k lambda_j M_(i_j) in M$ для всех $lambda_i >= 0$ таких, что $sum_(i = 1)^k lambda_i = 1$],
    [#cetz.canvas(length: 1.3cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 1pt, cap: "round")
        )

        point((0, 0), name: "M1")
        content((), [$M_1$], anchor: "south", padding: 0.13)
        point((2, 1), name: "M2")
        content((), [$M_2$], anchor: "south", padding: 0.13)
        line("M1", "M2")

        point(("M1", 60%, "M2"), name: "M3")
        content((), [$M' = lambda M_1 + mu M_2$], anchor: "north-west", padding: 0.13)
    })]
)

#v(10mm)

#grid(columns: (auto, auto, auto), column-gutter: 2em,
    [#Ex],
    [#cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 1),
            stroke: (thickness: 1pt, cap: "round")
        )

        bezier((0, 0), (1, 0), (1, 1))
        bezier((0, 0), (1, 0), (-1, -1), (1, -1))

        point((0.2, -0.5), name: "M1")
        content((), [$M_1$], anchor: "east", padding: 0.1)
        point((0.7, 0.35), name: "M2")
        content((rel: (angle: -40deg, radius: 0.18)), [$M_2$], anchor: "north", padding: 0)
        line("M1", "M2")

        content((0.4, -1.1), text(0.9em)[Выпуклое \ множество])
    })], [#cetz.canvas(length: 1cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 1),
            stroke: (thickness: 1pt, cap: "round")
        )

        rotate(z: 45deg)

        point((0.1, 0.4), name: "M1")
        content((), [$M_1$], anchor: "north-east", padding: 0.13)
        point((0.1, 2.6), name: "M2")
        content((), [$M_2$], anchor: "north", padding: 0.25)

        intersections(
            "i", 
            {
                line("M1", "M2", stroke: none)
                group(name: "M", {
                    bezier((0, 0), (0, 1), (1.5, 0))
                    bezier((0, 1), (0, 2), (-0.75, 1.5))
                    bezier((0, 2), (0, 3), (1.5, 3))
                    bezier((0, 0), (0, 3), (-1.8, 0), (-1.8, 3))
                })
            }
        )

        line("i.0", "i.1", stroke: (dash: "dashed", paint: rgb("#ff0000")))
        line("i.1", "M2")
        line("i.0", "M1")

        content((-1.7, 0.1), text(0.9em)[Невыпуклое \ множество])
    })]
)

#let Conv(x) = $op("conv") #x$

#grid(columns: (1fr, auto), column-gutter: 1em,
    [Для данного точечного набора существуют различные выпуклые множества, содержащие набор точек

    #Def Наименьшее из выпуклых множеств $V$, содержащих данное множество $M$, называется выпуклой оболочкой $Conv(M)$ множества $M$
    ],
    [
        // картинка

        #cetz.canvas(length: 0.8cm, {
            import cetz.draw: *

            set-style(
                mark: (fill: black, scale: 1),
                stroke: (thickness: 1pt, cap: "round")
            )

            let dots = ((3.3, 1), (4.9, 1.8), (5.4, 3.6), (3.2, 2.7), (2.1, 1.5), (3.7, 1.8))


            for (i, p) in dots.enumerate() {
                circle(p, name: "M" + str(i), fill: none, stroke: none, radius: 0.1)
            }

            for (i, p) in dots.enumerate() {
                point(p, name: "M" + str(i), fill: gray, radius: 2.5pt)
            }

            let green_points = (0, 1, 2, 3, 4)
            on-layer(-1, {line(..green_points.map(i => "M" + str(i)), "M0", stroke: (paint: red))})

            merge-path(stroke: green, {
                bezier((6, 3), (2.6, 3), (6.8, 6))
                bezier((2.6, 3), (6, 3), (-1.6, 0), (5.2, 0))
            })

            circle((4, 2.3), radius: 2.2, stroke: blue)

            for (i, p) in dots.enumerate() {
                content("M" + str(i), box(fill: rgb("#ffffffbb"), inset: (y: 2pt))[#text(0.9em)[$M_(#i)$]], anchor: "south", padding: 0.2)
            }
        })
    ]
)


#grid(columns: (auto, auto), [#Nota], [
    1. Выпуклая оболочка пустого множества -- пустое множество: $Conv(emptyset) = emptyset$
    2. Выпуклая оболочка множества из точки -- это множество из точки: $Conv({M}) = {M}$
    3. Выпуклая оболочка множества из двух точек -- это отрезок: $Conv({M_1, M_2}) = M_1 M_2$
    4. Выпуклая оболочка в общем случае $Conv({M_i}_(i = 1)^n)$ -- это выпуклый многоугольник
    5. Выпуклая оболочка выпуклого многоугольника -- сам многоугольник
])

#let dots = ((1.3, 1), (3.3, 1), (4.9, 1.8), (5.4, 3.6), (3.2, 2.7), (2.1, 1.5), (3.7, 1.8), (3.7, 3.8), (1.1, 3.2), (2.5, 3.3))

#grid(columns: (auto, auto), 
    [Выделим крайние и внутренние точки множества $M = {M_i}_(i = 1)^n$: крайние точки -- это те точки, что являются вершинами многоугольника, остальные считаем внутренние
    
    Если найти все крайние, тогда построение $Conv(M)$ сводится к их упорядочиванию этих точек и построению ребер    ],
    [
    // картинка
    #align(center)[
        #cetz.canvas(length: 0.71cm, {
            import cetz.draw: *

            set-style(
                mark: (fill: black, scale: 1),
                stroke: (thickness: 1pt, cap: "round")
            )

            let green_points = (0, 1, 2, 3, 7, 8)
            let blue_points = (4, 5, 6, 9)

            line((0, -0.3), (0, 5), mark: (end: ">"))
            content((), [$y$], padding: 0.15, anchor: "east")
            line((-0.3, 0), (7, 0), mark: (end: ">"))
            content((), [$x$], padding: 0.15, anchor: "north")
            point((0, 0), name: "O")
            content((), [$O$], padding: 0.15, anchor: "north-east")

            for (i, p) in dots.enumerate() {
                circle(p, name: "M" + str(i), fill: none, stroke: none, radius: 0.1)
            }

            for (i, p) in dots.enumerate() {
                point(p, name: "M" + str(i), fill: if i in green_points { green } else if i in blue_points { blue } else { gray }, radius: 2.5pt)
            }

            for (i, p) in dots.enumerate() {
                content("M" + str(i), box(fill: rgb("#ffffffbb"), inset: (y: 2pt))[#text(0.9em)[$M_(#i)$]], anchor: "south", padding: 0.2)
            }

            on-layer(-1, {line(..green_points.map(i => "M" + str(i)), "M0", stroke: (dash: "dashed", paint: luma(60%)))})
        })
    ]]
)

#theorem[
    #strong([Критерий.]) Точка $M$ не является крайней (то есть является внутренней) тогда и только тогда, когда существует треугольник $triangle M_i M_j M_k$, для которого

    $M in triangle M_i M_j M_k$ и $M != M_i, M_j, M_k$
]

Действуя по критерию можно найти все внутренние точки, но алгоритм является очень затратным

#v(5mm)

#let graham_dots = ((2, 1), (3.3, 1), (4.9, 1.8), (3.2, 2.7), (5.4, 3.6), (2.3, 3.6))
#let graham_cetroid = graham_dots.at(0)


#let graham_dots_order = (
    range(0, graham_dots.len())
        .map(
            i => vec_angle(
                cetz.vector.add(graham_dots.at(0), (1, 0)), 
                graham_cetroid, 
                graham_dots.at(i)
            )
        )
        .map(i => if i < 0deg { 360deg + i } else { i })
        .enumerate()
        .sorted(key: it => it.at(1))
        .map(it => it.at(0))
)


#let graham_method_pic(
    graham_dots, graham_dots_order,
    green_points, blue_points, caption_dots: "all", other_render: () => {},
    show_coord_sys: true, length: 0.65cm
) = {
    cetz.canvas(length: length, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 1),
            stroke: (thickness: 1pt, cap: "round")
        )

        if show_coord_sys {
            line((0, -0.3), (0, 5), mark: (end: ">"))
            content((), [$y$], padding: 0.15, anchor: "east")
            line((-0.3, 0), (7, 0), mark: (end: ">"))
            content((), [$x$], padding: 0.15, anchor: "north")
            point((0, 0), name: "O")
            content((), [$O$], padding: 0.15, anchor: "north-east")
        }

        for (i, j) in graham_dots_order.enumerate() {
            circle(graham_dots.at(j), name: "M" + str(i), fill: none, stroke: none, radius: 0.1)
        }

        for (i, p) in graham_dots.enumerate() {
            point("M" + str(i), fill: if i in green_points { green } else if i in blue_points { blue } else { gray }, radius: 2.5pt)
        }
        for (i, p) in graham_dots.enumerate() {
            if caption_dots == "all" or i in caption_dots {
                content("M" + str(i), box(fill: rgb("#ffffffbb"), inset: (y: 2pt))[#text(0.6em)[$M_(#i)$]], anchor: "east", padding: 0.23)
            }
        }

        other_render()
    })
}
#let make_triangle(dots, color) = {
    import cetz.draw: *

    on-layer(-1, merge-path(fill: color, 
        for i in dots {
            let next = dots.at(calc.rem(dots.position(it => it == i) + 1, dots.len()))
            line("M" + str(i) + ".center", "M" + str(next) + ".center", stroke: none)
        }
    ))
    on-layer(-1, for i in dots {
        let next = dots.at(calc.rem(dots.position(it => it == i) + 1, dots.len()))
            {
            line("M" + str(i), "M" + str(next), mark: (end: ">"))
        }
    })
}


Рассмотрим такую ситуацию:


#grid(columns: (1fr, auto),
    [1. Проверяем ориентацию $triangle M_0 M_1 M_2$, например, с помощью ориентированной площади $S_triangle = 1/2 mat(delim: "|", x_1, y_1, 1; x_2, y_2, 1; x_3, y_3, 1)$],
    [#graham_method_pic(
        graham_dots, range(graham_dots.len()),
        (0, 1, 2), (), show_coord_sys: false, length: 0.8cm,
        other_render: () => {
            import cetz.draw: *

            let dots = range(0, 3)
            make_triangle(dots, rgb("#ff000088"))
        }
    )],
    [2. Если треугольник $triangle M_0 M_1 M_2$ ориентирован против часовой стрелки, то переходим к $triangle M_1 M_2 M_3$
    3. Если треугольник $triangle M_1 M_2 M_3$ ориентирован против часовой стрелки, то переходим к $triangle M_2 M_3 M_4$],
    [#graham_method_pic(
        graham_dots, range(graham_dots.len()),
        (0, 1, 3, 2), (), show_coord_sys: false, length: 0.8cm,
        other_render: () => {
            import cetz.draw: *

            let dots = range(0, 3)
            make_triangle(dots, rgb("#ff000088"))

            let dots = range(1, 4)
            make_triangle(dots, rgb("#ff000088"))
        }
    )],
    [4. Если треугольник $triangle M_2 M_3 M_4$ ориентирован в другую сторону, то считаем $M_3$ внутренней и рассматриваем треугольник $triangle M_2 M_4 M_5$],
    [#graham_method_pic(
        graham_dots, range(graham_dots.len()),
        (0, 1, 2, 4), (3, ), show_coord_sys: false, length: 0.8cm,
        other_render: () => {
            import cetz.draw: *

            let dots = range(0, 3)
            make_triangle(dots, rgb("#ff000088"))

            let dots = range(1, 4)
            make_triangle(dots, rgb("#ff000088"))

            let dots = range(2, 5)
            make_triangle(dots, rgb("#0000ff88"))
        }
    )]
    
)


#v(10mm)

Итак, алгоритм Грэхема:

#let graham_dots = ((1.3, 1), (3.3, 1), (4.9, 1.8), (5.4, 3.6), (3.2, 2.7), (2.1, 1.5), (3.7, 2.1), (3.7, 3.8), (1.1, 3.2), (2.5, 3.3))
#let graham_cetroid = graham_dots.at(0)

#let graham_dots_order = (
    range(0, graham_dots.len())
        .map(
            i => vec_angle(
                cetz.vector.add(graham_dots.at(0), (1, 0)), 
                graham_cetroid, 
                graham_dots.at(i)
            )
        )
        .map(i => if i < 0deg { 360deg + i } else { i })
        .enumerate()
        .sorted(key: it => it.at(1))
        .map(it => it.at(0))
)

#proof[
    Дано $M = {M_i}_(i = 1)^n$ в экранной системе координат

    #grid(columns: (1fr, auto), 
        [1. Отбираем точки $M_(min y)$ из $M$ так что $y_0 = min_(i = 1..n) y_i$, далее находим точку $M_0$ из $M_(min y)$ такую, что $x_0 = min_(i = 1..n) x_i$ (она будет самой левой из самых нижних и являться крайней)],
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, ), (),
            caption_dots: (0, ), 
            other_render: () => {
                import cetz.draw: *
                on-layer(-1, line(((0, 0), "|-", "M0"), ("M0", "-|", (6, 0)), stroke: (dash: "dashed", paint: luma(60%))))
            }
        )],
        [2. Далее упорядочиваем точки $M_i$ по величине угла в $M_0$ между каждой точкой $M_i$ и осью $O x$],
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, ), (),
            other_render: () => {
                import cetz.draw: *

                point(graham_cetroid, name: "T", fill: red)

                for i in range(graham_dots.len()) {
                    on-layer(-1, {line("T", ("T", 130%, "M" + str(i)), stroke: (dash: "solid", paint: luma(60%)))})
                }

                for (i, p) in graham_dots.enumerate() {
                    if i != 0 {
                        on-layer(-1, {cetz.angle.angle(
                            "T", ("M0", "-|", (rel: (3, 0))), "M" + str(i), 
                            radius: (graham_dots.len() - i) * 0.17 + 1,
                            stroke: (paint: luma(60%), dash: "dotted")
                        )})
                    }
                }
            }
        )],
        
    )
    
    3. Определяем ориентацию троек $M_i M_(i + 1) M_(i + 2)$. Если точки идут по часовой стрелке, то исключаем $M_(i + 1)$, повторяем с $M_(i - 1) M_i M_(i + 2)$ до тех пор, пока точки будут идти против часовой стрелки

    #grid(columns: (1fr, 1fr, 1fr), align: horizon,
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, 1, 2), (),
            other_render: () => {
                import cetz.draw: *

                let dots = range(0, 3)
                make_triangle(dots, rgb("#ff000088"))
                
            }
        )],
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, 1, 2, 3, 4), (),
            other_render: () => {
                import cetz.draw: *

                let dots = range(0, 3)
                make_triangle(dots, rgb("#ff000088"))

                let dots = range(1, 4)
                make_triangle(dots, rgb("#ff000088"))

                let dots = range(2, 5)
                make_triangle(dots, rgb("#ff000088"))
            }
        )],
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, 1, 2, 5, 3), (4, ),
            other_render: () => {
                import cetz.draw: *

                let dots = range(0, 3)
                make_triangle(dots, rgb("#ff000088"))

                let dots = range(1, 4)
                make_triangle(dots, rgb("#ff000088"))

                let dots = range(2, 5)
                make_triangle(dots, rgb("#ff000088"))

                let dots = range(3, 6)
                make_triangle(dots, rgb("#0000ff88"))
            }
        )],
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, 1, 2, 5), (3, 4),
            other_render: () => {
                import cetz.draw: *

                let dots = range(0, 3)
                make_triangle(dots, rgb("#ff000088"))

                let dots = range(1, 4)
                make_triangle(dots, rgb("#ff000088"))

                let dots = (2, 3, 5)
                make_triangle(dots, rgb("#0000ff88"))
            }
        )],
        align(center)[#text(4em)[...]],
        [#graham_method_pic(
            graham_dots, graham_dots_order,
            (0, 1, 2, 5, 7, 9), (3, 4, 6, 8),
            other_render: () => {
                import cetz.draw: *

                let dots = range(0, 3)
                make_triangle(dots, rgb("#ff000088"))

                let dots = (1, 2, 5)
                make_triangle(dots, rgb("#ff000088"))

                let dots = (2, 5, 7)
                make_triangle(dots, rgb("#ff000088"))

                let dots = (5, 7, 9)
                make_triangle(dots, rgb("#ff000088"))
            }
        )]
    )
]

Такой алгоритм из-за сортировки углов работает за $O(n log n)$, где $n = |M|$ -- число точек во множестве

#v(5mm)

Другой метод, алгоритм Джарвиса (или алгоритм заворачивания подарка), работает так:

#let jarvis_dots = ((1.3, 1), (3.3, 1), (4.9, 1.8), (5.4, 3.6), (3.2, 2.7), (2.1, 1.5), (3.7, 1.8), (3.7, 3.8), (1.1, 3.2), (2.5, 3.3))

#let jarvis_method_pic(
    edge_point, neighbors, k1, k2, green_points, blue_points, region_lines, other_render: () => {}
) = {
    cetz.canvas(length: 0.65cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 1),
            stroke: (thickness: 1pt, cap: "round")
        )

        line((0, -0.3), (0, 5), mark: (end: ">"))
        content((), [$y$], padding: 0.15, anchor: "east")
        line((-0.3, 0), (7, 0), mark: (end: ">"))
        content((), [$x$], padding: 0.15, anchor: "north")
        point((0, 0), name: "O")
        content((), [$O$], padding: 0.15, anchor: "north-east")

        for (i, p) in jarvis_dots.enumerate() {
            circle(p, name: "M" + str(i), fill: none, stroke: none, radius: 0.1)
        }

        let ep = str(if edge_point != none { edge_point } else { 0 })
        let (n1, n2) = neighbors.map(str)
        if edge_point != none {
            merge-path(
                fill: rgb("#dd999955"), 
                stroke: none,
                {
                    line(("M" + ep, k1, "M" + n1), "M" + ep, name: "line1")
                    line((), ("M" + ep, k2, "M" + n2), name: "line2")
                    region_lines()
                }
            )
            on-layer(-1, {
                line("M" + ep, ("M" + ep, k2, "M" + n2), stroke: (dash: "dashed", paint: luma(50%)), name: "M" + ep + "M" + n2)
                line("M" + ep, ("M" + ep, k1, "M" + n1), stroke: (dash: "dashed", paint: luma(50%)), name: "M" + ep + "M" + n1)
            })
        }

        for (i, p) in jarvis_dots.enumerate() {
            point(p, name: "M" + str(i), fill: if i in green_points { green } else if i in blue_points { blue } else { gray }, radius: 2.5pt)

            if edge_point != none {
                if i not in (edge_point, ..neighbors) {
                    line("M" + ep, "M" + str(i), stroke: (thickness: 0.7pt, dash: "dashed", paint: luma(50%)))
                }
            }
        }
        for (i, p) in jarvis_dots.enumerate() {
            content("M" + str(i), box(fill: rgb("#ffffffbb"), inset: (y: 2pt))[#text(0.7em)[$M_(#i)$]], anchor: "south", padding: 0.18)
        }

        other_render()
    })
}


#proof[
    Дано $M = {M_i}_(i = 1)^n$ в экранной системе координат

    #grid(columns: (1fr, auto),
    [1. Находим самую левую точку $M_0$ из самых нижних (или другую такую, чтобы она была крайней)],
    [#jarvis_method_pic(none, (0, 0), 180%, 270%, (0, ), (), () => {})],

    [2. Относительно нее находим ту точку $M_1$, которая будет составлять минимальный угол между лучами $M_0 M_1$ и осью $O x$. Такая точка $M_1$ будет являться крайней],
    [#jarvis_method_pic(0, (8, 1), 180%, 270%, (0, ), (1, ), 
        () => {                 
            cetz.draw.line("line2.end", ((), "|-", "line1.start"))
            cetz.draw.line((), "line1.start")
        }
    )],
    [3. Повторяем до тех пор, пока не придем к $M_0$],
    [#jarvis_method_pic(1, (0, 2), 150%, 230%, (0, 1), (2, ), 
        () => { 
            cetz.draw.line((), ((), "|-", (0, 5)))
            cetz.draw.line((), ((), "-|", "line1.start"))
        },
        other_render: () => {
            cetz.draw.on-layer(-1, {cetz.draw.line("M0", "M1")})
        }
    )]
    )

    #grid(columns: (1fr, 1fr, 1fr), align: center, 
        [#jarvis_method_pic(2, (1, 3), 100%, 180%, (0, 1, 2), (3, ), 
            () => { 
                cetz.draw.line((), ((), "-|", (0.5, 0)))
                cetz.draw.line((), ((), "|-", "line1.start"))
            },
            other_render: () => {
                cetz.draw.on-layer(-1, {cetz.draw.line("M0", "M1", "M2")})
            }
        )],
        [#jarvis_method_pic(7, (3, 8), 100%, 124%, (0, 1, 2, 3, 7), (8, ), 
            () => { 
                cetz.draw.line((), ((), "|-", "M0"))
                cetz.draw.line((), "M1")
                cetz.draw.line((), "M2")
                cetz.draw.line((), "M3")
            },
            other_render: () => {
                cetz.draw.on-layer(-1, {cetz.draw.line("M0", "M1", "M2", "M3", "M7")})
            }
        )],
        [#jarvis_method_pic(8, (7, 0), 100%, 100%, (0, 1, 2, 3, 7, 8), (), 
            () => { 
                cetz.draw.line((), ((), "|-", "M0"))
                cetz.draw.line((), "M1")
                cetz.draw.line((), "M2")
                cetz.draw.line((), "M3")
                cetz.draw.line((), "M7")
            },
            other_render: () => {
                cetz.draw.on-layer(-1, {cetz.draw.line("M0", "M1", "M2", "M3", "M7", "M8", "M0")})
            }
        )],
    
    )
]

Алгоритм Джарвиса имеет сложность $O (h n)$, где $h$ -- число вершин выпуклой оболочки (в данном примере -- 6), а $n = |M|$ -- число точек во множестве, поэтому он быстрее алгоритма Грэхема в тех случаях, когда $h < log n$
