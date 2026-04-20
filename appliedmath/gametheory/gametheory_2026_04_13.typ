#import "../../preamble.typ": *

#let subject-name = [Теория игр]
#let date-header = [13.04.2026]
#let lecturer-name = [Лекции Блаженова А. В.]

#show: basic-template
#show: doc => header-template(
  subject-name: subject-name,
  date-header: date-header,
  lecturer-name: lecturer-name,
  doc
)

== Лекция 8

=== Кооперативные игры

#Def Игру называют кооперативной, если все или часть игроков могут предварительно договариваться о совместных действиях

#Def Игра называется сепарабельной или без побочных действий, если игроки не могут обмениваться выигрышами. Обычно кооперативные игры проходят без побочных платежей

Рассмотрим кооперативную игру двух игроков. Введем обозначения:

- $H_1$ -- функция выигрышей первого игрока
- $H_2$ -- функция выигрышей второго игрока
- $nu_1$ -- выигрыш, который может позволить первый игрок, если он вступает в переговоры
- $nu_2$ -- выигрыш, который может позволить второй игрок, если он вступает в переговоры
- Множество $S = (H_1, H_2)$ -- множество совместных выигрышей, который они могут обеспечить, если вступят в переговоры

  Как правило, это выпуклое замкнутое ограниченное множество

  
  #align(center)[
  #cetz.canvas(length: 2cm, {
      import cetz.draw: *

      set-style(
          mark: (fill: black, scale: 1),
          stroke: (thickness: 1.3pt, cap: "round")
      )

      let nu_v = 0.8

      line((0, -0.3), (0, 1.7), mark: (end: ">"))
      content((), [$y$], padding: 0.15, anchor: "east")
      line((-0.3, 0), (1.7, 0), mark: (end: ">"))
      content((), [$x$], padding: 0.15, anchor: "north")
      point((0, 0), name: "O")
      content((), [$O$], padding: 0.15, anchor: "north-east")

      let S(stroke, fill: none) = merge-path(stroke: stroke, {
        line((0, 0), (0, 1))
        arc((0, 1), start: 135deg, stop: -45deg, radius: calc.sqrt(2) / 2)
        line((1, 0), (0, 0))
        line((0, 0), (0, 1))
      }, fill: fill)

      S(blue.transparentize(50%) + 2pt, fill: hatching-fill(step: 10pt, stroke-style: (paint: blue.transparentize(50%), )))

      content((0.5, 0.5), box(fill: rgb(255, 255, 255, 70%), inset: (y: 2pt))[#text(1.5em)[$S$]])

      intersections("i1", {
          S(0pt)
          line((0, nu_v), (2, nu_v), stroke: 0pt)
        }
      )
      intersections("i2", {
          S(0pt)
          line((nu_v, 0), (nu_v, 2), stroke: 0pt)
        }
      )

      line("i1.0", "i1.1", stroke: (paint: luma(40%), dash: "dashed", thickness: 2pt), name: "nux")
      line("i2.0", "i2.1", stroke: (paint: luma(40%), dash: "dashed", thickness: 2pt), name: "nuy")

      content("nux.start", [$nu_2$], anchor: "east", padding: 0.12)
      content("nuy.end", [$nu_1$], anchor: "north", padding: 0.12)
  })
  ]



Игрокам нужно договориться о точке в множестве $S$, которая показывает их совместные действия и намерения

Точка $(nu_1, nu_2)$ в $S$ называется точкой угрозы

