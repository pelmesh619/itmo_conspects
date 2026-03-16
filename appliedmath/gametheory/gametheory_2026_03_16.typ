#import "../../preamble.typ": *

#let subject-name = [Теория игр]
#let date-header = [16.03.2026]
#let lecturer-name = [Лекции Блаженова А. В.]

#show: basic-template
#show: doc => header-template(
  subject-name: subject-name,
  date-header: date-header,
  lecturer-name: lecturer-name,
  doc
)

== Лекция 4

=== Игры в нормальной форме

#Def Игра задана в нормальной форме, если известно:

1. $N = {1, 2, ..., n}$ -- множество игроков, участвующих в игре
2. ${X_1, X_2, ..., X_n}$, где $X_i$ -- множество стратегий $i$-ого игрока
3. ${H_1, H_2, ..., H_n}$, где $H_i$ -- функция выигрыша $i$-ого игрока, показывающая выигрыш в каждой возможной ситуации

#Nota При этом считаем, что игра бескоалиционная (то есть игроки не могут создавать союзы)

#Ex Матричная игра -- простейший пример игры в нормальной форме. В ней матрица $A = mat(a_(1 1), a_(1, 2), ..., a_(1 m); a_(2 1), a_(2, 2), ..., a_(2 m); dots.v, dots.v, dots.down, dots.v; a_(n 1), a_(n 2), ..., a_(n m); )$, игроки -- $N = {1, 2}$, стратегии -- $X_1 = {1, 2, ..., n}$, $X_2 = {1, 2, ..., m}$, а выигрыши $H_1(i, j) = a_(i j)$, $H_2(i, j) = -a_(i j)$

В ряде случаев нормальная форма не удобна

=== Позиционные игры

Под позиционными играми подразумевается конечная игра двух или более лиц, которые делают ходы (из определенного конечного множества) в определенной очередности

Позиционная игра обычно задается в виде дерева, где вершина $i$ соответствует ходу $i$-ого игрока, а исходящие из нее вершины возможным ходам в данный момент $i$-ого игрока. Путь от начальной вершины до конечной называется ситуацией игры, так как он соответствует выбранным стратегиям каждого игрока

В конечных вершинах дерева игры указывается результат игры, то есть выигрыши каждого игрока

#Nota Если в игре участвует случай (например, перетасованная колода карт или брошенный кубик), то вводим игрока с номером 0, а дугам, исходящих из его вершины приписываем вероятности случая 

#Def Если каждый игрок в каждый момент знает ходы, сделанные до него (включая ходы случай), то говорят, что игра с совершенной информацией. В противном случае говорят, что игра с несовершенной информацией

#Nota Если игра представлена в виде дерева, то говорят, что она в развернутой форме

#theorem[
    #Th Любая позиционная игра может быть записана в нормальной форме
]

#Ex Первый игрок зажимает монету в кулаке, а второй угадывает, в каком кулаке монета. Рассмотрим две ситуации:

1. Второй игрок не знает, где зажата монета
2. Второй игрок знает, где зажата

