#import "@preview/suiji:0.5.1"
#import "@preview/cetz:0.4.2"
#import "../../preamble.typ": *
#import cetz.vector as cvector

// ============================================================
//  ДИАГРАММА ВОРОНОГО (алгоритм пересечения полуплоскостей)
// ============================================================


// Евклидово расстояние
#let dist(p, q) = {
  cvector.dist(p, q)
}

// Серединный перпендикуляр к отрезку AB, возвращает (a,b,c) где нормаль направлена в сторону A
#let perp_bisector(A, B) = {
  let (x1,y1)=A
  let (x2,y2)=B
  let mx = (x1 + x2)/2
  let my = (y1 + y2)/2
  let dx = x2 - x1
  let dy = y2 - y1
  // Вектор (dx,dy) перпендикулярен прямой, значит нормаль (dx,dy)
  // Уравнение: dx*(x - mx) + dy*(y - my) = 0  => dx*x + dy*y - (dx*mx+dy*my)=0
  let a = dx
  let b = dy
  let c = -(a*mx + b*my)
  // Если точка A даёт отрицательное значение, инвертируем знак, чтобы A была в положительной полуплоскости
  if a*x1 + b*y1 + c < 0 { ( -a, -b, -c ) } else { (a, b, c) }
}

// Пересечение двух прямых (a1,b1,c1) и (a2,b2,c2)
// Возвращает (x,y) или none, если параллельны
#let intersect_lines(l1, l2) = {
  let (a1,b1,c1)=l1; let (a2,b2,c2)=l2
  let det = a1*b2 - a2*b1
  if calc.abs(det) < 1e-9 { none }
  else {
    let x = (b1*c2 - b2*c1)/det
    let y = (c1*a2 - c2*a1)/det
    (x, y)
  }
}

// Проверка, что точка лежит в полуплоскости (>=0) относительно прямой (a,b,c)
#let is_halfplane(p, l) = {
  let (x,y)=p; let (a,b,c)=l
  a*x + b*y + c >= -1e-9
}

// ---------- 2. Отсечение выпуклого многоугольника полуплоскостью (Sutherland–Hodgman) ----------
// polygon: список вершин (замкнутый, но последняя не дублируется)
// returns новый многоугольник (замкнутый, без дублирования последней)
#let clip_polygon(poly, line) = {
  if poly.len() == 0 { return () }
  let output = ()
  let n = poly.len()
  for i in range(n) {
    let curr = poly.at(i)
    let prev = poly.at(calc.rem((i - 1 + n), n))
    let curr_inside = is_halfplane(curr, line)
    let prev_inside = is_halfplane(prev, line)
    // Вычисляем пересечение ребра prev->curr с прямой
    let (a,b,c) = line
    let (x1,y1)=prev
    let (x2,y2)=curr
    let t = (a*x1+b*y1+c) / (a*(x1 - x2)+b*(y1 - y2) + 1e-9)
    let intersect = (x1 + t*(x2 - x1), y1 + t*(y2 - y1))
    if prev_inside and curr_inside {
      output.push(curr)
    } else if prev_inside and not curr_inside {
      output.push(intersect)
    } else if not prev_inside and curr_inside {
      output.push(intersect)
      output.push(curr)
    }
  }
  // Удаляем почти совпадающие подряд идущие вершины
  let cleaned = ()
  for i in range(output.len()) {
    let p = output.at(i)
    let next = output.at(calc.rem((i+1), output.len()))
    if dist(p, next) > 1e-6 {
      cleaned.push(p)
    }
  }
  cleaned
}

// ---------- 3. Построение ячейки Вороного для одной точки ----------
// points: все точки-генераторы (список (x,y))
// idx: индекс текущей точки
// bounds: ограничивающий прямоугольник [(xmin,ymin), (xmax,ymax)]
// возвращает многоугольник (список вершин, замкнутый, без дублирования последней)
#let voronoi_cell(points, idx, bounds) = {
  let cell = bounds  // начинаем с прямоугольника
  let p0 = points.at(idx)
  for j in range(points.len()) {
    if j == idx { continue }
    let pj = points.at(j)
    let line = perp_bisector(p0, pj)  // полуплоскость, содержащая p0
    cell = clip_polygon(cell, line)
    if cell.len() < 3 { return () } // ячейка пуста или вырождена
  }
  cell
}