Ясно, что игрокам нужно переговариваться, чтобы $H_1 >= nu_1$, $H_2 >= nu_2$. Такую точку назовем арбитражной. Также ясно, что арбитражная точка должна находится в множестве Парето $Pi(S)$, в противном случае найдется точка, в которой выигрыш одного игрока будет больше


  #align(center)[
  #cetz.canvas(length: 2cm, {
      import cetz.draw: *

      set-style(
          mark: (fill: black, scale: 1),
          stroke: (thickness: 1.3pt, cap: "round")
      )

      line((0, -0.3), (0, 1.7), mark: (end: ">"))
      content((), [$y$], padding: 0.15, anchor: "east")
      line((-0.3, 0), (1.7, 0), mark: (end: ">"))
      content((), [$x$], padding: 0.15, anchor: "north")
      point((0, 0), name: "O")
      content((), [$O$], padding: 0.15, anchor: "north-east")

      let nu_v = 0.8
      
      let S(stroke, fill: none) = merge-path(stroke: stroke, {
        line((0, 0), (0, 1))
        arc((0, 1), start: 135deg, stop: -45deg, radius: calc.sqrt(2) / 2)
        line((1, 0), (0, 0))
        line((0, 0), (0, 1))
      }, fill: fill)

      S(blue.transparentize(50%) + 2pt, fill: hatching-fill(step: 10pt, stroke-style: (paint: blue.transparentize(50%), )))

      content((0.5, 0.5), box(fill: rgb(255, 255, 255, 70%), inset: (y: 2pt))[#text(1.5em)[$S$]])

      intersections("i1", {
          S(0pt)
          line((0, nu_v), (2, nu_v), stroke: 0pt)
        }
      )
      intersections("i2", {
          S(0pt)
          line((nu_v, 0), (nu_v, 2), stroke: 0pt)
        }
      )

      line("i1.0", "i1.1", stroke: (paint: luma(40%), dash: "dashed", thickness: 2pt), name: "nux")
      line("i2.0", "i2.1", stroke: (paint: luma(40%), dash: "dashed", thickness: 2pt), name: "nuy")

      content("nux.start", [$nu_2$], anchor: "east", padding: 0.12)
      content("nuy.end", [$nu_1$], anchor: "north", padding: 0.12)

      arc((0.5, calc.sqrt(2) / 2 + 0.5), start: 90deg, stop: 0deg, radius: calc.sqrt(2) / 2, stroke: red + 2.3pt)
      content((0.5, 1.4), box(fill: rgb(255, 255, 255, 70%), inset: (y: 2pt))[#text(1em, red)[$Pi(S)$]])

      arc("nuy.start", start: calc.acos((nu_v - 0.5) / (calc.sqrt(2) / 2)), stop: calc.asin((nu_v - 0.5) / (calc.sqrt(2) / 2)), radius: calc.sqrt(2) / 2, stroke: (paint: green, thickness: 2.6pt, cap: "round"))
      content((), text(green)[$П М$], anchor: "south-west", padding: 0.06)
  })
  ]


Из-за этих условий арбитражная точка будет находится на пересечении $П М = Pi(S) inter { H_1 >= nu_1, H_2 >= nu_2 }$ этих множеств

Вопрос -- как ее выбрать?

=== Арбитражная схема Нэша

#Def Арбитражным решением Нэша называется точка $(H_1^*, H_2^*)$, удовлетворяющая аксиомам: 

#enum(numbering: it => "N" + str(it) + ":",
  [$H_1^* >= nu_1$ и $H_2^* >= nu_2$ -- принцип индивидуальной рациональности],
  [$(H_1^*, H_2^*) in S$ -- допустимость решения],
  [$(H_1^*, H_2^*) in Pi(S)$ -- Парето-оптимальность (или групповая рациональность)],
  [Если $S$ - симметрична ($(x, y) in S arrow.long.double (y, x) in S$) и $nu_1 = nu_2$, то $H_1^* = H_2^*$ -- симметричность, если игроки в равных условиях, то и выигрыши должны быть равными],
  [Независимость от линейного преобразования: если $S'$ получается из $S$ с помощью линейного преобразования $cases(H'_1 = a H_1 + b, H'_2 = c H_2 + d)$ и точка $(H_1^*, H_2^*)$ -- арбитражное решение в $S$, то $(a H_1^* + b, c H_2^* + d)$ -- решение в другом множестве],
  [Независимость от посторонних альтернатив: если $(H_1^*, H_2^*) in S subset S'$ и $(H_1^*, H_2^*)$ -- решение в $S'$, то $(H_1^*, H_2^*)$ -- решение в игре с $S$],
)

#theorem[
  #ThN("Нэша") Если множество $S$ -- выпуклое ограниченное замкнутое множество, то существует единственное решение арбитражной схемы Нэша, которое является максимумом функции $u(H_1, H_2) = (H_1 - nu_1) dot (H_2 - nu_2)$
]

Здесь $(H_1 - nu_1)$ -- дополнительный выигрыш первого игрока из-за участия в переговорах, $(H_2 - nu_2)$ -- дополнительный выигрыш второго игрока, а $u(H_1, H_2)$ -- общая полезность

