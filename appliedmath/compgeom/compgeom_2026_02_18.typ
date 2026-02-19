#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [18.02.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

=== 1.6 Моделирование плоских линий

==== 1.6.1 Общие сведения

#cetz.canvas(length: 2cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 0.4pt, cap: "round"),
    content: (padding: 1pt, font: 17pt)
  )

  line((-2, -0.2), (2.2, -0.2), mark: (end: "stealth"))
  content((rel: (0, -0.1)), [$x$], anchor: "north")
  line((-1.8, -0.4), (-1.8, 2), mark: (end: "stealth"))
  content((rel: (-0.1, 0)), [$y$], anchor: "east")

  let dots = ((-1, 1.6), (-0.5, 1.2), (0, 1), (0.5, 0.5), (1.2, 0.4))

  catmull(..dots)

  point(dots.at(0), name: "M0")
  content((rel: (0, 0.15)), [$M_0(x_0, y_0)$], anchor: "south")
  point(dots.at(2), name: "M")
  content((rel: (0, 0.15)), [$M(x, y)$], anchor: "south")
  point(dots.at(-1), name: "M1")
  content((rel: (0, -0.15)), [$M_1(x_1, y_1)$], anchor: "north")

  point((-1.8, -0.2), name: "O")

  line("O", "M", mark: (end: "stealth"))

  content(("O", 50%, "M"), text(blue)[$arrow(r)_M$], 
    anchor: "south",
    angle: "M",
    padding: .05,
  )
})

Пусть ${arrow(e)_1, arrow(e)_2}$ -- базис (в частности ${arrow(i), arrow(j)}$ -- декартов)

Радиус-вектор точки кривой $gamma$ определяется как $arrow(r)_M = x arrow(e)_1 + y arrow(e)_2$

Чаще всего кривая $gamma$ ориентирована так, что задана начальная точка $M_0(x_0, y_0)$ и пара уравнений $cases(x = x(t), y = y(t))$, где $t in [t_1, t_2]$. Интервал $[t_1, t_2]$ задают ориентацию

Таким образом, $gamma$ может быть задана: 

- параметрически $arrow(r)(t) = x(t) arrow(e)_1 + y(t) arrow(e)_2$
- общим уравнением $f(x, y) = 0$

#v(8mm)

Рассмотрим задания простых кривых:

1. Прямая

  #cetz.canvas({
    import cetz.draw: *
  })

  $arrow(r) = arrow(r)_0 + t(arrow(r)_1 - arrow(r)_0) = t arrow(r)_1 + arrow(r)_0 (1 - t)$

  Последнее выражение полезно, так как для $t in [0, 1]$ уравнение задает отрезок $M_0 M_1$: $arrow(r)(t) |_(t = 0) = arrow(r)_0$, $arrow(r)(t) |_(t = 1) = arrow(r)_1$

2. Окружность

  Параметрическое уравнение: $cases(x = R cos t, y = R sin t)$ для $t in [0, 2 pi)$

  Радиус-вектор задается как $arrow(r)(t) = R(arrow(i) cos t + arrow(j) sin t) = R (cos t, sin t)$

