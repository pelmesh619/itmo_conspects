#import "../../preamble.typ": *

#let subject-name = [Вычислительная \ геометрия]
#let date-header = [11.03.2026]
#let lecturer-name = [Лекции Далевской О. П.]

#show: basic-template
#show: doc => header-template(
    subject-name: subject-name,
    date-header: date-header,
    lecturer-name: lecturer-name,
    doc
)

== 2. Геометрический поиск

=== 2.1 Пересечение отрезков

Геометрическая задача -- определить, какие из $N$ отрезков на плоскости пересекаются, и найти точки пересечения

Для начала рассмотрим два отрезка:

#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1, 1)
  let b = (4, 3.5)
  let c = (5, 2)
  let d = (2, 3)
  line(a, b)
  line(c, d)

  point(a)
  content((), [$a(x_1, y_1)$], anchor: "east", padding: 0.15)
  point(b)
  content((), [$b(x_2, y_2)$], anchor: "west", padding: 0.15)
  point(c)
  content((), [$c(x_3, y_3)$], anchor: "west", padding: 0.15)
  point(d)
  content((), [$d(x_4, y_4)$], anchor: "east", padding: 0.15)
})

Отрезки будут заданы координатами вершин $a(x_1, y_1)$, $b(x_2, y_2)$, $c(x_3, y_3)$, $d(x_4, y_4)$

Грубый способ определить то, что отрезки не пересекаются, -- сравнить абсциссы $min(x_1, x_2)$ и $max(x_3, x_4)$ (или наоборот) или аналогично ординаты (то есть прямоугольники, где диагональ -- отрезок)

#grid(columns: (1fr, 1fr, 1fr), align: center + horizon, [
#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round"),
  )

  let a = (1, 1)
  let b = (4, 3.5)
  let c = (4.5, 1.5)
  let d = (2, 3)
  line(a, b)
  line(c, d)

  let min(x, y) = if (x < y) { x } else { y }
  let max(x, y) = if (x > y) { x } else { y }

  let boundrect(p1, p2) = rect((min(p1.at(0), p2.at(0)), min(p1.at(1), p2.at(1))), (max(p1.at(0), p2.at(0)), max(p1.at(1), p2.at(1))), stroke: (dash: "dashed", paint: luma(60%)))

  boundrect(a, b)
  boundrect(c, d)

  let left = max(min(a.at(0), b.at(0)), min(c.at(0), d.at(0)))
  let right = min(max(a.at(0), b.at(0)), max(c.at(0), d.at(0)))
  let top = min(max(a.at(1), b.at(01)), max(c.at(1), d.at(1)))
  let bottom = max(min(a.at(1), b.at(01)), min(c.at(1), d.at(1)))

  if (left < right and bottom < top) {
    hatching((left, bottom), (right - left, top - bottom), 0.2)
  }

  point(a)
  content((), [$a(x_1, y_1)$], anchor: "north", padding: 0.15)
  point(b)
  content((), [$b(x_2, y_2)$], anchor: "west", padding: 0.15)
  point(c)
  content((), [$c(x_3, y_3)$], anchor: "west", padding: 0.15)
  point(d)
  content((), [$d(x_4, y_4)$], anchor: "east", padding: 0.15)
})],
[
#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1.5, 1)
  let b = (4, 3)
  let c = (5, 2)
  let d = (2, -1)
  line(a, b)
  line(c, d)

  let min(x, y) = if (x < y) { x } else { y }
  let max(x, y) = if (x > y) { x } else { y }

  let boundrect(p1, p2) = rect((min(p1.at(0), p2.at(0)), min(p1.at(1), p2.at(1))), (max(p1.at(0), p2.at(0)), max(p1.at(1), p2.at(1))), stroke: (dash: "dashed", paint: luma(60%)))

  boundrect(a, b)
  boundrect(c, d)

  let left = max(min(a.at(0), b.at(0)), min(c.at(0), d.at(0)))
  let right = min(max(a.at(0), b.at(0)), max(c.at(0), d.at(0)))
  let top = min(max(a.at(1), b.at(01)), max(c.at(1), d.at(1)))
  let bottom = max(min(a.at(1), b.at(01)), min(c.at(1), d.at(1)))

  if (left < right and bottom < top) {
    hatching((left, bottom), (right - left, top - bottom), 0.2)
  }

  point(a)
  content((), [$a(x_1, y_1)$], anchor: "east", padding: 0.15)
  point(b)
  content((), [$b(x_2, y_2)$], anchor: "west", padding: 0.15)
  point(c)
  content((), [$c(x_3, y_3)$], anchor: "west", padding: 0.15)
  point(d)
  content((), [$d(x_4, y_4)$], anchor: "east", padding: 0.15)
})
],
[
#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1.5, 1)
  let b = (3, 3)
  let c = (4, 2)
  let d = (5, 0)
  line(a, b)
  line(c, d)

  let min(x, y) = if (x < y) { x } else { y }
  let max(x, y) = if (x > y) { x } else { y }

  let boundrect(p1, p2) = rect((min(p1.at(0), p2.at(0)), min(p1.at(1), p2.at(1))), (max(p1.at(0), p2.at(0)), max(p1.at(1), p2.at(1))), stroke: (dash: "dashed", paint: luma(60%)))

  boundrect(a, b)
  boundrect(c, d)

  let left = max(min(a.at(0), b.at(0)), min(c.at(0), d.at(0)))
  let right = min(max(a.at(0), b.at(0)), max(c.at(0), d.at(0)))
  let top = min(max(a.at(1), b.at(01)), max(c.at(1), d.at(1)))
  let bottom = max(min(a.at(1), b.at(01)), min(c.at(1), d.at(1)))

  if (left < right and bottom < top) {
    hatching((left, bottom), (right - left, top - bottom), 0.2)
  }

  point(a)
  content((), [$a(x_1, y_1)$], anchor: "east", padding: 0.15)
  point(b)
  content((), [$b(x_2, y_2)$], anchor: "west", padding: 0.15)
  point(c)
  content((), [$c(x_3, y_3)$], anchor: "south", padding: 0.15)
  point(d)
  content((), [$d(x_4, y_4)$], anchor: "north", padding: 0.15)
})
],)

