## Лекция 5. Реляционная алгебра

Уже на протяжении выполнения лабораторных работ можно было столкнуться с теоретико-множественными операциями из реляционный алгебры, 
например, `JOIN`. Причем, стоит заметить, что реляционная алгебра - замкнутая.

### Операции реляционной алгебры

Операции, которые ввел Кодд в реляционной алгебре, делятся на унарные и бинарные

1. Проекция: 
    <!-- \[\Pi_{a_1, \dots, a_n} (R)\] -->

    <img src="images/databases_2024_10_03_formula_1.png" height=50 alt="Нотация проекции">

    Результатом проекции является новое отношение, содержащее вертикальное подмножество исходного отношения, создаваемое посредством извлечения значений указанных атрибутов и исключения из результата строк-дубликатов

    В SQL проекция реализована через инструкцию `SELECT` и выбор определенных атрибутов

2. Выборка
    <!-- \[\sigma_{\text{предикат}} (R)\] -->

    <img src="images/databases_2024_10_03_formula_2.png" height=50 alt="Нотация выборки">
   
    Результатом выборки является новое отношение, которое содержит только те кортежи из исходного отношения, которые удовлетворяют заданному предикату
    
    В SQL выборка реализована через инструкцию ```WHERE Condition```

3. Объединение (Union)
    <!-- \[R \union S\] -->

    <img src="images/databases_2024_10_03_formula_3.png" height=50 alt="Нотация объединения">

    > Объединение двух наборов кортежей определяет новое отношение, которое включает все кортежи из исходных отношений с исключением кортежей-дубликатов

    Отношения совместимы, если они состоят из одинаковых атрибутов и каждая пара атрибутов имеет одинаковый домен

    В SQL возможно сделать объединение так:

    ```sql
    SELECT * FROM Table1
    UNION
    SELECT * FROM Table2;
    ```

    Синтаксически такие запросы в SQL разрешены, но семантически они не имеют смысла. Приведем пример объединения на таблицах `Item`:

    | ItemID | ItemName |
    |--------|----------|
    |   1    | Ball     |
    |   2    | Pen      |
    |   3    | Notebook |

    И `FavouriteItem`:

    | ItemID | ItemName |
    |--------|----------|
    | 2      | Pen      |
    | 3      | Notebook |
    | 4      | Laptop   |

    Их объединение

    ```sql
    SELECT * FROM Item
    UNION
    SELECT * FROM FavouriteItem;
    ```
   
    даст такое отношение:

    | ItemID | ItemName |
    |--------|----------|
    | 1      | Ball     |
    | 2      | Pen      |
    | 3      | Notebook |
    | 4      | Laptop   |

4. Разность
    <!-- \[R - S\] -->

    <img src="images/databases_2024_10_03_formula_4.png" height=50 alt="Нотация разности">

    > Разность отношений - новое отношение, которое включает кортежи из первого отношения и исключает кортежи, входящие во второе отношение

    Аналогично, отношения, к которым применяется разность, должны быть совместимы

    Разность отношений, приведенных выше:

    ```sql
    SELECT * FROM Item
    EXCEPT
    SELECT * FROM FavouriteItem;
    ```
   
    даст такое отношение:

    | ItemID | ItemName |
    |--------|----------|
    | 2      | Pen      |
    | 3      | Notebook |

5. Пересечение
    <!-- \[R \cap S\] -->

    <img src="images/databases_2024_10_03_formula_5.png" height=50 alt="Нотация пересечения">

    > Пересечение определяет новое отношение, которое включает кортежи, входящие в обои отношения одновременно

    Аналогично, отношения, к которым применяется пересечение, должны быть совместимы

    Пересечение отношений, приведенных выше:

    ```sql
    SELECT * FROM Item
    INTERSECT
    SELECT * FROM FavouriteItem;
    ```
   
    даст такое отношение:

    | ItemID | ItemName |
    |--------|----------|
    | 1      | Ball     |

    <hr>

    Дальше будут приводиться примеры операций на атрибуте `DepartmentID` (далее `DepartID`) на таблицах `Employee`[^jointablesschema]:

    [^jointablesschema]: Таблицы из примера были созданы так:

        ```sql
        CREATE TABLE Employee (
            EmployeeID BIGINT PRIMARY KEY,
            FullName TEXT,
            DepartmentID BIGINT
        );
        CREATE TABLE Department (
            DepartmentID BIGINT PRIMARY KEY,
            DepartmentName TEXT,
            DirectorID BIGINT
        );
        INSERT INTO Employee VALUES 
            (1, 'Albert Eistein', 4), 
            (2, 'Ernest Rutherford', 5), 
            (3, 'Marie Curie', 10), 
            (5, 'Charles Darwin', 13), 
            (4, 'Igor Kurchatov', NULL);
        INSERT INTO Department VALUES 
            (4, 'Theoretical Physics', 1), 
            (10, 'Chemistry', 3), 
            (13, 'Biology', 5),
            (11, 'Nuclear Physics', 2);
        ```
    
    | EmplID | FullName          | DepartID |
    |--------|-------------------|----------|
    | 1      | Albert Einstein   | 4        |
    | 2      | Ernest Rutherford | 4        |
    | 3      | Marie Curie       | 10       |
    | 4      | Igor Kurchatov    | NULL     |
    | 5      | Alexander Fleming | 13       |
    
    И `Department`:
    
    | DepartID | DepartName          | DirectorID |
    |----------|---------------------|------------|
    | 4        | Theoretical Physics | 1          |
    | 10       | Chemistry           | 3          |
    | 11       | Nuclear Physics     | 2          |
    | 13       | Biology             | 5          |

    <hr>

