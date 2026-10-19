## Лекция 4. Типы и классы типов

### Создание новых типов

В языке Haskell можно создавать свои типы с помощью слова `data`. Например, с помощью `data` можно объявить перечисление значений:

```hs
data Color = Red | Green | Blue | White | Black
```

Далее с помощью сопоставления с образцом можно использовать логику для разных значений:

```hs
whatIsTheColor :: Color -> String
whatIsTheColor Red = "Color is Red"
whatIsTheColor Green = "Color is Green"
whatIsTheColor Blue = "Color is Blue"
whatIsTheColor White = "Color is White"
whatIsTheColor Black = "Color is Black"
whatIsTheColor _ = "😼" -- такое сопоставление избыточно, так как
                        -- перечислены все возможные значения Color
```

Если нет общего сопоставления с `_` и какое-либо значение не указано, то при вызове такой функции выбросится исключение: `"*** Exception: 1.hs:(4,1)-(7,39): Non-exhaustive patterns in function whatIsTheColor`

Также с помощью слова `data` можно объявлять структуру - набор других типов, например, точку с двумя координатами:

```hs
data Point2D = CreatePoint Double Double
--   ^         ^                ^   ^
--   имя типа  имя              |   |
--             конструктора   типы полей
```

Здесь конструктор - это функция с сигнатурой `CreatePoint :: Double -> Double -> Point2D`

Далее написать функции, которые работают с ним, например, возвращение координаты `x` или `y`:

```hs
getX :: Point2D -> Double
getX (CreatePoint x _) = x

getY :: Point2D -> Double
getY (CreatePoint _ y) = y
```

Вместо числа с плавающей точкой `Double` может быть другой тип, тогда объявление будет выглядеть так:

```hs
data Point2D a = Point2D a a
-- здесь для удобства конструктор назван так же, как и тип
```

Здесь `a` может представлять любой тип, но так как не у любого типа есть нужные арифметические операторы, использующие их функции не будут принимать `Point2D a`. Поэтому, например, в определении функции расстояния между точками необходимо уточнять тип:

```hs
distance :: Point2D Double -> Point2D Double -> Double
distance (Point2D x1 y1) (Point2D x2 y2) =
    sqrt $ (x2 - x1) ^ 2 + (y2 - y1) ^ 2
```

---

Такие структуры можно объединять в перечисления:

```hs
data Point a = Point2D a a | Point3D a a a
```

Значение такого перечисления хранит в памяти значение лишь одного типа - либо `Point2D`, либо `Point3D` (аналог `union` в C++ или `enum` в Rust). Для работы с ним в функции можно воспользоваться сопоставление с образцом:

```hs
toList :: Point a -> [a]
toList (Point2D x y) = [x, y]
toList (Point3D x y z) = [x, y, z]
```

Для такого общего типа точки `Point` можно написать такую функцию расстояния:

```hs
distance :: Point Double -> Point Double -> Double
distance p1 p2 = sqrt . sum . map (^2) $ zipWith (-) (toList p2) (toList p1)
```

В этом примере такая функция отлично работает с `Point2D` и `Point3D`:

```hs
ghci> distance (Point2D 0 0) (Point2D 4 3) 
5.0
ghci> distance (Point3D 0 0 0) (Point3D 4 3 8)
9.433981132056603
```

Однако при вычислении расстояния между двухмерной и трехмерной точками получается число (потому что функция `zipWith` умеет работать со списками разной длины), хотя результат подобной операции в математике не определен:

```hs
ghci> distance (Point2D 0 0) (Point3D 4 3 8)  
5.0
```

Как правило, это говорит о плохом проектировании типов, но в этом случае можно применить сопоставление с образцом, чтобы предотвратить такое:

```hs
distance :: Point Double -> Point Double -> Double

distance p1@(Point2D _ _) p2@(Point2D _ _) =
    sqrt . sum . map (^2) $ zipWith (-) (toList p2) (toList p1)
distance p1@(Point3D _ _ _) p2@(Point3D _ _ _) =
    sqrt . sum . map (^2) $ zipWith (-) (toList p2) (toList p1)
distance _ _ = error("Результат не определен")
```

---

В Haskell конструкторы также могут иметь именованные аргументы, например:

```hs
data Student = Student
    { studentId   :: Int
    , studentName :: String
    , studentYear :: Int
    }
```

Далее к полям объекта такого типа можно обращаться по имени:

```hs
ghci> studentName (Student 1 "John Doe" 4)
"John Doe"
```

