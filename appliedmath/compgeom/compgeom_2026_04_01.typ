#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [01.04.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

=== 2.4 Близость

#import "./__algorithms.typ": *

Пусть есть задача найти в множестве $M = {M_1, M_2, ..., M_n}$ к данной точке $M_k$ ближайшей точки, ближайшей пары или ближайших соседей

#let dist(x, y) = $op("dist")(#x, #y)$

#Def Точка $M^*$ -- ближайшая к $M_k$, если $dist(M^*, M_k) = min_j dist(M_j, M_k)$

#Nota Отношение близости к $M_k$ несимметрично, то есть $M^*$ -- ближайшая к $M_k$ $cancel(arrow.r.long.double)$ $M_k$ -- ближайшая к $M^*$

#Ex $M_2$ -- ближайшая к $M_3$, но ближайшая к $M_2$ не $M_3$, а $M_1$

#align(center)[
#cetz.canvas(length: 1.6cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 1),
        stroke: (thickness: 1pt, cap: "round")
    )

    let dots = ((0, 0), (-0.6, 0.2), (-1.7, -0.2), (1, -0.3))

    for (i, p) in dots.enumerate() {
        point(p, name: "M" + str(i + 1))
        on-layer(1, {content((), [$M_(#(i + 1))$], anchor: "south", padding: 0.15)})
    }

    line("M3", "M2", mark: (end: ">"))
    line("M1", "M2", mark: (end: ">"))
    line("M2", "M1", mark: (end: ">"))
    line("M4", "M1", mark: (end: ">"))
})
]

#Def Если отношение близости для пары $M_i$ и $M_j$ симметрично, то $(M_i, M_j)$ -- ближайшая пара

==== 2.4.1 Ближайшая пара

#Nota Наивным алгоритмом будет являться поиск всех расстояний $dist(M_i, M_j)$ для $i != j$ и поиск $min_(i, j) dist(M_i, M_j)$. Такой алгоритм обладает сложностью $O(n^2)$

Рассмотрим алгоритм "разделяй и властвуй"

#let distv(p1, p2) = {
  let (x1, y1) = p1
  let (x2, y2) = p2
  return calc.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
}

#let brute_force(points, draw_func, depth) = {
  if points.len() < 2 { return calc.inf }
  let min_pair = (points.at(0), points.at(1))
  for i in range(0, points.len() - 1) {
    for j in range(i + 1, points.len()) {
      let d = distv(points.at(i), points.at(j))
      if d < distv(..min_pair) { min_pair = (points.at(i), points.at(j)) }
    }
  }
  return (min_pair, draw_func)
}