3. Кривая второго порядка в общем виде

  $ a_(1 1) x^2 + 2 a_(1 2) x y + a_(2 2) y^2 + 2 a_(1 3) x + 2 a_(2 3) y + a_(3 3) = 0 $

  При этом один или более из коэффициентов $a_(1 1), a_(1 2), a_(2 2)$ не равны нулю

  Коэффициенты кривой можно представить в виде матрицы: $A = mat(a_(1 1), a_(1 2), a_(1 3); a_(1 2), a_(2 2), a_(2 3); a_(1 3), a_(2 3), a_(3 3))$

  Коэффициенты $a_(1 3)$ и $a_(2 3)$ отвечают за перенос кривой, а $a_(3 3)$ за масштаб

  В однородных координатах $arrow(r) = (x, y) arrow.r.long (x, y, 1)$ получаем:

  $ mat(a_(1 1), a_(1 2), a_(1 3); a_(1 2), a_(2 2), a_(2 3); a_(1 3), a_(2 3), a_(3 3)) vec(x, y, 1) = vec(a_(1 1) x + a_(1 2) y + a_(1 3), a_(1 2) x + a_(2 2) y + a_(2 3), a_(1 3) x + a_(2 3) y + a_(3 3)) $

  Если слева домножить на вектор-строку $(x, y, 1)$, то получим:

  $ (x, y, 1) mat(a_(1 1), a_(1 2), a_(1 3); a_(1 2), a_(2 2), a_(2 3); a_(1 3), a_(2 3), a_(3 3)) vec(x, y, 1) &= vec(x, y, 1)^T vec(a_(1 1) x + a_(1 2) y + a_(1 3), a_(1 2) x + a_(2 2) y + a_(2 3), a_(1 3) x + a_(2 3) y + a_(3 3)) \ &= a_(1 1) x^2 + a_(1 2) x y + a_(1 3) x + a_(1 2) x y + a_(2 2) y^2 + a_(2 3) y + a_(1 3) x + a_(2 3) y + a_(3 3) \ &= a_(1 1) x^2 + 2 a_(1 2) x y + a_(2 2) y^2 + 2 a_(1 3) x + 2 a_(2 3) y + a_(3 3) $

  Тогда общее уравнение кривой второго порядка в матричном виде записывается как $(x, y, 1) dot A dot vec(x, y, 1) = 0$

