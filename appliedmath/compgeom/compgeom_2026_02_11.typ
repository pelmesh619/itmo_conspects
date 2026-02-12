#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [11.02.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

Также нам понадобятся:

- Уравнения плоскостей в пространстве

- Уравнения кривых второго порядка, специальных кривых (спирали, гипоциклоиды)

- Индикатор ориентации

    #Mem $arrow(a) dot arrow(b) = a_1 b_1 + a_2 b_2 + dots + a_n b_n = |arrow(a)| |arrow(b)| cos (arrow(a), arrow(b))$

    #set par(justify: true)
    #grid(columns: 2, column-gutter: 1em,
        [$arrow(a) times arrow(b) = mat(arrow(i), arrow(j), arrow(k); a_1, a_2, a_3; b_1, b_2, b_3) = arrow(c) : cases(|arrow(c)| = |arrow(a)| |arrow(b)| sin(hat(upright(arrow(a)\, arrow(b)))), arrow(c) perp arrow(a), arrow(c) perp arrow(b), (arrow(a), arrow(b), arrow(c)) " - правая тройка векторов")$],
        [
        #cetz.canvas(length: 1.5cm, {
            import cetz.draw: *

            set-style(
                mark: (fill: black, scale: 2),
                stroke: (thickness: 0.4pt, cap: "round"),
                content: (padding: 1pt, font: 17pt)
            )
            
            ortho({
                line((0, 0, 0), (1, 0, 0), mark: (end: "stealth"), name: "A")
                content((rel: (0.1, 0)), [$arrow(a)$], anchor: "west")
                line((0, 0, 0), (0, 1, 0), mark: (end: "stealth"), name: "B")
                content((rel: (0.1, 0)), [$arrow(c)$], anchor: "west")
                line((0, 0, 0), (0, 0, 1), mark: (end: "stealth"), name: "C")
                content((rel: (-0.1, 0)), [$arrow(b)$], anchor: "east")
            })

            circle((0, 0), radius: 3pt, fill: gray, name: "O")
            content((rel: (0, -0.1)), [$O$], anchor: "north")
        })

        ]
    )
    #set par(justify: false)

    #Def Псевдоскалярное (или косое) произведение $arrow(a) or arrow(b) #equaldef plus.minus |arrow(a)| |arrow(b)| sin(arrow(a), arrow(b))$, причем со знаком плюс, если угол между $arrow(a)$ и $arrow(b)$ положителен (то есть против часовой), и со знаком минус, если угол отрицателен (то есть по часовой)

=== 1.5 Однородные координаты

#set par(justify: true)
#grid(columns: 2, column-gutter: 1em,
    [
    #Mem В плоскости $RR^2$ существует линейное пространство направленных отрезков. Проблема состоит в том, что нам нужно представить вектор с другим началом

    Тогда такие вектора можно представить двумя точками
    ],
    [
    #cetz.canvas(length: 2.5cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )


        let a = ((1, 1), (1.8, 0.5))

        line(a.at(0), a.at(1), mark: (end: "stealth"))
        content((rel: (0.1, 0)), [$arrow(a)$], anchor: "south")

        line((-0.2, 0), (2.5, 0), mark: (end: "stealth"))
        content((rel: (0, -0.1)), [$x$], anchor: "north")
        line((0, -0.2), (0, 1.3), mark: (end: "stealth"))
        content((rel: (-0.1, 0)), [$y$], anchor: "east")

        circle((0, 0), radius: 3pt, fill: gray, name: "O")
        content((rel: (-0.15, -0.1)), [$O$], anchor: "north")

        line(a.at(0), (0, a.at(0).at(1)), stroke: (dash: "dashed", paint: gray))
        content((), [$y_1$], anchor: "east")
        line(a.at(1), (0, a.at(1).at(1)), stroke: (dash: "dashed", paint: gray))
        content((), [$y_2$], anchor: "east")

        line(a.at(0), (a.at(0).at(0), 0), stroke: (dash: "dashed", paint: gray))
        content((), [$x_1$], anchor: "north")
        line(a.at(1), (a.at(1).at(0), 0), stroke: (dash: "dashed", paint: gray))
        content((), [$x_2$], anchor: "north")
    })
    ]
)
#set par(justify: false)

Чтобы работать с точками, а не векторами с общим началом $O$, обобщим понятие линейного пространства. Тогда понятие линейного пространства обобщается до аффинного, где элементы -- это точки, а не векторы

#Def Пространство $cal(A)$ -- аффинное пространство, ассоциированное с линейным пространством $V$, если:

+ Заданы аксиомы для $V$
+ Существует $f : cal(A) arrow V$ такое, что для всякой пары сопоставляется вектор из линейного: $forall A, B in cal(A) quad f(A, B) = arrow(A B) in V$
+ Для всяких $A in cal(A)$ и $arrow(a) in V$ существует единственная $B in A | arrow(A B) = arrow(a)$
+ Для всяких точек $A, B, C in cal(A)$ справедливо, что $arrow(A B) + arrow(B C) = arrow(A C)$

#v(8mm)

В аффинном пространстве $cal(A)$ можно ввести аффинные преобразования. Те, что не связаны с переносом, можно считать линейными в пространстве $V$:

+ Осевая симметрия $S_l$, если $O in l$
+ Поворот $R_O^phi$
+ Гомотетия $H_O^k$

Их можно представить в виде матрицы. Но перенос выводит из линейного пространства. Нам нужно все преобразования свести к алгебраическому действию $x^prime = cal(F) x$, где $cal(F)$ -- преобразование с матрицей $F$

#v(5mm)

Движение плоскости и гомотетия дают формулу:

$ X^prime = F X + T_(arrow(a)) $

Вместо 

$ vec(x^prime, y^prime) = mat(f_(1 1), f_(1 2); f_(2 1), f_(2 2)) vec(x, y) + vec(x_0, y_0), $

рассмотрим векторы с добавленной координатой $z = 1$: 

$ vec(x^prime, y^prime, 1) = mat(f_(1 1), f_(1 2), x_0; f_(2 1), f_(2 2), y_0; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed"))) vec(x, y, 1) $

Тогда $vec(x', y', 1) = vec(f_(1 1) x + f_(1 2) y + x_0, f_(2 1) x + f_(2 2) y + y_0, 1)$. Координаты $vec(x', y', 1)$ и $vec(x, y, 1)$ называют однородными

Геометрическая интерпретация -- стереографическая проекция Римана

#cetz.canvas(length: 2.5cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
    )

    let h = 1.5
    let plane_size = 0.9
    let x_incline = 18deg

    ortho(x: x_incline, {
        on-xz(y: 1 / calc.cos(x_incline), {
            rect((-plane_size, -plane_size), (plane_size, plane_size), stroke: (dash: "dashed"))
        })

        on-xz(y: h / calc.cos(x_incline), {
            rect((-plane_size * h, -plane_size * h), (plane_size * h, plane_size * h), stroke: (dash: "dashed"))
        })
    })

    ortho(y: 180deg, x: 0deg, {
        on-xy({
            circle((0, 0), radius: 1)
        })

        line((0, -1.2, 0), (0, 2, 0), mark: (end: "stealth"))
        content((rel: (-0.1, 0.0)), [$z$], anchor: "west")
        
        circle((0, 1, 0), radius: 3pt, fill: gray, name: "1")
        content((rel: (0.05, 0.05)), [$1$], anchor: "north-east")
        circle((0, 0, 0), radius: 3pt, fill: gray, name: "O")
        content((rel: (0.05, -0.05)), [$O$], anchor: "south-east")
        circle((0, h, 0), radius: 3pt, fill: gray, name: "h")
        content((rel: (0.05, 0.05)), [$h$], anchor: "north-east")

        circle((0.7 * h, h, 0), radius: 3pt, fill: gray, name: "N")
        content((rel: (0.1, 0.05)), [$N(h x, h y, h)$], anchor: "north-east")

        line("O", "N")

        circle((0.7, 1, 0), radius: 3pt, fill: gray, name: "M")
        content((rel: (0.1, 0.0)), [$M(x, y, 1)$], anchor: "east")

        circle((0.7 / calc.sqrt(0.7*0.7 + 1), 1 / calc.sqrt(0.7*0.7 + 1), 0), radius: 3pt, fill: gray, name: "C")

        line("1", "M", stroke: (dash: "dashed", paint: luma(40%)))
        line("N", "h", stroke: (dash: "dashed", paint: luma(40%)))

        content((-1.2, 0.9), [$arrow.l$ декартова плоскость], anchor: "west")
        
    })
})

Далее происходит центральное проектирование на плоскость $z = h, p(x, y) arrow N(h x, h y, h)$

Таким образом, каждой точке декартовой плоскости ставится в соответствии точка сферы, а она центрально проектируется на плоскость $z = h$, где $h$ отвечает за масштаб. В результате точкам декартовой плоскости $(x, y)$ соответствуют точки $(x, y, 1)= (h x, h y, h)$, а однородные координаты $(x, y, 0)$ представляют бесконечно удаленную точку декартовой плоскости в направлении вектора $arrow(a) = (x, y)$