#let closest_pair_rec(points_sorted_by_x, draw_func, depth, on-left, flags) = {
    let n = points_sorted_by_x.len()
    if n <= 3 {
        let (min_pair, draw_func) = brute_force(points_sorted_by_x, draw_func, depth)
        if depth == 1 {
            draw_func.push(cetz.draw.line(..min_pair, stroke: red + 1.5pt, name: "min-pair-tmp"))
            if not flags.delta {
                draw_func.push(cetz.draw.content(("min-pair-tmp.start", 50%, "min-pair-tmp.end"), [$delta_(#(if on-left { 1 } else { 2 }))$], anchor: "south", padding: 0.15, angle: "min-pair-tmp.end"))
            } else if not on-left {
                draw_func.push(cetz.draw.content(("min-pair-tmp.start", 50%, "min-pair-tmp.end"), [$delta$], anchor: "south", padding: 0.15, angle: "min-pair-tmp.end"))
            }
        }
        return (min_pair, draw_func)
    }

    let mid = calc.floor(n / 2)
    
    let mid_point = points_sorted_by_x.at(mid)
    let left = points_sorted_by_x.slice(0, mid)
    let right = points_sorted_by_x.slice(mid + 1, n)

    let (lpair, draw_func) = closest_pair_rec(left, draw_func, depth + 1, true, flags)
    let (rpair, draw_func) = closest_pair_rec(right, draw_func, depth + 1, false, flags)
    let d = calc.min(distv(..lpair), distv(..rpair))
    let min_pair = if distv(..lpair) < distv(..rpair) { lpair } else {rpair }

    let strip = points_sorted_by_x.filter(p => calc.abs(p.at(0) - mid_point.at(0)) < d)

    if depth == 0 {
        draw_func.push(cetz.draw.on-layer(-1, {cetz.draw.line((mid_point.at(0), 0), (mid_point.at(0), 5))}))
        if flags.delta {
            draw_func.push(cetz.draw.line((mid_point.at(0) - d, 0), (mid_point.at(0) - d, 5), stroke: (dash: "dashed")))
            draw_func.push(cetz.draw.line((mid_point.at(0) + d, 0), (mid_point.at(0) + d, 5), stroke: (dash: "dashed")))
            draw_func.push(cetz.draw.line((mid_point.at(0) - d, -0.5), (mid_point.at(0) + d, -0.5), stroke: (dash: "dashed"), mark: (end: ">", start: ">", stroke: 0pt), name: "delta-line"))
            draw_func.push(cetz.draw.content(("delta-line.start", 50%, "delta-line.end"), [$2 delta$], anchor: "north", padding: 0.15))

        }
    }

    let strip_sorted = strip.sorted(key: it => it.at(1))

    for i in range(0, strip_sorted.len()) {
        let p1 = strip_sorted.at(i)
        for j in range(i + 1, calc.min(strip_sorted.len(), i + 8)) {
        let p2 = strip_sorted.at(j)
        if p2.at(1) - p1.at(1) >= d { break }
        let d_new = distv(p1, p2)
        if d_new < d {
            d = d_new
            min_pair = (p1, p2)
        }
        }
    }
    if depth == 1 {
        draw_func.push(cetz.draw.line(..min_pair, stroke: red + 1.5pt))
    }
    if depth == 0 and flags.merge-pair {
        draw_func.push(cetz.draw.line(..min_pair, stroke: purple + 1.5pt))
    }
    return (min_pair, draw_func)
}

#let closest_pair(points, draw_func, flags) = {
    if points.len() < 2 { return 0.0 }
    let points_sorted = points.sorted(key: it => it.at(0))
    return closest_pair_rec(points_sorted, draw_func, 0, false, flags)
}



#proof[
    1. Разделяем $M$ на левое подмножество $M_1$ и правое $M_2$

    2. Пусть нашлись ближайшие пары $(L_1, L_2) in M_1$ и $(P_1, P_2) in M_2$

        Для них $delta_1 = dist(L_1, L_2)$ и $delta_2 = dist(P_1, P_2)$. Обозначим $delta = min (delta_1, delta_2)$

    3. В $delta$-полосе (полосе шириной $2 delta$) разделителя находим ближайшую пару, если она там есть, и проверяем, что расстояние для пары меньше, чем $delta$

    4. Повторяем алгоритм рекурсивно. Концом разделения можно считать тот момент, когда в подмножестве остается 2 или 3 точки

    #let caesar-img(flags) = {
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

            let rng1 = suiji.gen-rng-f(30)
            let rng2 = suiji.gen-rng-f(23)
            let rng3 = suiji.gen-rng-f(2397)

            let n = 7
            let dots = (
                suiji.uniform-f(rng1, low: 0, high: 3.5, size: calc.floor(n / 2)).at(1),
                suiji.uniform-f(rng2, low: 3.5, high: 7, size: calc.ceil(n / 2)).at(1),
            ).flatten()
                .zip(suiji.uniform-f(rng3, low: 0, high: 5, size: n).at(1))

            for (i, p) in dots.enumerate() {
                point(p, name: "M" + str(i))
            }

            let (r, d) = closest_pair(dots, (), flags)

            for i in d {
                i
            }
        })
    }

    #grid(columns: (1fr, 1fr, 1fr),
        [#caesar-img((delta: false, merge-pair: false))],
        [#caesar-img((delta: true, merge-pair: false))],
        [#caesar-img((delta: true, merge-pair: true))]
    )
]

==== 2.4.2 Построение локус-сети (диаграммы Вороного) множества

#Def Локус точки $M_0$ -- множество точек $N(x, y)$ такие, что $dist(M_0, N) < dist(M_i, N)$ для $i = 1, 2, ...$ (то есть множество точек, которые к $M_0$ ближе, чем к остальным)

#Nota Форма локуса -- это пересечение полуплоскостей, каждая из которых задается неравенством $dist(M_0, N) < dist(M_i, N)$ и ограничена серединным перпендикуляром к отрезку $M_0 M_i$

#let locus-image-setup(dots) = {
    import cetz.draw: *

    default-style

    for (i, p) in dots.enumerate() {
        point(p, name: "M" + str(i))
        on-layer(1, {content((), [$M_(#(i))$], anchor: "south", padding: 0.15)})
    }

    line("M0", "M1", name: "M01", stroke: dashed_gray)
    line(("M0", 25%, "M1"), ("M0", 75%, "M1"), name: "M01", mark: (symbol: "|", stroke: luma(50%) + 1pt, scale: 2), stroke: (thickness: 0pt))
    line("M0", "M2", name: "M02", stroke: dashed_gray)
    line(("M0", 25%, "M2"), ("M0", 75%, "M2"), name: "M01", mark: (symbol: "||", stroke: luma(50%) + 1pt, scale: 2, length: 1pt), stroke: (thickness: 0pt))

    let m0m1 = (cetz.vector.sub(dots.at(1), dots.at(0)))
    let m0m1p = cetz.vector.norm((m0m1.at(1), -m0m1.at(0)))

    point(cetz.vector.add(dots.at(0), cetz.vector.add(m0m1p, cetz.vector.scale(m0m1, 0.5))), name: "m0m1p", radius: 0pt)

    line((("M0", 50%, "M1"), -100%, "m0m1p"), "m0m1p", name: "m0m1l", stroke: orange + 2pt)

    let m0m2 = (cetz.vector.sub(dots.at(2), dots.at(0)))
    let m0m2p = cetz.vector.norm((m0m2.at(1), -m0m2.at(0)))

    point(cetz.vector.add(dots.at(0), cetz.vector.add(m0m2p, cetz.vector.scale(m0m2, 0.5))), name: "m0m2p", radius: 0pt)

    line((("M0", 50%, "M2"), -100%, "m0m2p"), "m0m2p", name: "m0m2l", stroke: green + 2pt)
}

#align(center)[
#grid(columns: (auto, auto), column-gutter: 5em, align: center,
    [#cetz.canvas(length: 1.6cm, {
        import cetz.draw: *

        let dots = ((-1.2, -0.2), (-0.1, 0.6), (0.1, -0.9), )

        locus-image-setup(dots)

        let m0m1 = (cetz.vector.sub(dots.at(1), dots.at(0)))
        let m0m1p = cetz.vector.norm((m0m1.at(1), -m0m1.at(0)))

        let m0m2 = (cetz.vector.sub(dots.at(2), dots.at(0)))
        let m0m2p = cetz.vector.norm((m0m2.at(1), -m0m2.at(0)))

        cetz.angle.right-angle(
            ("M0", 50%, "M1"),
            "M0", "m0m1l.start",
            label: none,
            radius: 0.15,
            stroke: luma(50%)
        )

        cetz.angle.right-angle(
            ("M0", 50%, "M2"),
            "M0", "m0m2l.start",
            label: none,
            radius: 0.15,
            stroke: luma(50%)
        )
    })
    ],
    [#cetz.canvas(length: 1.6cm, {
        import cetz.draw: *

        let dots = ((-1.2, -0.2), (-0.1, 0.6), (0.1, -0.9), )

        locus-image-setup(dots)

        let m0m1 = (cetz.vector.sub(dots.at(1), dots.at(0)))
        let m0m1p = cetz.vector.norm((m0m1.at(1), -m0m1.at(0)))

        let m0m2 = (cetz.vector.sub(dots.at(2), dots.at(0)))
        let m0m2p = cetz.vector.norm((m0m2.at(1), -m0m2.at(0)))

        merge-path(stroke: 0pt, {
            line("m0m2l.start", "m0m2l.end")
            line("m0m2l.end", cetz.vector.add(dots.at(0), cetz.vector.add(m0m2p, cetz.vector.scale(m0m2, 0.4))))
            line((), cetz.vector.add(dots.at(0), cetz.vector.sub(cetz.vector.scale(m0m2, 0.4), m0m2p)))
            line((), "m0m2l.start")
        }, fill: hatching-fill(stroke-style: (paint: green), angle: 135deg))

        on-layer(-1, merge-path(stroke: 0pt, {
            line("m0m1l.start", "m0m1l.end")
            line("m0m1l.end", cetz.vector.add(dots.at(0), cetz.vector.add(m0m1p, cetz.vector.scale(m0m1, 0.4))))
            line((), cetz.vector.add(dots.at(0), cetz.vector.sub(cetz.vector.scale(m0m1, 0.4), m0m1p)))
            line((), "m0m1l.start")
        }, fill: hatching-fill(stroke-style: (paint: orange), angle: 45deg)))
        
        intersections("i1", {
            line((("M0", 50%, "M1"), -100%, "m0m1p"), "m0m1p", name: "m0m1l", stroke: 0pt)
            line((("M0", 50%, "M2"), -100%, "m0m2p"), "m0m2p", name: "m0m2l", stroke: 0pt)
        })

        on-layer(-1, merge-path(stroke: 0pt, {
            line("m0m1l.start", "i1.0")
            line((), "m0m2l.end")
            line((), ((), "-|", (-2, 0)))
            line((), ((), "|-", "m0m1l.start"))
        }, fill: blue.transparentize(90%)))
    })
    ],
)
]