Компилятор Haskell сам генерирует функции с такими же именами, как имена полей, которые возвращают значение поля объекта

С помощью такого конструктора можно копировать объект с обновлением только одного (или нескольких) поля:

```hs
moveNextYear :: Student -> Student
moveNextYear s = s { studentYear = studentYear s + 1 }
```

Или осуществлять сопоставление с образцом по одному или нескольким полям:

```hs
isFirstYear :: Student -> Bool
isFirstYear Student { studentYear = 1 } = True
isFirstYear _ = False
```

### `Maybe` и `Either`

Также Haskell имеет встроенные перечисления:

* `Maybe a` используется для типов, которые могут не иметь значения (аналог `Option<T>` в Rust или `std::optional<T>` в C++):

    ```hs
    data Maybe a = Nothing | Just a
    ```

    `Maybe` может использоваться как результат поиска значения в структуре:

    ```hs
    ghci> lookup 2 [(1, "One"), (2, "Two")]
    Just "Two"
    ghci> lookup 0 [(1, "One"), (2, "Two")]
    Nothing
    ```

* `Either a b` используется для значений, которые могут иметь один из двух типов (аналог `Result<T, E>` в Rust или `std::variant<L, R>` в C++):

    ```hs
    data Either a b = Left a | Right b
    ```

    Обычно `Either a b` используется для ошибок, где `Left a` - это ошибка, а `Right b` - успешный результат, например:

    ```hs
    data MonthError = MonthTooSmall | MonthTooBig

    month :: Int -> Either MonthError Int
    month n
        | n < 1     = Left MonthTooSmall
        | n > 12    = Left MonthTooBig
        | otherwise = Right n
    ```

    Далее функция `month` вернет ошибку, если номер месяца не лежит в диапазоне `[1, 12]`:
    
    ```hs
    ghci> month 0
    Left MonthTooSmall

    ghci> month 13
    Left MonthTooBig

    ghci> month 8
    Right 8
    ```

### Псевдонимы и обертки

Также Haskell имеет еще два слова для работы с типами:

* `type` позволяет создать псевдоним для существующего типа (аналог `using` в C++ и `type` в Rust), например:

    ```hs
    type Phone = String
    type Name = String
    type Password = String
    type Mass = Double
    type Id = Integer

    register :: Phone -> Name -> Password -> String
    register phone name pass = "Registered with phone [" ++ phone ++ "], name [" ++ name ++ "], pass [" ++ pass ++ "]"
    ```

    Такой псевдоним является только семантической подсказкой для программиста, какое значение ожидает функция. Для компилятора такие типы равнозначны, поэтому нет проверки типов и можно вместо объекта типа `Phone` положить в функцию `String`

* `newtype` позволяет создать обертку над существующим типом, например:

    ```hs
    newtype Phone = Phone String
    newtype Name = Name String
    newtype Password = Password String
    newtype Mass = Mass Double
    newtype Id = Id Integer

    register :: Phone -> Name -> Password -> String
    register (Phone ph) (Name n) (Password ps) = "Registered with phone [" ++ ph ++ "], name [" ++ n ++ "], pass [" ++ ps ++ "]"
    ```

    `newtype` создает тип с только одним конструктором, который принимает только один аргумент

    В отличие от `type` для компилятора типы `Phone` и `String` разные, поэтому проверка типов объектов происходит (то есть перепутать `Name` и `Password` нельзя), однако в отличие от `data` на этапе выполнения типы `Phone` и `String` равнозначны, поэтому производительность не ухудшается

### Классы типов

Помимо этого Haskell имеет механизм классов типов. Класс типов задает интерфейс (то есть набор сигнатур функций), чтобы затем представитель класса, конкретный тип, реализовывал этот интерфейс (наподобие трейтов в Rust)

Например, при сравнении новосозданных типов в Haskell выведется ошибка:

```hs
ghci> Red == Red
<interactive>:2:5: error: [GHC-39999]
    * No instance for `Eq Color' arising from a use of `=='