Как видно, пересечение ограничивающих отрезки прямоугольников является _необходимым_ условием для пересечения отрезков, но не *достаточным* (см. второй пример), поэтому применяют другие алгоритмы

#v(10mm)

Из школьной геометрии знаем, что любая прямая делит плоскость на две полуплоскости

Если отрезки пересекаются, то точки $c$ и $d$ лежат в разных полуплоскостях относительно прямой $l$ (обратное при этом неверно)

Однако аналогично, если отрезки пересекаются, то точки $a$ и $b$ лежат в разных полуплоскостях относительно прямой $p$, образованной точками $c$ и $d$

Теперь нужен алгоритм, который проверяет, что точки одного отрезка лежат по разные стороны относительно прямой другого отрезка

#Mem Пусть $arrow(a), arrow(b)$ находятся на плоскости. Косое произведение $arrow(a) or arrow(b) #equaldef |arrow(a)| |arrow(b)| sin(hat(upright(arrow(a)\, arrow(b)))) = |arrow(a) times arrow(b)| = plus.minus lr(|mat(arrow(i), arrow(j), arrow(k); a_1, a_2, 0; b_1, b_2, 0; delim: "|")|, size: #115%) = plus.minus lr(|mat(a_1, a_2; b_1, b_2; delim: "|") arrow(k)|, size: #115%) = plus.minus lr(|mat(a_1, a_2; b_1, b_2; delim: "|")|, size: #115%) = mat(a_1, a_2; b_1, b_2; delim: "|")$ -- площадь параллелограмма

Косое произведение со знаком "плюс" равна площадь параллелограмма, образованными векторами, концы которых расположенные по часовой стрелке