#Nota Обобщая на $n$ игроков, получаем $u(H_1, dots, H_n) = (H_1 - nu_1) (H_2 - nu_2) dot dots dot (H_3 - nu_3) = Pi_(i = 1)^n (H_i - nu_i)$

С середины 1950-ых годов по такой схеме работали американские компании, чтобы получать максимальную выгоды от победы в государственных тендерах

=== Биматричные кооперативные игры

#theorem[
  #Th В биматричной игре $S$ - выпуклый многоугольник, натянутый на вершины $(H_1, H_2)$ выигрышей игроков при применении ими чистых стратегий
]

Следствие: любая биматричная кооперативная игра имеет ровно одну арбитражную точку Нэша

#ExN("Семейный спор") Муж и жена решают, куда пойти в субботу: на футбол или балет

$ М = mat(4, 2; 0, 1) quad Ж = mat(1, 2; 0, 4) $

Найдем $v_1$ и $v_2$, рассматривая каждую матрицу как матричную игру. Для $М$ седловая точка -- $nu_1 = 2$, стратегия -- $P^* = (1, 0)$ (идти на футбол), а для $Ж$ седловая точка -- $nu_2 = 2$, стратегия -- $Q^* = (0, 1)$ (идти на футбол)

Изобразим область $S$ совместных выигрышей:

#align(center)[
#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  default-style

  line((0, -0.3), (0, 5), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "east")
  line((-0.3, 0), (5, 0), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  let nu = 2

  let dots = ((1, 4), (4, 1), (0, 0), (2, 2))

  for (i, p) in dots.enumerate() {
    point(p, name: "M" + str(i))
  }
  content("M0", [$A$], anchor: "south", padding: 0.18)
  content("M1", [$B$], anchor: "west", padding: 0.18)

  line("M2", "M0")
  line("M2", "M1")
  line("M0", "M1", stroke: red + 2pt)
  
  line("M3", ((), "|-", (0, 3)), stroke: dashed_gray)
  point((2, 3), name: "T1")
  content((), [$T_1$], anchor: "south", padding: 0.18)

  line("M3", ((), "-|", (3, 2.5)), stroke: dashed_gray)
  point((3, 2), name: "T2")
  content((), [$T_2$], anchor: "west", padding: 0.18)

  line("T1", "T2", stroke: green + 3pt)

  point((2.5, 2.5), name: "N", fill: green)
  content((), [$N$], anchor: "south-west", padding: 0.12)
  content("M3", [$T$], anchor: "north-east", padding: 0.12)
})]

$П М = Pi(S) inter { H_1 >= nu_1, H_2 >= nu_2 } = [T_1, T_2]$

Теперь максимизируем функцию $u(H_1, H_2) = (H_1 - nu_1)(H_2 - nu_2)$

Уравнение отрезка $A B$ можно представить как $p A + (1 - p) B = p (1, 4) + (1 - p) (4, 1) = (4 - 3 p, 1 + 3 p)$

$u(H_1, H_2) = u(p) = (4 - 3p - 2) (1 + 3p - 2) = (2 - 3p)(3p - 1) = 9p^2 + 9p - 2$

Максимум этой функции находится при $p = 1/2$, то есть на середине отрезка $A B$

Получаем $(H_1^*, H_2^*) = 1/2 A + 1/2 B$, то есть муж и жена при помощи жребия совместно решают, куда пойти вместе. Тогда совместный выигрыш увеличивается на $0.5$

#v(8mm)

#ExN("Дилемма двух заключенных")

$ A = mat(2, 0; 3, 1) quad B = mat(2, 3; 0, 1) $

$nu_1 = 1, nu_2 = 1$