6. Декартовое произведение
    <!-- \[R \times S\] -->

    <img src="images/databases_2024_10_03_formula_6.png" height=50 alt="Нотация декартового произведения">

   > Результатом декартового произведения является новое отношение, в которой кортежи являются результатом конкатенации кортежей из первого отношения и кортежей из второго произведения
   
    В SQL декартовое произведение можно сделать так:

    ```sql
    SELECT * FROM Table1, Table2
    ```
   
    Либо так:

    ```sql
    SELECT * FROM Table1 CROSS JOIN Table2
    ```

    Семантически декартовое произведение зачастую не имеет смысла. На таблицах выше декартовым произведением будет такое отношение:

    | EmplID | FullName          | DepartID | DepartID | DepartName          | DirectorID |
    |--------|-------------------|----------|----------|---------------------|------------|
    | 1      | Albert Einstein   | 4        | 4        | Theoretical Physics | 1          |
    | 2      | Ernest Rutherford | 4        | 4        | Theoretical Physics | 1          |
    | 3      | Marie Curie       | 10       | 4        | Theoretical Physics | 1          |
    | 4      | Igor Kurchatov    | NULL     | 4        | Theoretical Physics | 1          |
    | 5      | Alexander Fleming | 13       | 4        | Theoretical Physics | 1          |
    | 1      | Albert Einstein   | 4        | 10       | Chemistry           | 3          | 
    | 2      | Ernest Rutherford | 4        | 10       | Chemistry           | 3          | 
    | 3      | Marie Curie       | 10       | 10       | Chemistry           | 3          | 
    | 4      | Igor Kurchatov    | NULL     | 10       | Chemistry           | 3          | 
    | 5      | Alexander Fleming | 13       | 10       | Chemistry           | 3          | 
    | 1      | Albert Einstein   | 4        | 11       | Nuclear Physics     | 2          | 
    | 2      | Ernest Rutherford | 4        | 11       | Nuclear Physics     | 2          | 
    | 3      | Marie Curie       | 10       | 11       | Nuclear Physics     | 2          | 
    | 4      | Igor Kurchatov    | NULL     | 11       | Nuclear Physics     | 2          | 
    | 5      | Alexander Fleming | 13       | 11       | Nuclear Physics     | 2          | 
    | 1      | Albert Einstein   | 4        | 13       | Biology             | 5          | 
    | 2      | Ernest Rutherford | 4        | 13       | Biology             | 5          | 
    | 3      | Marie Curie       | 10       | 13       | Biology             | 5          | 
    | 4      | Igor Kurchatov    | NULL     | 13       | Biology             | 5          | 
    | 5      | Alexander Fleming | 13       | 13       | Biology             | 5          | 

7. Тета-соединение
    <!-- \[R \bowtie_F S\] -->
    <!-- \[F = R_{a_i} \Theta S_{b_i} \quad\quad \Theta \in \{<, >, =, \neq, \dots\}\] -->

    <img src="images/databases_2024_10_03_formula_7.png" height=50 alt="Нотация тета-соединения">

    <img src="images/databases_2024_10_03_formula_8.png" height=50 alt="Предикат">

    > Результатом тета-соединения является декартовое соединение, кортежи которого удовлетворяют предикату `F`

    Тета-соединение осуществимо в SQL с помощью инструкции 

    ```sql
    FROM Table1 FULL JOIN Table2 ON Condition
    ```
   