#grid(columns: (1fr, 1fr), align: center,
[#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (3, 0.5)
  let b = (1, 2)

  point(a, name: "a")
  content((), [$arrow(a)$], anchor: "west", padding: 0.15)
  point(b, name: "b")
  content((), [$arrow(b)$], anchor: "east", padding: 0.15)
  point((0, 0), name: "O")
  content((), [$O$], anchor: "east", padding: 0.15)

  line((0, 0), "a", mark: (end: ">"))
  line((0, 0), "b", mark: (end: ">"))

  point(vecsum(a, b), name: "ab")
  content((), [$arrow(a) + arrow(b)$], anchor: "south", padding: 0.15)
  line("a", "ab", stroke: (paint: luma(60%), dash: "dashed"))
  line("b", "ab", stroke: (paint: luma(60%), dash: "dashed"))
  line("O", "ab", mark: (end: ">", scale: 1.3, fill: luma(60%), stroke: (dash: "solid")), stroke: (paint: luma(60%), dash: "dashed"))

  cetz.angle.angle(
      (0, 0), a, b,
      radius: 0.5,
      label: text(blue)[$hat(upright(arrow(a)\, arrow(b))) > 0$],
      label-radius: 1.1,
      mark: (end: ">", scale: 0.8)
  )
})],
[#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (3, 0.5)
  let b = (1, -2)

  point(a, name: "a")
  content((), [$arrow(a)$], anchor: "west", padding: 0.15)
  point(b, name: "b")
  content((), [$arrow(b)$], anchor: "east", padding: 0.15)
  point((0, 0), name: "O")
  content((), [$O$], anchor: "east", padding: 0.15)

  line((0, 0), "a", mark: (end: ">"))
  line((0, 0), "b", mark: (end: ">"))


  point(vecsum(a, b), name: "ab")
  content((), [$arrow(a) + arrow(b)$], anchor: "west", padding: 0.15)
  line("a", "ab", stroke: (paint: luma(60%), dash: "dashed"))
  line("b", "ab", stroke: (paint: luma(60%), dash: "dashed"))
  line("O", "ab", mark: (end: ">", scale: 1.3, fill: luma(60%), stroke: (dash: "solid")), stroke: (paint: luma(60%), dash: "dashed"))

  cetz.angle.angle(
      (0, 0), b, a,
      radius: 0.5,
      label: text(red)[$hat(upright(arrow(a)\, arrow(b))) < 0$],
      label-radius: 1.1,
      mark: (start: ">", scale: 0.8)
  )
})],
text(blue)[$arrow(a) or arrow(b) > 0$],
text(red)[$arrow(a) or arrow(b) < 0$]
)

#v(5mm)

Применим к задаче. Косое произведение показывает ориентацию, поэтому, если точки находятся по разные стороны от прямой, то косые произведения $arrow([a, b]) or arrow([a, c])$ и $arrow([a, b]) or arrow([a, d])$ должны иметь разные знаки


#grid(columns: (1fr, 1fr), align: center,
[#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round"),
    content: (padding: 1pt, font: 30pt)
  )

  let a = (1, 1)
  let b = (4, 4)
  let c = (5, 2)
  let d = (2, 3)

  point(a, name: "a")
  content((), [$a$], anchor: "east", padding: 0.15)
  point(b, name: "b")
  content((), [$b$], anchor: "west", padding: 0.15)
  point(c, name: "c")
  content((), [$c$], anchor: "west", padding: 0.15)
  point(d, name: "d")
  content((), [$d$], anchor: "east", padding: 0.15)

  line("b", "a")
  line("c", "d")

  line("a", "d", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))
  line("a", "c", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))

  content(("a", 50%, "d"), text(blue, 0.8em)[$arrow([a, b]) or arrow([a, d]) > 0$], angle: "d", anchor: "south", padding: 0.1)
  content(("a", 50%, "c"), text(red, 0.8em)[$arrow([a, b]) or arrow([a, c]) < 0$], angle: "c", anchor: "north", padding: 0.1)
})],
[#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1, 1)
  let b = (3, 3)
  let c = (5, 1.5)
  let d = (4, 3)

  point(a, name: "a")
  content((), [$a$], anchor: "east", padding: 0.15)
  point(b, name: "b")
  content((), [$b$], anchor: "west", padding: 0.15)
  point(c, name: "c")
  content((), [$c$], anchor: "west", padding: 0.15)
  point(d, name: "d")
  content((), [$d$], anchor: "south", padding: 0.15)

  line("b", "a")
  line("c", "d")

  line("a", "d", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))
  line("a", "c", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))

  content(("a", 50%, "d"), text(red, 0.8em)[$arrow([a, b]) or arrow([a, d]) < 0$], angle: "d", anchor: "north", padding: 0.1)
  content(("a", 50%, "c"), text(red, 0.8em)[$arrow([a, b]) or arrow([a, c]) < 0$], angle: "c", anchor: "north", padding: 0.1)
})],
)