// картинка перпендикуляр


#Nota Точки локуса для $M_0$ лежат в той же полуплоскости, что и $M_0$ по отношению к серединному перпендикуляру отрезка $M_0 M_1$

Если $M_0$ -- внутренняя точка множества $M$, то ее локус -- это замкнутый многоугольник. Если $M_0$ принадлежит выпуклой оболочке, то локус -- это неограниченный полигон

#Nota Наложим требование на $M$: никакие 4 точки не лежат на одной окружности

Тогда у локус-сети есть свойства:

1. Любая вершина -- пересечение двух ребер
2. Любое ребро связывает 2 вершины
3. Любая вершина -- центр окружности, описанной около трех точек $M$
4. Любое ребро определяет ближайшего соседа

Итак, диаграмма Вороного выглядит так:

// картинка, 6 точек

#align(center)[
#cetz.canvas(length: 1cm, {
    import cetz.draw: *

    default-style

    let rng1 = suiji.gen-rng-f(30)
    let rng2 = suiji.gen-rng-f(25)

    let n = 8
    let points = suiji.uniform-f(rng1, low: 0, high: 6, size: n).at(1)
        .zip(suiji.uniform-f(rng2, low: 0, high: 4, size: n).at(1))

    let bounds = bounds(points, margin: 1.5)
    let (minx, miny) = bounds.at(0)
    let (maxx, maxy) = bounds.at(2)

    let cells = ()

    for i in points {
        point(i)
    }
        
    for i in range(points.len()) {
        default-style
        let cell = voronoi_cell(points, i, bounds)

        for (j, k) in cell.windows(2) {
            if j.at(1) == k.at(1) and j.at(1) in (miny, maxy) or j.at(0) == k.at(0) and j.at(0) in (minx, maxx) {
                continue
            }
            line(j, k)
        }
        let (j, k) = (cell.at(0), cell.at(-1))
        if not (j.at(1) == k.at(1) and j.at(1) in (miny, maxy) or  j.at(0) == k.at(0) and j.at(0) in (minx, maxx)) {
            line(j, k)
        }

        let p = cetz.palette.new(colors: cetz.palette.tango-light-colors.map(it => it.transparentize(30%)), base: (stroke: 0pt))
        set-style(..p(i))
        on-layer(-1, merge-path({
            for (j, k) in cell.windows(2) {
                line(j, k, stroke: 0pt)
            }
            let (j, k) = (cell.at(0), cell.at(-1))
            line(j, k, stroke: 0pt)
        }))
    }
})]