#let bounds(points, margin: 1) = {
  let xs = points.map(p => p.at(0))
  let ys = points.map(p => p.at(1))
  let minx = calc.min(..xs) - margin
  let maxx = calc.max(..xs) + margin
  let miny = calc.min(..ys) - margin
  let maxy = calc.max(..ys) + margin

  return ((minx, miny), (maxx, miny), (maxx, maxy), (minx, maxy))
}


#let voronoi_diagram(points, margin: 1.0) = {
  if points.len() < 2 { return ((), (), ()) }

  let bounds = bounds(points, margin: margin)

  let cells = ()
  for i in range(points.len()) {
    cells.push(voronoi_cell(points, i, bounds))
  }

  // Используем изменяемые массивы через контейнеры (array)
  let vertex_map = ()   // список точек-вершин
  let vertices = ()     // те же точки, но по сути это и есть vertex_map
  let edges = ()
  let point_to_edges = points.map(it => ())

  // Вспомогательная функция: получить индекс вершины (добавляет, если новая)
  let add_vertex(p, vertices, vertex_map) = {
    for (k, v) in vertices.enumerate() {
      if dist(p, v) < 1e-6 { return (k, vertices, vertex_map) }
    }
    let id = vertices.len()
    vertices.push(p)
    vertex_map.push(p)  // просто дублируем для удобства
    return (id, vertices, vertex_map)
  }

  for i in range(cells.len()) {
    let cell = cells.at(i)
    if cell.len() < 3 { continue }
    let n = cell.len()
    for j in range(n) {
      let p1 = cell.at(j)
      let p2 = cell.at(calc.rem((j+1), n))
      let id1 = 0
      let id2 = 0
      (id1, vertices, vertex_map) = add_vertex(p1, vertices, vertex_map)
      (id2, vertices, vertex_map) = add_vertex(p2, vertices, vertex_map)
      // проверка существования ребра
      let exists = edges.any(((a,b)) => (a==id1 and b==id2) or (a==id2 and b==id1))
      if not exists {
        let edge_id = edges.len()
        edges.push((id1, id2))
        point_to_edges.at(i).push(edge_id)
      } else {
        let edge_id = edges.position(((a,b)) => (a==id1 and b==id2) or (a==id2 and b==id1))
        point_to_edges.at(i).push(edge_id)
      }
    }
  }

  (vertices, edges, point_to_edges)
}


#let delaunay_edges_from_voronoi(points) = {
  let (vertices, edges, point_to_edges) = voronoi_diagram(points, margin: 100)
  let n = points.len()
  let edge_to_generators = ("banana": "banana")
  
  // Для каждого ребра Вороного найдём, каким генераторам оно принадлежит
  for edge_id in range(edges.len()) {
    let gens = ()
    for i in range(n) {
      if point_to_edges.at(i).contains(edge_id) {
        gens.push(i)
      }
    }
    if gens.len() == 2 {  // внутреннее ребро – даёт ребро триангуляции
      let (a,b) = (gens.at(0), gens.at(1))
      let key = if a < b { (a,b) } else { (b,a) }
      edge_to_generators.insert(str(key.at(0)) + ";" + str(key.at(1)), true)
    }
  }
  
  edge_to_generators.remove("banana")

  return edge_to_generators.keys()
}

// ---------- 2. Построение треугольников из рёбер ----------
#let triangles_from_edges(points, edges) = {
  let n = points.len()
  let adj = range(n).map(it => ())  // список смежности
  for s in edges {
    let (a, b) = s.split(";").map(it => int(it))
    adj.at(a).push(b)
    adj.at(b).push(a)
  }
  
  // Для каждой точки сортируем соседей по углу
  for i in range(n) {
    let neighbors = adj.at(i)
    if neighbors.len() < 2 { continue }
    // Сортировка по полярному углу относительно точки i
    let (xi, yi) = points.at(i)
    let sorted = neighbors.sorted(key: (it) => {
      let (xj, yj) = points.at(it)
      let ang1 = calc.atan2(yj - yi, xj - xi)
      return ang1
    })
    adj.at(i) = sorted
  }
  
  // Находим все треугольники (каждый будет найден 3 раза)
  let tri_set = ("banana": "banana")
  for i in range(n) {
    let neigh = adj.at(i)
    let m = neigh.len()
    for idx in range(m) {
      let j = neigh.at(idx)
      let k = neigh.at(calc.rem((idx+1), m))
      // Проверяем, существует ли ребро j-k
      if adj.at(j).contains(k) {
        let tri = (i, j, k)
        let key = tri.sorted()
        tri_set.insert(key.map(str).join(";"), tri)
      }
    }
  }
  
  tri_set.remove("banana")
  
  // Возвращаем список треугольников
  return tri_set.values()
}