8. Эквисоединение
    <!-- \[R \bowtie_= S\] -->

    <img src="images/databases_2024_10_03_formula_12.png" height=50 alt="Нотация эквисоединения">

    > Результатом эквисоединения является декартовое соединение, кортежи которого равны по какому-либо атрибуту

    Эквисоединение двух таблиц из примера будет таким результатом:

    | EmplID | FullName          | DepartID | DepartID | DepartName          | DirectorID |
    |--------|-------------------|----------|----------|---------------------|------------|
    | 1      | Albert Einstein   | 4        | 4        | Theoretical Physics | 1          |
    | 2      | Ernest Rutherford | 4        | 4        | Theoretical Physics | 1          | 
    | 3      | Marie Curie       | 10       | 10       | Chemistry           | 3          | 
    | 5      | Alexander Fleming | 13       | 13       | Biology             | 5          | 

    ```sql
    SELECT *
    FROM Employee 
    INNER JOIN Department 
    ON Employee.DepartmentID = Department.DepartmentID;
    ```

9. Естественное соединение (Natural Join)
    <!-- \[R \bowtie S\] -->

    <img src="images/databases_2024_10_03_formula_9.png" height=50 alt="Нотация естественного соединения">

    > Естественное соединение - эквисоединение двух отношений, выполненное по всем общим атрибутам, из результатов которого исключается по одному экземпляру общего атрибута
   
    Естественное соединение удобно, например, когда есть два таблицы с атрибутами серии и номера паспорта. В SQL естественное соединение напрямую не реализовано, но естественное соединение таблиц из примера выглядело бы так:

    | EmplID | FullName          | DepartName          | DirectorID |
    |--------|-------------------|---------------------|------------|
    | 1      | Albert Einstein   | Theoretical Physics | 1          |
    | 2      | Ernest Rutherford | Theoretical Physics | 1          | 
    | 3      | Marie Curie       | Chemistry           | 3          | 
    | 5      | Alexander Fleming | Biology             | 5          | 

10. Левое внешнее соединение
    <!-- \[R \supset\hspace{-0.4em}\lhd S\] -->

    <img src="images/databases_2024_10_03_formula_10.png" height=50 alt="Нотация левого внешнего соединения">

    > Соединение, результирующее отношение которое содержит в себе все кортежи из отношения R, с конкатенации к ним тех кортежей из отношения из S, имеющих совпадающие значения в общих атрибутах

    В SQL левое внешнее соединение на таблицах выше осуществляется так:

    ```sql
    SELECT *
    FROM Employee
    LEFT JOIN Department
    ON Employee.DepartmentID = Department.DepartmentID;
    ```

    | EmplID | FullName          | DepartID | DepartID | DepartName          | DirectorID |
    |--------|-------------------|----------|----------|---------------------|------------|
    | 1      | Albert Einstein   | 4        | 4        | Theoretical Physics | 1          |
    | 2      | Ernest Rutherford | 4        | 4        | Theoretical Physics | 1          | 
    | 3      | Marie Curie       | 10       | 10       | Chemistry           | 3          | 
    | 4      | Igor Kurchatov    | NULL     | NULL     | NULL                | NULL       | 
    | 5      | Alexander Fleming | 13       | 13       | Biology             | 5          | 

    Аналогично в SQL можно сделать правое внешнее соединение:

    ```sql
    SELECT *
    FROM Employee
    RIGHT JOIN Department
    ON Employee.DepartmentID = Department.DepartmentID;
    ```

    | EmplID | FullName          | DepartID | DepartID | DepartName          | DirectorID |
    |--------|-------------------|----------|----------|---------------------|------------|
    | 1      | Albert Einstein   | 4        | 4        | Theoretical Physics | 1          |
    | 2      | Ernest Rutherford | 4        | 4        | Theoretical Physics | 1          | 
    | 3      | Marie Curie       | 10       | 10       | Chemistry           | 3          | 
    | NULL   | NULL              | NULL     | 11       | Nuclear Physics     | 2          | 
    | 5      | Alexander Fleming | 13       | 13       | Biology             | 5          | 

11. Полусоединение
    <!-- \[R \rhd S\] -->

    <img src="images/databases_2024_10_03_formula_11.png" height=50 alt="Нотация полусоединения">

    > Полусоединение - отношение, состоящее из кортежей R, которые входят в экви-соединение R и S

    В SQL полусоединение не реализовано[^innerjoin]

