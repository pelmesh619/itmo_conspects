#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [04.02.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
  subject-name: subject-name,
  date-header: date-header,
  lecturer-name: lecturer-name,
  doc
)

= Вычислительная геометрия

== 1. Преобразование изображений. Геометрическое моделирование

// == 2. Теория алгоритмов геометрических задач

=== 1.1 Основные понятия

#Mem Линейное пространство -- это множество векторов $V$ с определенными операциями сложения $+$ и умножения на число $dot lambda$, где $lambda in RR (CC)$, которые удовлетворяют свойствам:

#enum(
  numbering:n => if n == 1 { "1.-4." } else { numbering("1.", n + 3) },
  [свойства абелево-аддитивной группы:

    + $x + y = y + x quad$ для $x, y in V$

    + $x + (y + z) = (x + y) + z$ для $x, y, z in V$

    + Существует такой $0$, что $x + 0 = x$ для $x in V$

    + Для любого $x in V$ существует такой $-x$, что $x + (-x) = 0$
  ],

  [$1 dot x = x dot 1 = x quad$ для $x in V$],

  [$(lambda mu) x = lambda (mu x) quad$ для $x in V$ и $lambda, mu in RR (CC)$],

  [$(lambda + mu) x = lambda x + mu x quad$ для $x in V$ и $lambda, mu in RR (CC)$],

  [$lambda (x + y) = lambda x + lambda y quad$ для $x, y in V$ и $lambda in RR (CC)$]
)

В общем случае умножение определено на комплексное число, но мы будем рассматривать вещественные

#v(5mm)

#Def Линейная комбинация векторов $x, y, z, ...$ называется сумма $lambda_1 x + lambda_2 y + lambda_3 z + dots$, где $lambda_i in RR (CC)$

#v(10mm)

=== 1.2 Модели линейных пространств

#grid(
  columns: (50%, 50%),
  [
    #align(center)[Геометрическое]

    #align(center)[
    #cetz.canvas(length: 2cm, {
      import cetz.draw: *

      set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
      )


      line((0, 0), (0.6, 1.3), mark: (end: "stealth"))
      content((rel: (0.12, 0)), [$arrow(a)$], anchor: "west")
      line((0, 0), (-1.1, 0.2), mark: (end: "stealth"))
      line((0, 0), (1.2, -0.4), mark: (end: "stealth"))
      circle((0, 0), radius: 3pt, fill: gray)
      content((rel: (0, -0.14)), [$O$], anchor: "north")
    })
    ]
  ],
  [
    #align(center)[Арифметическое]

    $x = (x_1, x_2)$ в $RR^2$

    $x = (x_1, x_2, x_3)$ в $RR^3$

    В общем случае $x = (x_1, dots, x_n)$ в $RR^n$
  ],
  [
    #v(5mm)
    Линейное пространство -- направленные отрезки с общим началов
  ],
  [
    #v(5mm)
    Линейное пространство -- множество упорядоченных совокупностей $n$ чисел
  ],
)

#v(5mm)

Между этими моделями вводится изоморфизм с помощью базиса, например, $(arrow(i), arrow(j), arrow(k))$. Тогда всякий геометрический вектор можно преобразовать в арифметический и наоборот: $arrow(x) = x_1 arrow(i) + x_2 arrow(j) = (x_1, x_2)$

=== 1.3 Геометрические преобразования

#Def Геометрическое преобразование -- это биекция, которая переводит пространство $Omega$ в себя

#Def Движение -- геометрическое преобразование, сохраняющее расстояние между двумя любыми точками (изометрия) // TODO

Виды движения на плоскости $RR^2$:

+ Осевая симметрия $S_l$ относительно оси $l$

    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.7pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )

        let line_1 = (-0.25, -0.4)
        let line_2 = (0.8, 1.3)
        let decline = (-line_1.at(0) + line_2.at(0), -line_1.at(1) + line_2.at(1))
        line(line_1, line_2, name: "main-line")

        let m_dot = (-0.4, 0.8)
        circle(m_dot, radius: 3pt, fill: gray, name: "M")
        content((rel: (-0.14, 0)), [$M$], anchor: "east")

        let k = (decline.at(0) * m_dot.at(1) - decline.at(1) * m_dot.at(0) - line_1.at(1) * decline.at(0) + line_1.at(0) * decline.at(1)) / (decline.at(1) * decline.at(1) + decline.at(0) * decline.at(0))

        circle((m_dot.at(0) + 2 * k * decline.at(1), m_dot.at(1) - 2 * k * decline.at(0)), radius: 3pt, fill: red, name: "Mprime")
        content((rel: (0.14, 0)), [$M^prime$], anchor: "west")

        line("M", "Mprime", stroke: (dash: "dashed", paint: gray))

        circle((m_dot.at(0) + k * decline.at(1), m_dot.at(1) - k * decline.at(0)), radius: 3pt, fill: gray, name: "K")
        content((rel: (0, -0.18)), [$K$], anchor: "north")

        content((line_2.at(0) + 0.1, line_2.at(1)), [$l$], anchor: "west")

        cetz.angle.right-angle(
            "K",
            "M",
            line_2,
            radius: 0.2,
            label: ""
        )
    })

    $M^prime = S_l (M)$ так, что $cases(M M^prime perp l, M K = K M^prime)$

+ Перенос $T_(arrow(a))$ на вектор $arrow(a)$

    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )


        let alpha = 30deg
        let phi = 70deg
        let a = (1, 0.3)
        let m_dot = (0, 0)

        circle(m_dot, radius: 3pt, fill: gray, name: "M")
        content((rel: (-0.1, 0)), [$M$], anchor: "east")

        circle((m_dot.at(0) + a.at(0), m_dot.at(1) + a.at(1)), radius: 3pt, fill: red, name: "Mprime")
        content((rel: (0.1, 0)), [$M^prime$], anchor: "west")

        line((m_dot.at(0) - 0.1, m_dot.at(1) + 0.4), (m_dot.at(0) + a.at(0) - 0.1, m_dot.at(1) + a.at(1) + 0.4), mark: (end: "stealth"))
        content((rel: (0.1, 0)), [$arrow(a)$], anchor: "south")


    })

    $M^prime = T_(arrow(a)) (M)$ так, что $arrow(M M^prime) = arrow(a)$

+ Поворот $R^phi_O$ относительно точки $O$ на ориентированный угол $phi$

    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )

        circle((0, 0), radius: 3pt, fill: gray, name: "O")
        content((rel: (0, -0.1)), [$O$], anchor: "north")
        content((rel: (0.2, 0.4)), [$phi$], anchor: "south")

        let alpha = 30deg
        let phi = 70deg
        let a = 1

        circle((a * calc.cos(alpha), a * calc.sin(alpha)), radius: 3pt, fill: gray, name: "M")
        content((rel: (0.1, 0)), [$M$], anchor: "west")

        circle((a * calc.cos(alpha + phi), a * calc.sin(alpha + phi)), radius: 3pt, fill: red, name: "Mprime")
        content((rel: (-0.1, 0)), [$M^prime$], anchor: "east")

        line("O", "M")
        line("O", "Mprime")

        cetz.angle.angle(
            "O",
            "M",
            "Mprime",
            radius: 0.3,
            label: ""
        )
    })

    $M^prime = R_O^phi (M)$ так, что $cases(angle (M O M^prime) = phi, O M = O M^prime)$

    Традиционно принимаем положительный угол за поворот против часовой стрелки

#Def Конформное преобразование -- преобразование, сохраняющее углы

Виды конформных преобразований на плоскости $RR^2$:

+ Гомотетия $H_O^k$ относительно точки $O$ с коэффициентом $k in RR$


    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )

        line((-0.8, -0.4), (2, 1))

        circle((0, 0), radius: 3pt, fill: gray, name: "O")
        content((rel: (0, -0.1)), [$O$], anchor: "north")

        circle((1, 0.5), radius: 3pt, fill: gray, name: "M")
        content((rel: (0, -0.1)), [$M$], anchor: "north")

        circle((1.5, 0.75), radius: 3pt, fill: red, name: "Mprime")
        content((rel: (0, 0.1)), [$M^prime$], anchor: "south")

    })

    $M^prime = H_O^k (M)$ так, что $cases(M^prime in O M, (O M^prime) / (O M) = k)$

    #Nota Если $k < 0$, то точки $M$ и $M^prime$ будут по разные стороны от точки $O$