```

Здесь интерпретатор говорит, что при использовании `(==)` не был найден представитель `Eq Color`. С помощью `:i` можно спросить интерпретатор, что такое `Eq`:

```hs
ghci> :i Eq
type Eq :: * -> Constraint
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
  {-# MINIMAL (==) | (/=) #-}
        -- Defined in `GHC.Classes'
instance Eq Bool -- Defined in `GHC.Classes'
instance Eq Char -- Defined in `GHC.Classes'
-- ...
```

Здесь `Eq` - это класс типов, который объявляет функции `(==)` и `(/=)`. Далее идут типы, которые реализуют `Eq`

Разберем несколько базовых классов типов:

* `Eq` задает операторы `(==)` и `(/=)` (то есть проверка на равенство/неравенство)

    При этом, так как `(==)` и `(/=)` операции противоположные, то компилятор способен вывести одно из другого, поэтому можно написать реализацию только для одного (что указано в `{-# MINIMAL (==) | (/=) #-}` в информации о классе типов)

    Для типа `Color` реализация выглядит так:

    ```hs
    instance Eq Color where
        Red   == Red   = True
        Green == Green = True
        Blue  == Blue  = True
        White == White = True
        Black == Black = True
        _     == _     = False
    ```

    Для типа `Point2D` реализация выглядит так:

    ```hs
    instance (Eq a) => Eq (Point2D a) where
        (Point2D x1 y1) == (Point2D x2 y2) = x1 == x2 && y1 == y2
    ```

    Если подразумевается, что сравнение на равенство объектов типа состоит из сравнения всех его полей (которые реализуют `Eq`), то можно воспользоваться словом `deriving`:

    ```hs
    data Color = Red | Green | Blue | White | Black
        deriving (Eq)
    -- или так
    data Color = Red | Green | Blue | White | Black
    deriving instance Eq Color


    data Point2D a = Point2D a a
        deriving (Eq)
    -- или так
    data Point2D a = Point2D a a
    deriving instance Eq a => Eq (Point2D a)
    ```

    В таком подходе компилятор сам напишет реализацию операторов

* Класс `Show` отвечает за отображение типа в выводе

    Без `Show` при попытке вывести объект в консоли с помощью функции `print` выведется ошибка

    ```hs
    ghci> print Black
    <interactive>:8:1: error: [GHC-39999]
        * No instance for `Show Color' arising from a use of `print'
    ```

    Чтобы такого не было, надо реализовать метод `show`, например:

    ```hs
    instance Show Color where
        show Red = "Red"
        show Green = "Green"
        show Blue = "Blue"
        show White = "White"
        show Black = "Black"
    ```

    Здесь также можно предложить компилятору самим сгенерировать реализацию с помощью слова `deriving`:

    ```hs
    data Color = Red | Green | Blue | White | Black
        deriving (Eq, Show)

    data Point2D = CreatePoint Double Double
        deriving (Eq, Show)
    ```

    В результате чего для перечислений `show` будет возвращать само имя значения, а для структур строку вызова конструктора, например, для `Point2D`:

    ```hs
    ghci> CreatePoint 4 7
    CreatePoint 4.0 7.0
    ```

* Класс `Ord` отвечает за порядок значений типа

    Класс `Ord` определяет функции `(<)`, `(<=)`, `(>)`, `(>=)`, `compare`, `min` и `max`. Здесь примечательна функция `compare x y`, которая возвращает объект перечисления `Ordering`, который задает, как два числа относятся друг к другу: 
        
    * `EQ`, если `x` и `y` равны
    * `LT`, если `x` не больше `y` (`<=` вместо `<`, чтобы `compare` можно было вывести из оператора `(<=)`)
    * и `GT` в других случаях

    Класс `Ord` наследуется от класса `Eq`, поэтому `Ord` требует реализации либо оператора `(<=)`, либо функции `compare` - остальные функции компилятор сможет вывести

    Для структур генерация реализации с помощью `deriving` приводит к тому, что сравнение происходит в лексикографическом порядке (то есть сравниваются элементы с первого по последний до тех пор, пока они не равны)

Свой класс типов может определить с помощью слова `class`, например:

```hs
class HasArea a where
    area :: a -> Double
```

Далее можно определять реализацию этого класса у типов:

```hs
data Shape = Circle Double | Rectangle Double Double
    deriving (Eq, Show)

instance HasArea Shape where
    area (Circle r) = pi * r ^ 2
    area (Rectangle w h) = w * h
```

И функцию, которая требует, чтобы тип принадлежал классу:

```hs
printArea :: HasArea a => a -> String
printArea x = "Calculated area = " ++ (show $ area x)
```

Классы типов могут наследовать сигнатуры у других классов типов, тем самым образуя иерархию:

![Иерархия классов типов](./images/funcprog-holopov_typeclasses_hierarchy.png)

А сами типы могут реализовывать несколько классов типов:

![Принадлежность типов к классам типов](./images/funcprog-holopov_types_in_typeclasses.png)