#v(8mm)

Рассмотрим матрицы преобразований в однородных координатах:

$ F = mat(a, b, m; b, d, h; p, q, s; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed"))) $

$mat(a, c; b, d)$ представляет композицию из симметрии, поворота, гомотетии и сдвига

#Def Сдвиг (shear) $op("Sh")_x$ -- наклонной перекос такой, что $cases(x' = x + k y, y' = y)$, а $k = op("sh")_x$

Аналогично по оси $O y$ сдвиг $cases(x' = x, y' = y + op("sh")_y x)$

#cetz.canvas(length: 2cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
    )

    line((-0.2, 0), (2.5, 0), mark: (end: "stealth"))
    content((rel: (0, -0.1)), [$x$], anchor: "north")
    line((0, -0.2), (0, 2.5), mark: (end: "stealth"))
    content((rel: (-0.1, 0)), [$y$], anchor: "east")

    circle((0, 0), radius: 3pt, fill: gray, name: "O")
    content((rel: (-0.15, -0.1)), [$O$], anchor: "north")

    content((1, 0.25), [$A B C D$])

    line((0.5, 0), (1.5, 0), stroke: (paint: luma(60%), thickness: 1.5pt))
    line((0.5, 0), (0.5, 0.5), stroke: (paint: luma(60%), thickness: 1.5pt))
    line((1.5, 0), (1.5, 0.5), stroke: (paint: luma(60%), thickness: 1.5pt))
    line((1.5, 0.5), (0.5, 0.5), stroke: (paint: luma(60%), thickness: 1.5pt))

    line((0.5, 0), (1.5, 0), stroke: (dash: "dashed"))
    line((0.5, 0), (0.85, 0.5), stroke: (dash: "dashed"))
    line((1.5, 0), (1.85, 0.5), stroke: (dash: "dashed"))
    content((rel: (0.1, 0)), [$op("Sh")_x (A B C D)$], anchor: "west")
    line((1.85, 0.5), (0.85, 0.5), stroke: (dash: "dashed"))

    line((0.5, 0.6), (1.5, 1.8), stroke: (dash: "dashed"))
    content((rel: (0.1, 0)), [$op("Sh")_y (A B C D)$], anchor: "west")
    line((0.5, 0.6), (0.5, 1.1), stroke: (dash: "dashed"))
    line((1.5, 1.8), (1.5, 2.3), stroke: (dash: "dashed"))
    line((1.5, 2.3), (0.5, 1.1), stroke: (dash: "dashed"))
})

Вектор $vec(m, n)$ -- вектор переноса $T_((m, n))$, число $s$ -- масштаб 

Рассмотрим смысл $(p, q)$:

$ mat(1, 0, 0; 0, 1, 0; p, q, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed"))) vec(x, y, 1) = vec(x', y', p x + q y + 1) = vec(x', y', h) $

При фиксированных $p$ и $q$ выражение $h = p x + q y + 1$ задает наклонную плоскость в трехмерном пространстве, что позволяет изменять перспективу. На этом курсе операции, использующие $p$ и $q$, рассматриваться не будут

#v(8mm)

Рассмотрим частные виды преобразований:

- Перенос $T_(m,n) = mat(1, 0, m; 0, 1, n; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed")))$

- Поворот $R_O^phi = mat(cos phi, sin phi, 0; -sin phi, cos phi, 0; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed")))$

- Симметрия по оси $S_(O x) = mat(1, 0, 0; 0, -1, 0; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed")))$

- Симметрия по биссектрисе $S_(x = y) = mat(0, 1, 0; 1, 0, 0; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed")))$

- Сдвиг $op("Sh")_(x) = mat(1, op("sh")_x, 0; 0, 1, 0; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed")))$

#Ex Дан $triangle A B C$ с вершинами в координатах $A(x_1, y_1)$, $B(x_2, y_2)$, $C(x_3, y_3)$. Найти $triangle A' B' C' = cal(F)(triangle A B C)$

Найдем матрицу координат вершин $triangle A B C$: $mat(x_1, x_2, x_3; y_1, y_2, y_3; 1, 1, 1)$

Преобразование осуществляется так:

$ mat(a, b, m; b, d, h; 0, 0, 1; augment: #(vline: 2, hline: 2, stroke: (dash: "dashed"))) mat(x_1, x_2, x_3; y_1, y_2, y_3; 1, 1, 1) = mat(x'_1, x'_2, x'_3; y'_1, y'_2, y'_3; 1, 1, 1) $