#Def Граф, двойственный диаграмме Вороного, задает триангуляцию $M$ (в частности триангуляцию Делоне):

// картинка

#align(center)[
#cetz.canvas(length: 1cm, {
    import cetz.draw: *

    default-style

    let rng1 = suiji.gen-rng-f(30)
    let rng2 = suiji.gen-rng-f(25)

    let n = 8
    let points = suiji.uniform-f(rng1, low: 0, high: 6, size: n).at(1)
        .zip(suiji.uniform-f(rng2, low: 0, high: 4, size: n).at(1))

    let bounds = bounds(points, margin: 1.5)
    let (minx, miny) = bounds.at(0)
    let (maxx, maxy) = bounds.at(2)

    let cells = ()

    for (i, p) in points.enumerate() {
        point(p, name: "M" + str(i))
    }

    let (triangles, _) = delaunay_triangulation(points)

    for i in range(points.len()) {
        default-style
        let cell = voronoi_cell(points, i, bounds)

        for (j, k) in cell.windows(2) {
            if j.at(1) == k.at(1) and j.at(1) in (miny, maxy) or j.at(0) == k.at(0) and j.at(0) in (minx, maxx) {
                continue
            }
            line(j, k, stroke: luma(50%))
        }
        let (j, k) = (cell.at(0), cell.at(-1))
        if not (j.at(1) == k.at(1) and j.at(1) in (miny, maxy) or  j.at(0) == k.at(0) and j.at(0) in (minx, maxx)) {
            line(j, k, stroke: luma(50%))
        }

        let p = cetz.palette.new(colors: cetz.palette.tango-light-colors.map(it => it.transparentize(70%)), base: (stroke: 0pt))
        set-style(..p(i))
        on-layer(-1, merge-path({
            for (j, k) in cell.windows(2) {
                line(j, k, stroke: 0pt)
            }
            let (j, k) = (cell.at(0), cell.at(-1))
            line(j, k, stroke: 0pt)
        }))
    }

    default-style
    for (i1,i2,i3) in triangles {
        line("M" + str(i1), "M" + str(i2), stroke: black, fill: none)
        line("M" + str(i2), "M" + str(i3), stroke: black, fill: none)
        line("M" + str(i3), "M" + str(i1), stroke: black, fill: none)
    }
})]