// ---------- 3. Главная функция: триангуляция Делоне ----------
// Возвращает: (triangles, point_to_triangles)
#let delaunay_triangulation(points) = {
  let edges = delaunay_edges_from_voronoi(points)
  let triangles = triangles_from_edges(points, edges)
  
  // Маппинг точка -> треугольники
  let point_to_triangles = range(points.len()).map(it => ())
  for (tri_idx, (i1,i2,i3)) in triangles.enumerate() {
    point_to_triangles.at(i1).push(tri_idx)
    point_to_triangles.at(i2).push(tri_idx)
    point_to_triangles.at(i3).push(tri_idx)
  }
  
  (triangles, point_to_triangles)
}

#let caeser-voronoi-image-builder() = {
    let left_points = (
    (1.6, 7.4),
    (2.0, 4.5),
    (1.0, 2.0),
    )

    let right_points = (
    (7.0, 8.0),
    (6.5, 5.0),
    (6.8, 2.5),
    (8, 5.0),
    )

    let all_points = left_points + right_points

    // Общая граница для отображения
    let bounds = bounds(all_points, margin: 2.0)

    // Строим диаграммы Вороного отдельно для левых и правых точек
    let (verts_left, edges_left, _) = voronoi_diagram(left_points, margin: 2.0)
    let (verts_right, edges_right, _) = voronoi_diagram(right_points, margin: 2.0)

    // Для разделяющей ломаной: вычислим серединные перпендикуляры между
    // некоторыми парами (l, r) в порядке сверху вниз.
    // Пары подобраны вручную для наглядности.
    let pairs = (
    (left_points.at(0), right_points.at(0)),
    (left_points.at(0), right_points.at(1)),
    (left_points.at(1), right_points.at(1)),
    (left_points.at(1), right_points.at(2)),
    (left_points.at(2), right_points.at(2)),
    )

    // Построим точки пересечения этих перпендикуляров друг с другом,
    // чтобы получить непрерывную ломаную (упрощённо).
    let polyline = ()
    for i in range(pairs.len() - 1) {
    let (l1, r1) = pairs.at(i)
    let (l2, r2) = pairs.at(i+1)
    let line1 = perp_bisector(l1, r1)
    let line2 = perp_bisector(l2, r2)
    let inter = intersect_lines(line1, line2)
    if inter != none {
        polyline.push(inter)
    }
    }
    // Добавим начальную и конечную точки на границах (для красоты)
    // Начало — выше самой верхней точки, конец — ниже самой нижней.
    let (xmin, ymin) = bounds.at(0)
    let (xmax, ymax) = bounds.at(2)
    let top_y = ymax + 1
    let bottom_y = ymin - 1
    let first_line = perp_bisector(pairs.at(0).at(0), pairs.at(0).at(1))
    let last_line = perp_bisector(pairs.at(pairs.len()-1).at(0), pairs.at(pairs.len()-1).at(1))
    // Найдём пересечения с горизонтальными линиями y = top_y и y = bottom_y
    let top_point = intersect_lines(first_line, (0, 1, -top_y))
    let bottom_point = intersect_lines(last_line, (0, 1, -bottom_y))
    let full_polyline = polyline
    if top_point != none { full_polyline.insert(0, top_point) }
    if bottom_point != none { full_polyline.push(bottom_point) }

    // Отрисовка

    let draw(length: 1cm, flags: ()) = {
    cetz.canvas(length: length, {
        import cetz.draw: *

        for (i1, i2) in edges_left {
            let p1 = verts_left.at(i1)
            let p2 = verts_left.at(i2)
            line(p1, p2, stroke: blue)
        }

        for (i1, i2) in edges_right {
            let p1 = verts_right.at(i1)
            let p2 = verts_right.at(i2)
            line(p1, p2, stroke: green)
        }

        if "full" in flags and flags.full {
            for i in range(all_points.len()) {
                let cell = voronoi_cell(all_points, i, bounds)

                for (j, k) in cell.windows(2) {
                    if j.at(1) == k.at(1) and j.at(1) in (ymin, ymax) or j.at(0) == k.at(0) and j.at(0) in (xmin, xmax) {
                        continue
                    }
                    line(j, k)
                }
                let (j, k) = (cell.at(0), cell.at(-1))
                if not (j.at(1) == k.at(1) and j.at(1) in (ymin, ymax) or  j.at(0) == k.at(0) and j.at(0) in (xmin, xmax)) {
                    line(j, k)
                }
            }
        }

        // 3. Разделяющая ломаная (красная, толстая)
        for (i, (p1, p2)) in full_polyline.slice(0, count: if "count" in flags { flags.count } else { full_polyline.len() } ).windows(2).enumerate() {
            if "nopolyline" not in flags {
                line(p1, p2, stroke: red + 1.2pt)
            }
            if "perp" in flags {
                line(..pairs.at(i), stroke: dashed_gray)
                cetz.angle.right-angle(
                    (pairs.at(i).at(0), 50%, pairs.at(i).at(1)),
                    pairs.at(i).at(0), p1,
                    label: none,
                    radius: 0.15
                )
            }
        }

        for p in left_points {
            point(p, fill: blue)
        }
        for p in right_points {
            point(p, fill: green)
        }
    })

    }

    return draw
}