+ Подобие $P_k$ с коэффициентом $k$ -- композиция движения и гомотетии $P_k = F compose H_O^k$ (здесь $(f compose g)(x) = f(g(x))$)

    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )

        line((-0.5, -0.4), (1, 0), (0.2, 1), close: true)
        line((1.25, -0.6), (3.5, 0), (2.3, 1.5), close: true)
    })


=== 1.4 Линейные операторы

#Def Линейный оператор $cal(A)$ -- отображение $cal(A) : V arrow V$ (в общем случае $cal(A) : V arrow W$), для которого соблюдаются свойства:

+ $cal(A)(x + y) = cal(A)(x) + cal(A)(y)$
+ $cal(A)(lambda x) = lambda cal(A)(x)$

Если для $V$ определен базис $epsilon_V = {e_1, dots, e_n}$, а для $W$ базис $epsilon_W = {e^prime_1, dots, e^prime_m}$, то действие оператора можно представить так:

$cal(A)(x) = cal(A)(sum_(i = 1)^n lambda_i e_i) = sum_(i = 1)^n lambda_i cal(A)(e_i) = sum_(i = 1)^n lambda_i sum_(j = 1)^m mu_j e^prime_j = sum_(i = 1)^n sum_(j = 1)^m a_(i j) e^prime_j$

#Def Матрица $A = {a_(i j)}_(i = 1..n, j = 1..m) = mat(a_(1 1), dots, a_(1 n); dots.v, dots.down, dots.v; a_(m 1), dots, a_(m n))$ называется матрицей оператора $cal(A) : V arrow W$

Тогда $cal(A) x = y arrow.l.r.double.long A vec(x_1, dots.v, x_n) = vec(y_1, dots.v, y_m)$

#v(10mm)

Найдем матрицы геометрических преобразований на $RR^2$

+ Осевая симметрия $S_l$ 

    Чаще всего на практике используются $S_(O x)$ и $S_(O y)$

    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )

        line((-0.2, 0), (1.5, 0), mark: (end: "stealth"))
        content((rel: (0, -0.1)), [$x$], anchor: "north")
        line((0, -1), (0, 1), mark: (end: "stealth"))
        content((rel: (-0.1, 0)), [$y$], anchor: "east")

        circle((0, 0), radius: 3pt, fill: gray, name: "O")
        content((-0.1, -0.1), [$0$], anchor: "north")

        circle((1, 0.6), radius: 3pt, fill: gray, name: "M")
        content((rel: (0, 0.1)), [$M (x, y)$], anchor: "south")
        line("O", "M", mark: (end: "stealth"))

        circle((1, -0.6), radius: 3pt, fill: red, name: "Mprime")
        content((rel: (0, -0.1)), [$M^prime (x, -y)$], anchor: "north")
        line("O", "Mprime", mark: (end: "stealth"))

        line("M", "Mprime", stroke: (dash: "dashed", paint: gray))

    })

    Для $S_(O x)$ это матрица $mat(1, 0; 0, -1)$: $mat(1, 0; 0, -1) vec(x, y) = vec(x, -y)$

    А для $O y$ это $mat(-1, 0; 0, 1)$: $mat(-1, 0; 0, 1) vec(x, y) = vec(-x, y)$

+ Перенос $T_(arrow(a))$ на вектор

  Перенос точки на вектор выносит ее из линейного пространства, где точки имеют общее начало, поэтому перенос не является линейным оператором: $vec(x, y) + vec(a_1, a_2) = vec(x prime, y prime)$ 

+ Поворот 

  Активным преобразованием называется поворот плоскости, а пассивным -- поворот системы координат. Такие преобразования взаимно обратны

  Тогда поворот системы координат задается матрицей $mat(cos phi, -sin phi; sin phi, cos phi) $

  А поворот плоскости задается обратной матрицей $mat(cos phi, sin phi; -sin phi, cos phi) $

+ Гомотетия

  Для гомотетии $H_O^k$ матрица оператора равна $mat(k, 0; 0, k) vec(x, y) = vec(x prime, y prime)$

=== 1.5 Аффинное преобразование

#DefN(1) Преобразование $phi : RR^2 arrow RR^2$ называется аффинным преобразованием, если $phi$ -- биекция, и для всяких точек на прямой $A, B, C in l$ справедливо, что $phi(A), phi(B), phi(C) in phi(l)$ и $(A B)/(B C) = (phi(A) phi(B)) / (phi(B) phi(C))$

#Nota Аффинное преобразование не сохраняет углы и расстояния, но сохраняет параллельность