Диаграмму Вороного можно описать набором вершин, в которых сходятся ребра, и набор ребер для каждой вершины. Триангуляция представляется набором треугольных ячеек

С помощью диаграммы Вороного задача о нахождении ближайшей точки решается легче -- можно рассматривать лишь точки в окружении

#v(10mm)

Диаграмму Вороного можно построить:

- По наивному алгоритму с помощью пересечения полуплоскостей, образованных серединными перпендикулярами
- По алгоритму "разделяй и властвуй"

#let caesar-voronoi-image = caeser-voronoi-image-builder()

#proof[
    #grid(columns: (1fr, auto), column-gutter: 1em,
        [1. Разделяем точки на две половины по $x$, рекурсивно строим диаграммы для левой половины $L$ и правой $R$],
        [#caesar-voronoi-image(length: 0.4cm, flags: (nopolyline: true))],
    )

    2. Строим разделяющую ломаную -- множество точек, равноудалённых от ближайших точек левой и правой диаграммы. Ломаная состоит из отрезков серединных перпендикуляров между парами $(L_i, R_i)$, где $L_i in L$, $R_i in R$

        - Находим верхнюю пару $(L_0, R_0)$ (самый верхний луч)
        - Двигаемся вниз: на каждом шаге текущий перпендикуляр $L_i R_i$ пересекается с ребром левой или правой диаграмм; переходим в соседнюю ячейку
        - Добавляем отрезки до пересечения
        - Заканчиваем у нижней границы

    #align(center)[
    #grid(columns: (auto, auto, auto), column-gutter: 2em,
        [#caesar-voronoi-image(length: 0.4cm, flags: (count: 2, perp: true))],
        [#caesar-voronoi-image(length: 0.4cm, flags: (count: 4, perp: true))],
        [#caesar-voronoi-image(length: 0.4cm, flags: (count: 6, perp: true))]
    )]

    #grid(columns: (1fr, auto), column-gutter: 1em,
        [3. Добавляем новую ломаную как ребра между диаграммами, повторяем рекурсивно],
        [#caesar-voronoi-image(length: 0.4cm, flags: (perp: true, full: true, nopolyline: true))]
    )
    
]

#let fortune_algorithm_image = fortune_algorithm_builder()

- По алгоритму Форчуна (или алгоритм "береговой линий"), где используется заметающая прямая

#proof[
    1. Заметающая прямая (вертикальная или горизонтальная) движется слева направо
    
    2. Когда прямая достигает очередной точки в береговую линию добавляется парабола, образованная заметающей прямой и этой точкой как фокусом

        Точка пересечения двух парабол является равноудаленной от фокусом -- такая точка будет лежать на ребре диаграммы Вороного

    3. Три параболы пересекаются в одной точке, если эта точка равноудаленна от фокусов парабол (то есть фокусы лежат на окружность). Эта точка будет вершиной диаграммы Вороного

    #grid(columns: (1fr, 1fr, 1fr), align: center,
        [#fortune_algorithm_image(length: 0.6cm, 0, )],
        [#fortune_algorithm_image(length: 0.6cm, 1, )],
        [#fortune_algorithm_image(length: 0.6cm, 3, )],
        [#fortune_algorithm_image(length: 0.6cm, 6, )],
        [#fortune_algorithm_image(length: 0.6cm, 7, )],
        [#fortune_algorithm_image(length: 0.6cm, 11, )],
    )

    У вершин диаграммы, имеющих 2 ребра (такие находятся на границе), третье ребро строится как серединный перпендикуляр двух точек
]