Аналогично проверяем произведения $arrow([c, d]) or arrow([c, a])$ и $arrow([c, d]) or arrow([c, b])$

#grid(columns: (1fr, 1fr), align: center,
[#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1, 1)
  let b = (4, 4)
  let c = (5, 2)
  let d = (2, 3)

  point(a, name: "a")
  content((), [$a$], anchor: "east", padding: 0.15)
  point(b, name: "b")
  content((), [$b$], anchor: "west", padding: 0.15)
  point(c, name: "c")
  content((), [$c$], anchor: "west", padding: 0.15)
  point(d, name: "d")
  content((), [$d$], anchor: "east", padding: 0.15)

  line("b", "a")
  line("c", "d")

  line("a", "d", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))
  line("a", "c", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))

  content(("a", 50%, "d"), text(blue, 0.8em)[$arrow([a, b]) or arrow([a, d]) > 0$], angle: "d", anchor: "south", padding: 0.1)
  content(("a", 50%, "c"), text(red, 0.8em)[$arrow([a, b]) or arrow([a, c]) < 0$], angle: "c", anchor: "north", padding: 0.1)

  cetz.angle.angle(
      "a", "b", "d",
      radius: 1,
      label: "",
      mark: (end: ">", scale: 0.8)
  )
  cetz.angle.angle(
      "a", "c", "b",
      radius: 1.1,
      label: "",
      mark: (start: ">", scale: 0.8)
  )
})],
[#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1, 1)
  let b = (4, 4)
  let c = (5, 2)
  let d = (2, 3)

  point(a, name: "a")
  content((), [$a$], anchor: "east", padding: 0.15)
  point(b, name: "b")
  content((), [$b$], anchor: "west", padding: 0.15)
  point(c, name: "c")
  content((), [$c$], anchor: "west", padding: 0.15)
  point(d, name: "d")
  content((), [$d$], anchor: "east", padding: 0.15)

  line("b", "a")
  line("c", "d")

  line("c", "a", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))
  line("c", "b", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))

  content(("a", 50%, "c"), text(blue, 0.8em)[$arrow([c, d]) or arrow([c, a]) > 0$], angle: "c", anchor: "south", padding: 0.1)
  content(("c", 50%, "b"), text(red, 0.8em)[$arrow([c, d]) or arrow([c, b]) < 0$], angle: "c", anchor: "south", padding: 0.1)

  cetz.angle.angle(
      "c", "d", "a",
      radius: 0.7,
      label: "",
      mark: (end: ">", scale: 0.8)
  )
  cetz.angle.angle(
      "c", "b", "d",
      radius: 0.8,
      label: "",
      mark: (start: ">", scale: 0.8)
  )
})],
)


// картинка