#Nota Пусть есть аффинный базис ${arrow(e)_1, arrow(e)_2}$. Нужно перевести координаты точки $M (xi, eta)$ из нового базиса ${arrow(e)_1, arrow(e)_2}$ в координаты $vec(x, y)$ из нового базиса ${arrow(i), arrow(j)}$ 

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

  point((0, 0), name: "O")
  content((rel: (-0.05, -0.05)), [$O$], anchor: "north-east")


  let (nx, ny) = (-2.3, 0.6)

  line((nx + 3.8, ny - 0.06), (nx + 5.6, ny + 0.48), mark: (end: "stealth"), stroke: (dash: "dashed"))
  content((rel: (0, -0.1)), [$xi$], anchor: "north")
  line((nx + 4.1, ny - 0.2), (nx + 3.5, ny + 1), mark: (end: "stealth"), stroke: (dash: "dashed"))
  content((rel: (-0.1, 0)), [$eta$], anchor: "east")

  circle((nx + 4, ny), radius: 3pt, fill: gray, name: "Oprime")
  content((nx + 3.9, ny - 0.1), [$O'$], anchor: "north")

  let (mxi, meta) = (4.3, 0.9)
  circle((nx + mxi, ny + meta), radius: 3pt, fill: gray, name: "M")
  content((rel: (0, 0.1)), [$M (x, y)_(O i j) = M(xi, eta)_(O' e_1 e_2)$], anchor: "south-west")
  line("Oprime", "M", mark: (end: "stealth"), stroke: (dash: "dashed"))

  content(("O", 50%, "Oprime"), [$arrow(c)$],
    angle: "Oprime",
    padding: .05,
    anchor: "south"
  )
  content(("O", 50%, "M"), text(blue)[$arrow(r)_M$],
    angle: "M",
    padding: .05,
    anchor: "south"
  )

  line("O", "M", mark: (end: "stealth"))
  line("O", "Oprime", mark: (end: "stealth"))

})

Радиус-вектор точки в базисе $vec(x, y)$ равен $arrow(r)_M = vec(x, y) = xi arrow(e)_1 + eta arrow(e)_2 + arrow(c)$. Здесь $arrow(c)$ -- смещение начал координат

В однородных координатах это выглядит так:

$vec(x, y, 1) = vec(xi e_(1 x), xi e_(1 y), 0) + vec(eta e_(2 x), eta e_(2 y), 0) + vec(c_1, c_2, 1) = mat(e_(1 x), e_(2 x), c_1; e_(1 y), e_(2 y), c_2; 0, 0, 1) vec(xi, eta, 1) = P vec(xi, eta, 1)$

Здесь $P = mat(e_(1 x), e_(2 x), c_1; e_(1 y), e_(2 y), c_2; 0, 0, 1)$ -- матрица аффинного преобразования, где $mat(e_(1 x), e_(2 x); e_(1 y), e_(2 y))$ -- матрица приведения из базиса ${arrow(i), arrow(j)}$ в базис ${arrow(e)_1, arrow(e)_2}$

Такая матрица не меняет инварианты, поэтому можно делать подобные преобразования кривых:

$ (x, y, 1) A vec(x, y, 1) = 0 arrow.double.long (xi, eta, 1) #text(blue)[$P$] A #text(blue)[$P^(-1)$] vec(xi, eta, 1) = 0 $

#Def Инварианты кривой второго порядка -- выражения, значения которых остаются постоянными при применении аффинных преобразований:

$ I_1 = a_(1 1) + a_(2 2), I_2 = mat(a_(1 1), a_(1 2); a_(1 2), a_(2 2); delim: "|"), I_3 = mat(a_(1 1), a_(1 2), a_(1 3); a_(1 2), a_(2 2), a_(2 3); a_(1 3), a_(2 3), a_(3 3); delim: "|") $

Тип кривой определяется по инвариантам:

- Если $I_2 > 0$, то кривая эллиптического типа
- Если $I_2 < 0$, то кривая гиперболического типа
- Если $I_2 = 0$, то кривая параболического типа

==== 1.6.2 Дифференциальные характеристики

#Mem Для кривой $gamma : cases(x = x(t), y = y(t))$

- Гладкость кривой -- непрерывная дифференцируемость $x(t)$ и $y(t)$, то есть для всякой $M in gamma$ существуют $(d y)/(d x) = phi(t)$, которая непрерывная

- Касательная -- вектор (или прямая), имеющая одну общую точку с кривой в окрестности

  Если кривая задается как $arrow(r) (t) = x(t) arrow(i) + y(t) arrow(j)$, то касательная задается как производная:

  $ arrow(r)' (t) = (d arrow(r)(t))/(d t) = (d x)/(d t) arrow(i) + (d y)/(d t) arrow(j) $

- Нормаль -- перпендикуляр к кривой в точке. Вектор нормали задается как перпендикулярный к касательной: $arrow(n) perp arrow(r)'$

- Длина дуги (элемента): $d s = sqrt(x'^2 (t) + y'^2(t)) d t = |arrow(r)' (t)| d t$

#v(8mm)

Рассмотрим новые характеристики для кривой:

- Кривизна кривой в точки 

  #cetz.canvas(length: 1cm, {
    import cetz.draw: *

    set-style(
      mark: (fill: black, scale: 2),
      stroke: (thickness: 0.4pt, cap: "round"),
      content: (padding: 1pt, font: 17pt)
    )

    let cubic = ((1.5, -1), (6.5, -1), (4, 1.5))

    bezier(..cubic)

    let tau1 = (cubic.at(2).at(0) - cubic.at(0).at(0), cubic.at(2).at(1) - cubic.at(0).at(1))
    let tau2 = (cubic.at(2).at(0) - cubic.at(1).at(0), cubic.at(2).at(1) - cubic.at(1).at(1))

    line(cubic.at(0), vecsum(cubic.at(0), veck(tau1, 1.3)), stroke: (dash: "dashed"))
    line(cubic.at(1), vecsum(cubic.at(1), veck(tau2, 1.3)), stroke: (dash: "dashed"))

    content((cubic.at(0), 60%, cubic.at(2)), [$tau_1$], angle: cubic.at(2), anchor: "south", padding: 0.1)
    content((cubic.at(1), 60%, cubic.at(2)), [$tau_2$], angle: cubic.at(1), anchor: "south", padding: 0.1)

    point(cubic.at(0))
    content(cubic.at(0), [$A$], anchor: "east", padding: 0.2)
    point(cubic.at(1))
    content(cubic.at(1), [$B$], anchor: "west", padding: 0.2)

    cetz.angle.angle(vecsum(cubic.at(1), tau2), vecsum(cubic.at(0), veck(tau1, 1.3)), cubic.at(1), label: $ alpha $, direction: "cw", label-radius: 145%)
  })

  Касательная $tau_1$ переходит в $tau_2$ при $A arrow B$, поворачиваясь на угол $alpha$ -- угол смежности

  Средняя кривизна на дуге $attach(limits(A B), t: smile)$ равна $K_(с р) = alpha/(|attach(limits(A B), t: smile)|)$

  #Def Кривизна кривой $gamma$ в точке $A$ определяется как $K_A = lim_(B arrow A \ text("по") arc(A B)) K_(с р) = lim_(|arc(A B)| arrow 0) alpha/(|arc(A B)|)$

  #Ex Окружность 

  $angle A O B = alpha, |arc(A B)| = alpha R$, тогда $K_A = lim_(B arrow A) alpha / (alpha R) = 1/R$

- Радиус кривизны

  #Def Величина $1/K_A = R_A$, обратная кривизне в точке, называется радиусом кривизны в точке 

  #Nota У окружности радиус кривизны совпадает с ее собственным радиусом. Сама окружность -- линия постоянной кривизны. Другая такая линия постоянной кривизны -- прямая, где кривизна равна $0$

  #cetz.canvas(length: 3.5cm, {
    import cetz.draw: *

    set-style(
      mark: (fill: black, scale: 1.4),
      stroke: (thickness: 0.4pt, cap: "round"),
      content: (padding: 1pt, font: 17pt)
    )

    let points = ((0.12, 0.81), (0.72, 1.08), (1.59, 0.82), (2.01, 1.33), (2.74, 1.0))

    catmull(..points)

    content((), [$gamma$], anchor: "north", padding: 0.1)

    circle((0.72, 0.73), radius: 0.35, name: "O")

    point(points.at(1), name: "M")
    content((), [$M$], anchor: "south", padding: 0.1)

    line("O.center", "M", mark: (end: "stealth"), )
    line("M", (rel: (0.4, 0)), mark: (end: "stealth"))
    content((), [$arrow(r)'$], anchor: "south", padding: 0.05)

    point("O.center")
    content(("O.center", 40%, "M"), text(blue)[$R_M$], anchor: "west", padding: 0.05)

  })

- Центр кривизны

  #Def Центр кривизны кривой $gamma$ в точке $M$ -- это точка на нормали к $gamma$ в точке $M$ на расстоянии $R_M$ от $M$, находящаяся в той полуплоскости, разделенной касательной, что и окрестность кривой

  #Def Эволюта кривой -- множество центров кривизны

Для характеристик можно выразить другие формулы:

- Кривизна $K = lim_(Delta s arrow 0) (Delta phi)/(Delta s) = phi'(s) = (d phi)/(d t) (d t)/(d s) attach(=, t: t = x) ((d phi)/(d x))/((d s)/(d x))$

  $tg phi = (d y)/(d x), quad phi = op("arctg") (d y)/(d x)$ -- угол касательной

  $(d s)/(d x) = sqrt(1 + y'^2_x)$

  $(d phi)/(d x) = ((d^2 y)/(d x^2))/(((d y)/(d x))^2 + 1)$

  $K = ((d^2 y)/(d x^2))/((((d y)/(d x))^2 + 1)^(3/2))$

  В параметрическом задании $K = (|y''_t x'_t - y'_t x''_t|)/(x'^2 + y'^2)^(3/2)$

- Центр кривизны: $cases(x_0 = x - (y' (x'^2 + y'^2))/(x' y'' - x'' y'), y_0 = y + (x' (x'^2 + y'^2))/(x' y'' - x'' y'))$