[^innerjoin]: Несмотря на это, полусоединение можно реализовать в SQL при помощи `INNER JOIN`:

    ```sql
    SELECT *
    FROM Employee
    INNER JOIN Department
    ON Employee.DepartmentID = Department.DepartmentID;
    ```

    На отношениях из примера получится такое полусоединение:

    | EmplID | FullName          | DepartID | DepartID | DepartName          | DirectorID |
    |--------|-------------------|----------|----------|---------------------|------------|
    | 1      | Albert Einstein   | 4        | 4        | Theoretical Physics | 1          |
    | 2      | Ernest Rutherford | 4        | 4        | Theoretical Physics | 1          | 
    | 3      | Marie Curie       | 10       | 10       | Chemistry           | 3          | 
    | 5      | Alexander Fleming | 13       | 13       | Biology             | 5          |

### Синтаксис `SELECT`

Рассмотрим запрос выборки в SQL - его можно разделить на 5 частей:

1. **Выбор столбцов отношения**:

```sql
SELECT [ DISTINCT | ALL ] { * | [ColumnExpression [AS NewName] ] [, ...]}
```

Ключевое слово `DISTINCT` определяет выбор только уникальных кортежей, `ALL` - явный выбор кортежей с дубликатами

Далее указываются имена столбцов (также возможны их алиасы) или `*`, которая определяет вывод всех столбцов отношения 


2. **Выбор исходного отношения**:[^fromfootnote]

```sql
FROM TableName [AS NewTableName] 
[{INNER | LEFT OUTER | FULL} JOIN OuterTable [AS NewOuterTableName] 
ON Condition]
```

Здесь же можно определить соединение и его тип на основе условия `Condition` 

[^fromfootnote]: На самом деле синтаксис инструкции `FROM` немного шире:

    ```sql
    FROM TableName [AS NewTableName] 
    [{INNER | { LEFT | RIGHT | FULL } [OUTER]} JOIN OuterTable [AS NewOuterTableName] 
    ON Condition]
    ```

3. **Фильтрация кортежей**:

```sql
[WHERE Condition]
```

В инструкции `WHERE` определяются условия для фильтрации кортежей

4. **Группировка**:

```sql
[GROUP BY ColumnList [, ...] [HAVING Condition]]
```

В инструкции `GROUP BY` производится группировка по указанному набору атрибутов и фильтрации через условие в `HAVING`

5. **Сортировка**:

```sql
[ORDER BY ColumnList [, ...] [{ASC | DESC}]]
```

И, наконец, в инструкции `ORDER BY` происходит сортировка конечного отношения по указанному набору атрибутов

В конечном счете, получаем:

```sql
SELECT [ DISTINCT | ALL ] { * | [ColumnExpression [AS NewName] ] [, ...]}
FROM TableName [AS NewTableName] 
[{INNER | LEFT OUTER | FULL} JOIN OuterTable [AS NewOuterTableName] 
ON Condition]
[WHERE Condition]
[GROUP BY ColumnList [, ...] [HAVING Condition]]
[ORDER BY ColumnList [, ...] [{ASC | DESC}]]
```

Здесь стоит заметить, что желательно общие условия, которые имеют место в инструкции `WHERE` стоит размещать именно там, а не в `HAVING`, так как фильтрация кортежей после группировки работает медленнее и не обеспечивает производительность

Порядок выполнения инструкций в `SELECT` запросе таков:

1. `FROM`
2. `ON` 
3. `JOIN` 
4. `WHERE` 
5. `GROUP BY`
6. `HAVING` 
7. `SELECT` 
8. `DISTINCT` 
9. `ORDER BY`


Рассмотрим две реализации `JOIN`:

1. Наивная:

    ```
    for r in R:
        for s in S:
            if r.a_i Θ S.b_i:
                print(r + s)
    ```

2. Слиянием:

    ```
    R.sort(a)
    S.sort(b)
    
    while not endof(R) and not endof(S):
        if R.a_i < S.b_i:
            next(R)
        if R.a_i > S.b_i:
            next(S)
        if R.a_i == S.b_i:
            print(r + s)
            next(R)
    ```

Обе реализации имеют свои достоинства и недостатки. Но так как SQL хранит кортежи уже отсортированными (чтобы поддерживать быстроту индексации), вторая реализация зачастую работает лучше

<hr>

В конечном итоге, мы приходим к мысли, что, чтобы поддерживать целостность данных, приходится тратить много средств на сервера и жертвовать производительностью, и в бизнесе намного дешевле содержать ошибки из-за нарушения целостности, чем создавать идеальные системы 