#grid(columns: (1fr, auto),
[
Для непересекающихся отрезков одна пара произведений из двух будет иметь один знак

#Nota Если одна из точек одного отрезка находится на другом отрезке, то косое произведение равно 0
], 
[#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  let a = (1, 1)
  let b = (4, 4)
  let c = (3, 3)
  let d = (1, 4)

  point(a, name: "a")
  content((), [$a$], anchor: "east", padding: 0.15)
  point(b, name: "b")
  content((), [$b$], anchor: "west", padding: 0.15)
  line("b", "a")
  point(c, name: "c")
  content((), [$c$], anchor: "west", padding: 0.15)
  point(d, name: "d")
  content((), [$d$], anchor: "east", padding: 0.15)

  line("c", "d")
  

  line("a", "d", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))
  line("a", "c", mark: (end: ">", stroke: (thickness: 0pt), fill: luma(40%)), stroke: (dash: "dashed", paint: luma(40%)))

  content(("a", 50%, "d"), text(blue, 0.8em)[$arrow([a, b]) or arrow([a, d]) > 0$], angle: "d", anchor: "south", padding: 0.17)
  content(("a", 50%, "c"), text(black, 0.8em)[$arrow([a, b]) or arrow([a, c]) = 0$], angle: "c", anchor: "north", padding: 0.17)

  cetz.angle.angle(
      "a", "b", "d",
      radius: 1,
      label: "",
      mark: (end: ">", scale: 0.8)
  )
})]
)

Теперь найдем саму точку пересечения. Нам известны уравнения прямых:

#grid(columns: (1fr, 1fr), align: center, 
    $mat(delim: "|", x - x_1, y - y_1; x_2 - x_1, y_2 - y_1) = 0$,
    $mat(delim: "|", x - x_3, y - y_3; x_4 - x_3, y_4 - y_3) = 0$
)

Далее решаем систему уравнений:

#align(center)[
$cases(mat(delim: "|", x - x_1, y - y_1; x_2 - x_1, y_2 - y_1) = 0, mat(delim: "|", x - x_3, y - y_3; x_4 - x_3, y_4 - y_3) = 0)$
]

Получаем $cases(k_1 = (y_2 - y_1) / (x_2 - x_1), k_2 = (y_4 - y_3) / (x_4 - x_3), b_1 = y_1 - k_1 x_1, b_2 = y_3 - k_2 x_3, x = (b_2 - b_1) / (k_1 - k_2), y = k_1 x + b_1) arrow.l.r.double.long cases(x = ((y_3 - (y_4 - y_3) / (x_4 - x_3) x_3) - (y_1 - (y_2 - y_1) / (x_2 - x_1) x_1)) / ((y_2 - y_1) / (x_2 - x_1) - (y_4 - y_3) / (x_4 - x_3)), y = k_1 x + b_1)$

Результатом будет точка пересечения прямых. Так как прямые бесконечно длинные, то нужна дополнительная проверка, описанная выше, на то, что пересекаются действительно отрезки, а не только прямые

#v(10mm)

#Nota Если число отрезков велико, то проверка попарных пересечений очень затратна, асимптотическая сложность -- $O(n^2)$

Поэтому применяют алгоритм "заметающей" прямой:

#proof[

Сделаем допущение, что точки пересечения образуются пересечением только двух отрезков и нет вертикальных отрезков

Тогда:

1. Берем вертикальную прямую $l$, проходящую через точку $(0, x)$
2. Все отрезки заданы списком координат их концов. Тогда можем отсортировать этот список по возрастанию абсцисс точек

#align(center)[#cetz.canvas(length: 1cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 2),
    stroke: (thickness: 1pt, cap: "round")
  )

  line((0, -0.3), (0, 5), mark: (end: ">"))
  content((), [$x$], padding: 0.15, anchor: "east")
  line((-0.3, 0), (9, 0), mark: (end: ">"))
  content((), [$y$], padding: 0.15, anchor: "north")
  point((0, 0), name: "O")
  content((), [$O$], padding: 0.15, anchor: "north-east")

  let segments = (((1.5, 2), (3.5, 4)), ((2, 4), (4.5, 1)), ((4, 3), (6, 4)), ((6, 2), (8, 0.5)))

  for (i, (p1, p2)) in segments.enumerate() {
    line(p1, p2)
    point(p1)
    point(p2)
    content((p1, 80%, p2), [$S_(#(i + 1))$], angle: p2, anchor: "south", padding: 0.12)
  }

  let x = 0.3
  line((x, -0.3), (x, 4.7), stroke: (paint: blue, dash: "dashed", thickness: 2pt))
  content((), text(blue)[$l$], padding: 0.15, anchor: "west")
  point((x, 0), name: "X", fill: blue)
  content((), text(blue)[$x$], padding: 0.15, anchor: "north-west")


})]