#grid(columns: (1fr, 1fr), align: center, 
[
#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  let (l1, l2) = (1, 0.5)

  circle((0, 0), radius: 0.3, name: "a1")
  content((), [$1$])

  circle((-l1, -1.2), radius: 0.3, name: "b1")
  content((), [$2$])

  circle((l1, -1.2), radius: 0.3, name: "b2")
  content((), [$2$])

  content((-l1 - l2, -2.5), text(1.5em, red)[$-1$], name: "c1")
  content((-l1 + l2, -2.5), text(1.5em, blue)[$1$], name: "c2")
  content((l1 - l2, -2.5), text(1.5em, blue)[$1$], name: "c3")
  content((l1 + l2, -2.5), text(1.5em, red)[$-1$], name: "c4")


  line("a1", "b1")
  line("a1", "b2")
  content(("a1", 50%, "b1"), [Л], anchor: "east", padding: 0.12)
  content(("a1", 50%, "b2"), [П], anchor: "west", padding: 0.12)
  line("b1", "c1")
  line("b1", "c2")
  content(("b1", 50%, "c1"), [Л], anchor: "east", padding: 0.12)
  content(("b1", 50%, "c2"), [П], anchor: "west", padding: 0.12)
  line("b2", "c3")
  line("b2", "c4")
  content(("b2", 50%, "c3"), [Л], anchor: "east", padding: 0.12)
  content(("b2", 50%, "c4"), [П], anchor: "west", padding: 0.12)

  merge-path(stroke: (dash: "dashed"), {
    line((-l1, -0.8), (l1, -0.8))
    arc((l1, -0.8), radius: 0.4, start: 90deg, stop: -90deg)
    line((l1, -1.6), (-l1, -1.6))
    arc((-l1, -1.6), radius: 0.4, start: 270deg, stop: 90deg)
  })
})
], [
#cetz.canvas(length: 1.5cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )
  let (l1, l2) = (1, 0.5)

  circle((0, 0), radius: 0.3, name: "a1")
  content((), [$1$])

  circle((-l1, -1.2), radius: 0.3, name: "b1")
  content((), [$2$])

  circle((l1, -1.2), radius: 0.3, name: "b2")
  content((), [$2$])

  content((-l1 - l2, -2.5), text(1.5em, red)[$-1$], name: "c1")
  content((-l1 + l2, -2.5), text(1.5em, blue)[$1$], name: "c2")
  content((l1 - l2, -2.5), text(1.5em, blue)[$1$], name: "c3")
  content((l1 + l2, -2.5), text(1.5em, red)[$-1$], name: "c4")


  line("a1", "b1")
  line("a1", "b2")
  content(("a1", 50%, "b1"), [Л], anchor: "east", padding: 0.12)
  content(("a1", 50%, "b2"), [П], anchor: "west", padding: 0.12)
  line("b1", "c1", stroke: (paint: red, thickness: 3pt, cap: "butt"))
  line("b1", "c2")
  content(("b1", 50%, "c1"), [Л], anchor: "east", padding: 0.12)
  content(("b1", 50%, "c2"), [П], anchor: "west", padding: 0.12)
  line("b2", "c3")
  line("b2", "c4", stroke: (paint: red, thickness: 3pt, cap: "butt"))
  content(("b2", 50%, "c3"), [Л], anchor: "east", padding: 0.12)
  content(("b2", 50%, "c4"), [П], anchor: "west", padding: 0.12)
})
])

Данная игра является антагонистическая. В первой ситуации ходы второго игрока ... и образуют информационное множество. В этом случае игра эквивалентна орлянке, поэтому ее можно представить матрицей $A = mat(-1, 1; 1, -1)$

Во второй ситуации игроки обладают совершенной информацией. Стратегия второго игрока -- вектор $(x, y)$, где $x$ -- выбранный ход, если он окажется в вершине 2.1, и $y$ -- ход, если он окажется в вершине 2.2

$ #grid(
  columns: (auto, auto), 
  rows: (auto, auto), 
  gutter: 8pt,
  align: horizon,
  [], [$mat("ЛЛ", "ЛП", "ПЛ", "ПП", delim: #none, gap: #(1.2em))$], 
  [$vec("Л", "П", delim: #none, align: #start)$], [$mat(-1, -1, 1, 1; 1, -1, 1, -1; column-gap: #(1.5em))$]
) $

Здесь видна доминирующая стратегия -- второй столбец, поэтому второй игрок всегда будет выигрывать, его стратегия $Q^* = (0, 1, 0, 0)$, а цена игры -- $nu = -1$

#theorem[
    #Th Антагонистическая позиционная игра сводится к матричной игре. Если игра с совершенной информацией, то соответствующая матричная игра имеет седловую точку, то есть игра имеет решение в чистых стратегиях или разрешима по доминированию
]

В общем случае для игры с $n > 2$ и ненулевой суммой аналогично

#theorem[
    #ThN("Куна") Позиционная игра с совершенной информацией разрешима по доминированию при выполнении следующего условия: если две ситуации игры равноценны для одного из игроков, то они должны быть равноценны для остальных игроков
]

Решение игры находится по алгоритму Куна (или метод обратной индукции)

Анализ производится с конца дерева: каждый игрок вычеркивает доминируемые стратегии. В результате остается путь, соответствующий решению игры

Например, шашки, шахматы, крестики-нолики или игра с правом на вето

#Ex Трое игроков выбирают одного из четырех кандидатов следующим образом:

1. Сначала первый игрок накладывает вето на одного из кандидатов
2. Потом второй накладывает на одного из оставшихся
3. Затем третий на одного из двух оставшихся

Оставшийся кандидат объявляется выбранный. Функции выигрыша зависят от выбранного кандидата: $H_1 = (5, 4, 3, 7)$, $H_2 = (6, 7, 5, 4)$, $H_3 = (3, 8, 5, 4)$

#let win_scores = (
    (5, 4, 3, 7),
    (6, 7, 5, 4),
    (3, 8, 5, 4)
)
#let candidate_colors = (red, blue, green, purple)