#Nota Кроме этого все треугольник аффинно-эквивалентны, то есть один треугольник можно перевести в любой другой с помощью аффинного преобразования

#DefN(2) Преобразование $phi$ -- аффинное преобразование, если оно переводит одну систему координат в другую систему координат

#align(center)[
#cetz.canvas(length: 2cm, {
    import cetz.draw: *

    set-style(
        mark: (fill: black, scale: 2),
        stroke: (thickness: 0.4pt, cap: "round"),
        content: (padding: 1pt, font: 17pt)
    )

    line((-0.2, 0), (1.5, 0), mark: (end: "stealth"))
    content((rel: (0, -0.1)), [$x$], anchor: "north")
    line((0, -1), (0, 1), mark: (end: "stealth"))
    content((rel: (-0.1, 0)), [$y$], anchor: "east")

    circle((0, 0), radius: 3pt, fill: gray, name: "O")
    content((-0.1, -0.1), [$0$], anchor: "north")

    circle((1, 0.6), radius: 3pt, fill: gray, name: "M")
    content((rel: (0, 0.1)), [$M (x, y)$], anchor: "south")
    line("O", "M", mark: (end: "stealth"))
    line((1, 0), "M", stroke: (dash: "dashed"))
    line((0, 0.6), "M", stroke: (dash: "dashed"))

    line((3.8, -0.06), (5.6, 0.48), mark: (end: "stealth"))
    content((rel: (0, -0.1)), [$x^prime$], anchor: "north")
    line((4.5, -1), (3.5, 1), mark: (end: "stealth"))
    content((rel: (-0.1, 0)), [$y^prime$], anchor: "east")

    circle((4, 0), radius: 3pt, fill: gray, name: "O")
    content((3.9, -0.1), [$0$], anchor: "north")

    circle((5, 0.9), radius: 3pt, fill: gray, name: "M")
    content((rel: (0, 0.1)), [$M^prime (x^prime, y^prime)$], anchor: "south")
    line("O", "M", mark: (end: "stealth"))
    line((3.75, 0.525), "M", stroke: (dash: "dashed"))
    line((5.25, 0.4), "M", stroke: (dash: "dashed"))

    line((2.3, 0), (3.3, 0), mark: (end: "stealth"))
    content((2.8, 0.1), [$phi$], anchor: "south")
})
]

#Mem Система координат -- это определенные точка отсчета, координатная сетка, порядок осей и единичные отрезки

#v(10mm)

Для дальнейшего нам потребуются уравнения прямых:

+ По двум точкам на плоскости: 

    $(x - x_A)/(x_B - x_A) = (y - y_A)/(y_B - y_A) arrow.l.r.double.long mat(delim: "|", x - x_A, y - y_A; x_B - x_A, y_B - y_A) = 0$ 

+ По коэффициентам на плоскости: 

    $cases(x = m t + x_0, y = n t + y_0)$

+ Векторное: $arrow(r) - arrow(r_0) = arrow(a) t$, где $t$ -- параметр

    #cetz.canvas(length: 2cm, {
        import cetz.draw: *

        set-style(
            mark: (fill: black, scale: 2),
            stroke: (thickness: 0.4pt, cap: "round"),
            content: (padding: 1pt, font: 17pt)
        )

        line((-1, 1), (2, 0), mark: (end: "stealth"))
        content((rel: (0, -0.1)), [$l$], anchor: "north")

        circle((0, 0), radius: 3pt, fill: gray, name: "O")
        content((-0.1, -0.1), [$O$], anchor: "north")

        circle((-0.5, 0.86), radius: 3pt, fill: gray, name: "r0")
        content((rel: (0, 0.1)), [$r_0$], anchor: "south")
        line("O", "r0", mark: (end: "stealth"))

        circle((0.5, 0.5), radius: 3pt, fill: gray, name: "r1")
        content((rel: (0, 0.1)), [$r_1$], anchor: "south")
        line("O", "r1", mark: (end: "stealth"))

        circle((1.5, 0.16), radius: 3pt, fill: gray, name: "r")
        content((rel: (0, 0.1)), [$r$], anchor: "south")
        line("O", "r", mark: (end: "stealth"), stroke: (dash: "dashed", paint: gray))

    })

    $arrow(r) - arrow(r_0) = (arrow(r_1) - arrow(r_0)) t$