3. Прямая $l$ движется направо и пересекает концы отрезков. Встречу прямой с концами отрезков обозначим событием. Все отрезки, отвечающие событию $x$ (точка с абсциссой $x$ принадлежит этим отрезкам), называется смежными по $x$

  Далее вводим отношение сравнения отрезков $S_i$ и $S_j$: $S_i >_x S_j$ ($S_i$ выше $S_j$) означает, что в точке $x$ ордината точки $S_i inter l$ больше ординаты $S_j inter l$

4. Если найдена смена отношения $>_x$ в разных событиях, то отрезки пересеклись

#grid(columns: (1fr, 1fr, 1fr), align: center, 
[#cetz.canvas(length: 0.57cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  line((0, -0.3), (0, 5), mark: (end: ">"))
  line((-0.3, 0), (9, 0), mark: (end: ">"))
  point((0, 0), name: "O")

  let segments = (((1.5, 2), (3.5, 4)), ((2, 4), (4.5, 1)), ((4, 3), (6, 4)), ((6, 2), (8, 0.5)))


  let x = segments.at(0).at(0).at(0)
  line((x, -0.3), (x, 4.7), stroke: (paint: blue, dash: "dashed", thickness: 2pt))
  content((), text(blue)[$l$], padding: 0.15, anchor: "east")
  point((x, 0), name: "X", fill: blue)
  content((), text(blue)[$x_1$], padding: 0.15, anchor: "north-west")

  for (i, (p1, p2)) in segments.enumerate() {
    line(p1, p2)
    point(p1)
    point(p2)
  }

  content((x, -1.8), [$S_1$])

})],
[#cetz.canvas(length: 0.57cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  line((0, -0.3), (0, 5), mark: (end: ">"))
  line((-0.3, 0), (9, 0), mark: (end: ">"))
  point((0, 0), name: "O")

  let segments = (((1.5, 2), (3.5, 4)), ((2, 4), (4.5, 1)), ((4, 3), (6, 4)), ((6, 2), (8, 0.5)))


  let x = segments.at(1).at(0).at(0)
  line((x, -0.3), (x, 4.7), stroke: (paint: blue, dash: "dashed", thickness: 2pt))
  content((), text(blue)[$l$], padding: 0.15, anchor: "east")
  point((x, 0), name: "X", fill: blue)
  content((), text(blue)[$x_2$], padding: 0.15, anchor: "north-west")

  for (i, (p1, p2)) in segments.enumerate() {
    line(p1, p2)
    point(p1)
    point(p2)
  }

  content((x, -1.8), [$S_1 <_(x_2) S_2$])

})],
[#cetz.canvas(length: 0.57cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  line((0, -0.3), (0, 5), mark: (end: ">"))
  line((-0.3, 0), (9, 0), mark: (end: ">"))
  point((0, 0), name: "O")

  let segments = (((1.5, 2), (3.5, 4)), ((2, 4), (4.5, 1)), ((4, 3), (6, 4)), ((6, 2), (8, 0.5)))


  let x = segments.at(0).at(1).at(0)
  line((x, -0.3), (x, 4.7), stroke: (paint: blue, dash: "dashed", thickness: 2pt))
  content((), text(blue)[$l$], padding: 0.15, anchor: "east")
  point((x, 0), name: "X", fill: blue)
  content((), text(blue)[$x_3$], padding: 0.15, anchor: "north-west")

  for (i, (p1, p2)) in segments.enumerate() {
    line(p1, p2)
    point(p1)
    point(p2)
  }

  content((x, -1.8), text(maroon)[$S_1 >_(x_3) S_2$])
})]
)


]

Сложность данного алгоритма составляет $O(n log n)$