#align(center)[
#cetz.canvas(length: 1.2cm, {
  import cetz.draw: *

  default-style

  line((0, -0.3), (0, 4), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "east")
  line((-0.3, 0), (4, 0), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  let nu = 1

  let dots = ((0, 3), (3, 0), (2, 2), (1, 1))

  for (i, p) in dots.enumerate() {
    point(p, name: "M" + str(i), fill: if i == 2 { green } else { gray })
  }
  content("M0", [$A$], anchor: "south-west", padding: 0.18)
  content("M1", [$C$], anchor: "north-west", padding: 0.18)
  content("M2", [$B$], anchor: "south-west", padding: 0.18)
  content("M3", [$T$], anchor: "north-east", padding: 0.18)

  line("M0", "M3")
  line("M3", "M1")
  line("M1", "M2", stroke: red + 2pt)
  line("M0", "M2", stroke: red + 2pt)

  line("M3", ((), "|-", (0, 2.5)), stroke: dashed_gray)
  point((1, 2.5), name: "T1")
  content((), [$T_1$], anchor: "south", padding: 0.18)

  line("M3", ((), "-|", (2.5, 2.5)), stroke: dashed_gray)
  point((2.5, 1), name: "T2")
  content((), [$T_2$], anchor: "west", padding: 0.18)

  line("T1", "M2", stroke: green + 3pt)
  line("T2", "M2", stroke: green + 3pt)
})]

Здесь видно, что область симметрична, поэтому согласно аксиоме N4 арбитражной точкой будет точка $B(2, 2)$ -- игроки должны вести себя мирно

Точка $T(1, 1)$ является точкой угрозой

#v(8mm)

#ExN("Перекресток") На нерегулируемом перекрестке две машины, у каждой есть две стратегии: ехать или остановиться

$ A = mat(1, 0.5; 2, 0) B = mat(1, 2; 0.5, 0) $

Здесь $nu_1 = nu_2 = 0.5$

#align(center)[
#cetz.canvas(length: 1.4cm, {
  import cetz.draw: *

  default-style

  line((0, -0.3), (0, 2.5), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "east")
  line((-0.3, 0), (2.5, 0), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  let nu = 2

  let dots = ((0.5, 2), (2, 0.5), (0, 0), (0.5, 0.5))

  for (i, p) in dots.enumerate() {
    point(p, name: "M" + str(i))
  }
  content("M0", [$A$], anchor: "south", padding: 0.18)
  content("M1", [$B$], anchor: "west", padding: 0.18)
  content("M3", [$T$], anchor: "north-east", padding: 0.11)

  line("M2", "M0")
  line("M2", "M1")
  line("M0", "M1", stroke: green + 2pt)

  line("M3", "M0", stroke: dashed_gray)
  line("M3", "M1", stroke: dashed_gray)

  point((1.25, 1.25), fill: green)
  content((), [$N$], anchor: "south-west", padding: 0.12)
})]

$ П М = A B = Pi (S)$, в силу симметрии получаем арбитражную точку $N = (1.25, 1.25) = 1/2 A + 1/2 B$

Вывод: поставить светофор на перекрестке с равной продолжительностью для каждого потока

#v(8mm)

#Ex Студент (1-ый игрок) готовится к экзамену: стратегия $A_1$ -- он готовится ($Г$), стратегия $A_2$ -- не готовится ($Н$). Стратегии преподавателя (2-ого игрока): $B_1$ -- принять экзамен ($П$), $B_2$ -- не принять ($Н$)

$ A = mat(2, -1; 1, 0) quad B = mat(1, -3; -2, -1) $

Для такой игры $nu_1 = 0$, $nu_2 = -1.6$

#align(center)[
#cetz.canvas(length: 1.2cm, {
  import cetz.draw: *

  default-style

  line((0, -3.5), (0, 1.5), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "east")
  line((-1.3, 0), (2.5, 0), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  let nu = 2

  let dots = ((-1, -3), (0, -1), (2, 1), (1, -2))

  for (i, p) in dots.enumerate() {
    point(p, name: "M" + str(i))
    
  }
  content("M0", [$A$], anchor: "east", padding: 0.18)
  content("M1", [$B$], anchor: "south-east", padding: 0.12)
  content("M2", [$C$], anchor: "south", padding: 0.18)
  content("M3", [$D$], anchor: "north-west", padding: 0.12)

  line("M0", "M1")
  line("M1", "M2")
  line("M2", "M3")
  line("M3", "M0")

  point("M2", fill: green)
})]

Здесь очевидно, что наилучшая точка для обоих сторон -- это $C$

#v(10mm)

Рассмотрим вырожденные случаи:

- Матричная антагонистическая игра $A, B = -A$ -- здесь интересы прямо противоположны, $S : y = -x$, точка Нэша -- это точка угрозы

- Матричная игра $A, B = A$; здесь множество Парето -- это верхний конец отрезка $S : y = x$