#let parabola_x(focus, sweep, y) = {
  let (fx, fy) = focus
  let L = sweep
  // x = (L^2 - fx^2 - (y - fy)^2) / (2*(L - fx))
  let numerator = L*L - fx*fx - (y - fy)*(y - fy)
  let denominator = 2*(L - fx)
  if denominator == 0 { return none }  // вырожденный случай
  numerator / denominator
}

#let parabola_points(focus, sweep, ymin, ymax, steps: 50) = {
  let points = ()
  let (xmin, xmax) = (-1, 12)
  for i in range(0, steps + 1) {
    let y = ymin + (ymax - ymin) * i / steps
    let x = parabola_x(focus, sweep, y)
    if x == none {
        points.push((xmin + (focus.at(0) - xmin) * i / steps, focus.at(1)))
    } else if x >= xmin and x <= xmax {
      points.push((x, y))
    }
  }
  points
}

#let fortune_algorithm_builder() = {
    let rng1 = suiji.gen-rng-f(30)
    let rng2 = suiji.gen-rng-f(25)

    let n = 6
    let points = suiji.uniform-f(rng1, low: 0, high: 6, size: n).at(1).zip(suiji.uniform-f(rng2, low: 0, high: 4, size: n).at(1))

    let circle_event_data(p1, p2, p3) = {
    let (x1, y1) = p1
    let (x2, y2) = p2
    let (x3, y3) = p3
    let d = 2 * (x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2))
    if calc.abs(d) < 1e-9 { return none }  // точки коллинеарны
    let ux = ((x1*x1 + y1*y1)*(y2 - y3) + (x2*x2 + y2*y2)*(y3 - y1) + (x3*x3 + y3*y3)*(y1 - y2)) / d
    let uy = ((x1*x1 + y1*y1)*(x3 - x2) + (x2*x2 + y2*y2)*(x1 - x3) + (x3*x3 + y3*y3)*(x2 - x1)) / d
    let radius = calc.sqrt((x1 - ux)*(x1 - ux) + (y1 - uy)*(y1 - uy))
    let event_x = ux + radius   // самая правая точка окружности
    (center: (ux, uy), radius: radius, event_x: event_x, points: (p1, p2, p3))
    }

    // Создание массива событий (site + circle)
    let create_fortune_events(points, sweep_direction: "vertical") = {
    let events = ()
    // Site events: каждая точка
    for i in range(points.len()) {
        let p = points.at(i)
        events.push((type: "site", x: p.at(0), y: p.at(1), point: p, index: i))
    }
    // Circle events: для всех троек (упрощённо, в реальном алгоритме только последовательные на береговой линии)
    points = points.sorted(key: it => it.at(0))

    for i in range(points.len() - 2) {
        for j in range(i+1, points.len() - 1) {
        for k in range(j+1, points.len()) {
            let data = circle_event_data(points.at(i), points.at(j), points.at(k))
        let inner_points = points.filter(it => cetz.vector.len(cetz.vector.sub(it, data.center)) - data.radius < 1e-6)
            if data != none and inner_points.len() == 3 {
                let event_x = data.event_x
                // Для горизонтальной sweep line использовалась бы event_y = uy - radius
                events.push((type: "circle", x: event_x, data: data))
            }
        }
        }
    }
    // Сортировка по x
    events.sorted(key: it => it.x)
    }

    let events = create_fortune_events(points)

    let centers_for_points = ("banana": none)
    for i in events {
        if i.type == "site" {
            continue
        }
        for j in i.data.points {
            let strj = str(j.at(0)) + ";" + str(j.at(1))
            if strj not in centers_for_points {
                centers_for_points.insert(strj, ())
            }
            if i.data.center not in centers_for_points.at(strj) {
                centers_for_points.insert(strj, centers_for_points.at(strj) + (i.data.center, ))
            }
        }
    }
    centers_for_points.remove("banana")

    for i in centers_for_points.keys() {
        let j = i.split(";").map(it => float(it))
        centers_for_points.insert(i, centers_for_points.at(i).sorted(key: it => vec_angle(it, j, (1, 0))))
    }

    let draw_func(length: 0.8cm, i, additional_draw: () => {}) = {
        let i = events.at(i)
        cetz.canvas(length: length, {
            import cetz.draw: *

            let sweep_x = i.x
            let ymin = 0.0
            let ymax = 6.0

            line((sweep_x, ymin - 0.5), (sweep_x, ymax+0.5), stroke: (dash: "dashed", paint: green, thickness: 1.2pt))

            let active = points.sorted(key: it => it.at(0)).filter(p => p.at(0) <= sweep_x)

            let shore_line = ("banana": "")
            for p in active.slice(calc.max(0, active.len() - 3)) {
                let pts = parabola_points(p, sweep_x, ymin, ymax, steps: 80)
                if pts.len() > 1 {
                    for j in pts {
                        if shore_line.at(str(j.at(1)), default: -calc.inf) < j.at(0) {
                            shore_line.insert(str(j.at(1)), j.at(0))
                        }
                    }
                    for j in pts.windows(2) {
                        line(..j, stroke: aqua + 0.4pt)
                    }
                }
            }
            let t = shore_line.remove("banana")

            for (y1, y2) in shore_line.keys().sorted().windows(2) {
                if float(y2) - float(y1) < 1e-1 {
                    line((shore_line.at(y1), float(y1)), (shore_line.at(y2), float(y2)), stroke: blue + 0.8pt)
                }
            }

            for (i, p) in points.enumerate() {
                point(p, fill: red)
                content(p, text(0.7em)[$M_#(i + 1)$], padding: 0.24, anchor: "south")
            }
            if i.type == "circle" {
                cetz.draw.circle(i.data.center, radius: i.data.radius, stroke: (paint: luma(30%), dash: "dashed"))
                let inner_points = points.filter(it => calc.abs(cetz.vector.len(cetz.vector.sub(it, i.data.center)) - i.data.radius) < 1e-6)
                for j in inner_points {
                    point(j, fill: blue)
                }
            }

            for j in centers_for_points.values() {
                for k in j.windows(2) {
                    let pos1 = events.position(it => it.type == "circle" and it.data.center.at(0) == k.at(0).at(0))
                    let pos2 = events.position(it => it.type == "circle" and it.data.center.at(0) == k.at(1).at(0))
                    if events.at(pos1).x <= sweep_x and events.at(pos2).x <= sweep_x {
                        line(..k)
                    }
                }
            }
        
            for j in events {
                if j.type == "circle" and j.data.center.at(0) + j.data.radius <= sweep_x {
                    point(j.data.center, radius: 0.15)
                }
            }

            additional_draw()
        })
    }

    return draw_func
}