#align(center)[
#cetz.canvas(length: 1.3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  circle((0, 0), radius: 0.3, name: "a1")
  content((), [$1$])

  let level_margins = (3.4, 1.1, 0.55, 0.1)

  let draw_tree(point, point_name, level, edges) = {
    for (i, ed) in edges.enumerate() {
        let dx = i * level_margins.at(level) - (edges.len() - 1) * level_margins.at(level) / 2
        let new_point = (point.at(0) + dx, point.at(1) - 1.8)
        let new_point_name = point_name + "_" + str(i)
        if (level == 2) {
            content(new_point, text(1em, candidate_colors.at(ed - 1))[№#ed], name: new_point_name)
        } else {
            circle(new_point, radius: 0.2, name: new_point_name)
            content((), [#(level + 2)])
        }
        line(point_name, new_point_name)

        let edge_text = text(1em, candidate_colors.at(ed - 1))[#ed]
        if (level == 2) {
            content((point_name, 50%, new_point_name), edge_text, anchor: if (i != 0) { "west" } else { "east" }, padding: 0.08)
        } else if (level == 0) {
            content((point_name, 70%, new_point_name), edge_text, anchor: if (i > 1) { "south-west" } else { "south-east" }, padding: 0.17)
        } else {
            content((point_name, 50%, new_point_name), edge_text, anchor: "west", padding: 0.08)
        }

        let new_edges = edges.filter(it => it != ed)

        if (new_edges.len() == 1) {
            continue
        }

        draw_tree(new_point, new_point_name, level + 1, new_edges)

    }
  }

  draw_tree((0, 0), "a1", 0, (1, 2, 3, 4))
})]

Так как игра с совершенной информацией, применим алгоритм Куна:

1. Третий игрок сделает такой выбор:

#align(center)[
#cetz.canvas(length: 1.3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  let level_margins = (0.55, )

  let draw_tree(point, point_name, level, edges) = {
    for (i, ed) in edges.enumerate() {
        let other_ed = edges.at(calc.rem((i + 1), edges.len()))

        let dx = i * level_margins.at(level) - (edges.len() - 1) * level_margins.at(level) / 2
        let new_point = (point.at(0) + dx, point.at(1) - 1.7)
        let new_point_name = point_name + "_" + str(i)
        if (level == 0) {
            content(new_point, text(1em, candidate_colors.at(other_ed - 1))[№#other_ed], name: new_point_name)
        }

        let edge_text = text(1em, candidate_colors.at(ed - 1))[#ed]
        if (win_scores.at(2).at(ed - 1) > win_scores.at(2).at(other_ed - 1)) {
            edge_text = strike(edge_text)
            line(point_name, new_point_name, stroke: (dash: "dashed", paint: luma(60%)))
        } else {
            line(point_name, new_point_name, stroke: (thickness: 1.6pt))
        }
        content((point_name, 50%, new_point_name), edge_text, anchor: if (i != 0) { "west" } else { "east" }, padding: 0.08)
    }
  }

  let counter = 0
  for i in range(1, 5) {
    for j in range(i + 1, 5) {
        circle((counter * 1.5, 0), radius: 0.2, name: str(counter) + "_1")
        content((), [$3$])
        draw_tree((counter * 1.5, 0), str(counter) + "_1", 0, (i, j))
        counter += 1
    }
  }
})]

2. Второй и первый игроки наложат вето аналогично на тех, кто дадут наименьший выигрыш (но при этом с учетом того, что скорее всего выберут игроки после них)



#align(center)[
#cetz.canvas(length: 1.3cm, {
  import cetz.draw: *

  set-style(
    mark: (fill: black, scale: 1.5),
    stroke: (thickness: 1pt, cap: "round")
  )

  circle((0, 0), radius: 0.3, name: "a1")
  content((), [$1$])

  let level_margins = (3.4, 1.1, 0.55, 0.1)
  let bad_edges = (
    (1, 2, 3),
    (0, 1),
  )

  let draw_tree(point, point_name, level, edges) = {
    for (i, ed) in edges.enumerate() {
        let dx = i * level_margins.at(level) - (edges.len() - 1) * level_margins.at(level) / 2
        let new_point = (point.at(0) + dx, point.at(1) - 1.8)
        let new_point_name = point_name + "_" + str(i)
        if (level == 2) {
            let new_ed = edges.at(calc.rem((i + 1), edges.len()))
            content(new_point, text(1em, candidate_colors.at(new_ed - 1))[№#new_ed], name: new_point_name)
        } else {
            circle(new_point, radius: 0.2, name: new_point_name)
            content((), [#(level + 2)])
        }

        let new_edges = edges.filter(it => it != ed)

        if (new_edges.len() == 1) {
            continue
        }

        draw_tree(new_point, new_point_name, level + 1, new_edges)
    }

    for (i, ed) in edges.enumerate() {
        let other_ed = edges.at(calc.rem((i + 1), edges.len()))
        let new_point_name = point_name + "_" + str(i)
        let edge_text = text(1em, candidate_colors.at(ed - 1))[#ed]
        if (level == 2) {
            if (win_scores.at(2).at(ed - 1) > win_scores.at(2).at(other_ed - 1)) {
                edge_text = strike(edge_text)
                line(point_name, new_point_name, stroke: (dash: "dashed", paint: luma(60%)))
            } else {
                line(point_name, new_point_name, stroke: (thickness: 1.6pt))
            }
            content((point_name, 50%, new_point_name), edge_text, anchor: if (i != 0) { "west" } else { "east" }, padding: 0.08)
        } else {
            if (bad_edges.at(level).contains(i)) {
                line(point_name, new_point_name, stroke: (dash: "dashed", paint: luma(60%)))
                edge_text = strike(edge_text)
            } else {
                line(point_name, new_point_name, stroke: (thickness: 1.6pt))
            }

            if (level == 0) {
                content((point_name, 70%, new_point_name), edge_text, anchor: if (i > 1) { "south-west" } else { "south-east" }, padding: 0.17)
            } else {
                content((point_name, 50%, new_point_name), edge_text, anchor: "west", padding: 0.08)
            }
        }
        
    }

  }

  draw_tree((0, 0), "a1", 0, (1, 2, 3, 4))
  line("a1", "a1_0", stroke: (thickness: 3pt, cap: "butt", paint: red))
  line("a1_0", "a1_0_2", stroke: (thickness: 3pt, cap: "butt", paint: red))
  line("a1_0_2", "a1_0_2_1", stroke: (thickness: 3pt, cap: "butt", paint: red))
})]

Получаем, что:

1. Для первого игрока выгодно наложить вето на первого кандидата
2. Для второго игрока лучше всего отклонить четвертого кандидата
3. Третий игрок наложит вето на третьего кандидата

Выделенный путь соответствует решению игры, в результате будет выбран второй кандидат, выигрыши игроков составят $H_1(2) = 4, H_2(2) = 7, H_3(2) = 8$

#Nota В данных условиях ситуации для всех игроков неравноценны, поэтому условие теоремы Куна выполнено

Поменяем условия следующим образом: $H'_1 = (5, 4, #strong("4"), 7)$, $H'_2 = (6, 7, 5, 4)$, $H'_3 = (3, 8, 5, 4)$

Тогда по алгоритму Куна первый игрок может наложить вето на второго кандидата, и в результате будет выбран третий кандидат, выигрыши игроков составят $H_1(2) = 4, H_2(2) = 5, H_3(2) = 5$

Выигрыш первого игрока не меняется, но выигрыши второго и третьего уменьшились. Эти две ситуации игры равноценны для первого игрока, но не равноценны для оставшихся -- условие теоремы Куна не выполнено
