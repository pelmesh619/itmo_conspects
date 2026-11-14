## Лекция 6. Аппликативный функтор и монада

### Аппликативный функтор

Функтор - это конструктор, который помогает функциям работать с составными типами

Аппликативный функтор - функтор, который умеет извлекать функцию из составного типа `f` и применять ее к значению внутри типа `f`, чтобы получить результат, обернутый в тип `f`

В Haskell аппликативный функтор выражается классом типов `Applicative`:

```hs
ghci> :i Applicative
type Applicative :: (* -> *) -> Constraint
class Functor f => Applicative f where
  pure :: a -> f a
  (<*>) :: f (a -> b) -> f a -> f b
  liftA2 :: (a -> b -> c) -> f a -> f b -> f c
  (*>) :: f a -> f b -> f b
  (<*) :: f a -> f b -> f a
  {-# MINIMAL pure, ((<*>) | liftA2) #-}
        -- Defined in `GHC.Internal.Base'
-- ...
```

Для создания представителя нужно определить две функции - `pure` и оператор `<*>` (либо `pure` и `liftA2`)

Функция `pure` оборачивает значение типа `a` в составной тип `f a` (например, для `f = Maybe` функция `pure a` возвращает `Just a`). Оператор `<*>` же переводит тип `f (a -> b)`, содержащий функцию `a -> b`, в функцию `f a -> f b`

Для типа `Maybe a` аппликативный функтор выглядит так:

```hs
instance Applicative Maybe where
  pure :: a -> Maybe a
  pure x = Just x

  (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
  Nothing <*> _  = Nothing -- здесь функция обернута в Nothing, то есть не дана как аргумент
  Just f  <*> x  = fmap f x -- здесь функция обернута в Just
```

Таким образом, можно использовать функции внутри составных типов:

```hs
ghci> Just (+1) <*> Just 2
Just 3
ghci> (+) <$> Just 1 <*> Just 2 -- альтернативная запись
Just 3
ghci> Just (+1) <*> Nothing
Nothing
ghci> Nothing <*> Just 2   
Nothing
```

Рассмотрим определения аппликативного функтора для других типов:

*   Для списков аппликативный функтор определен так:

    ```hs
    instance Applicative [] where
      pure :: a -> [] a
      pure x = [x]

      (<*>) :: [a -> b] -> [a] -> [b]
      fs <*> xs = [f x | f <- fs, x <- xs]
    ```

    Здесь оператор `<*>` определен как декартово произведение применения функции из первого списка к значению из второго, например:

    ```hs
    ghci> (+) <$> [1, 2] <*> [10, 20]
    [11,21,12,22]
    ```

*   Для `Either` аппликативный функтор определен так:

    ```hs
    instance Applicative (Either e) where -- здесь делаем тип `e` одним для всех функций
      pure :: a -> Either e a
      pure x = Right x

      (<*>) :: Either e (a -> b) -> Either e a -> Either e b
      Left err <*> _ = Left err -- если пришла ошибка, то передаем ее дальше
      Right f  <*> Left err = Left err
      Right f  <*> Right val = Right $ f val

      -- или аналогично через fmap
      Right f  <*> x = fmap f x
    ```

    Такое определение позволяет строить конвейеры проверок, например:

    ```hs
    ghci> (+) <$> Left "a" <*> Left "b"
    Left "a"
    ghci> (+) <$> Right 1 <*> Left "b"
    Left "b"
    ghci> (+) <$> Right 1 <*> Right 2
    Right 3
    ```

*   Для кортежей из двух элементов аппликативный функтор определен так:

    ```hs
    instance Monoid e => Applicative ((,) e) where  
      pure :: a -> (e, a)
      pure x = (mempty, x) -- здесь нужно заполнить первый элемент типа `e`,
                           -- поэтому требуем, чтобы `e` был моноидом,
                           -- и используем нейтральное значение

      (<*>) :: (e, a -> b) -> (e, a) -> (e, b)
      (u, f) <*> (v, x) = (u <> v, f x)
      -- здесь мы используем оператор `<>`, определенный для полугруппы,
      -- чтобы объединить значения типа `e`,
      -- а затем применяем функцию из первого кортежа к значению из второго
    ```

    Пример использования:

    ```hs
    ghci> pure 5 :: (String, Int)
    ("",5) -- для строки mempty - это ""
    ghci> ("Hello,", (+1)) <*> (" world", 2) 
    ("Hello, world",3)
    ```

*   Для функций одного аргумента вида `e -> a`

    ```hs
    instance Applicative ((->) e) where
      pure :: a -> (e -> a)
      pure x = \_ -> x -- здесь возвращаем анонимную функцию, которая возвращает a

      (<*>) :: (e -> (a -> b)) -> (e -> a) -> (e -> b)
      f <*> g = \x -> f x $ g x
    ```

    Пример использования:

    ```hs
    ghci> ((++) <*> reverse) "abc"      
    "abccba"
    ```

*   Для функций двух аргументов вида `e1 -> e2 -> a`. Чтобы зафиксировать типы аргументов, воспользуемся оберткой в виде нового типа `Arrow2`:

    ```hs
    newtype Arrow2 e1 e2 a = Arrow2 { getArrow2 :: e1 -> e2 -> a }

    instance Functor (Arrow2 e1 e2) where  
      fmap :: (a -> b) -> Arrow2 e1 e2 a -> Arrow2 e1 e2 b
      fmap f (Arrow2 arrow) = Arrow2 $ \x1 x2 -> f (arrow x1 x2)

    instance Applicative (Arrow2 e1 e2) where
      pure :: a -> Arrow2 e1 e2 a
      pure x = Arrow2 $ \_ _ -> x

      (Arrow2 arrow2_1) <*> (Arrow2 arrow2_2) = Arrow2 $ \x1 x2 ->
        (arrow2_1 x1 x2) (arrow2_2 x1 x2)
    ```

    Пример:

    ```hs
    ghci> getArrow2 (Arrow2 (,)) 10 20
    (10,20)
    ```

    Здесь используется конструктор кортежа из двух элементов

`Functor` позволяет применить функцию только одного аргумента к значению в контейнере, тогда как `Applicative` позволяет применить функцию к нескольким обернутым аргументам сразу и выстраивать цепочку вида `f <$> a <*> b <*> c`, например, для того, чтобы собрать результат из нескольких независимых проверок:

```hs
data User = User String Int
  deriving Show

validateName :: String -> Maybe String
validateName name
  | null name = Nothing
  | otherwise = Just name

validateAge :: Int -> Maybe Int
validateAge age
  | age >= 0 && age < 150 = Just age
  | otherwise             = Nothing

mkUser :: String -> Int -> Maybe User
mkUser name age = User <$> validateName name <*> validateAge age
```

Функция `mkUser` возвращает `Nothing`, если у пользователя нет имени либо возраст не находится в допустимом диапазоне, иначе `Just (User ...)`

Для аппликативного функтора справедливы свойства:

* Тождественность: `pure id <*> x = x`
* Гомоморфизм: `pure g <*> pure x = pure (g x)`
* Перестановка аргументов: `funcs <*> pure x = pure ($ x) <*> funcs`, где `funcs` - это контейнер функций
* Композиция функций: `pure (.) <*> u <*> v <*> cont = u <*> (v <*> cont)`, где `cont` - это контейнер значений, а `u` и `v` - контейнеры функций

### Монада

Мона́да (или мона́д, Monad) - это аппликативный функтор с операцией `>>=`, которая позволяет выбирать следующий шаг по результату предыдущего

В Haskell монада представлена в виде класса типов `Monad`:

```hs
ghci> :i Monad
type Monad :: (* -> *) -> Constraint
class Applicative m => Monad m where
  (>>=) :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b
  return :: a -> m a
  {-# MINIMAL (>>=) #-}
        -- Defined in `GHC.Internal.Base'
-- ...
```

Здесь функция `return` по умолчанию является оберткой над `pure` из `Applicative` - так случилось, потому что иерархически в старых версиях Haskell классы `Applicative` и `Monad` не были связаны

Другая функция - оператор связывания `>>=` (bind operator) - берет упакованное значение (например, `Maybe a`), достает из него значение и передает их в функцию, которая возвращает новый упакованный результат. Оператор `>>=` является левоассоциативным и имеет приоритет 1

Тип функции `(a -> m b)` в объявлении `>>=` связан с тем, что помимо обычной функции вида `a -> b`, которая создается с помощью функциональной стрелки, выделяют стрелку Клейсли - функцию `a -> m b`, которая помимо обработки аргумента возвращает результат, обернутый в монаду, которая несет дополнительный эффект

Любую стандартную чистую функцию `a -> b` можно превратить в стрелку Клейсли, если обернуть её результат в монаду с помощью функции `return`:

```hs
toKleisli :: Monad m => (a -> b) -> (a -> m b)
toKleisli f = \x -> return (f x)
```

Оператор `>>=` как раз принимает упакованное в монаду значение и стрелку Клейсли, чтобы затем вернуть упакованный результат

Другой оператор упрощенного связывания `>>` (или последовательный оператор, then operator) работает немного по-другому - вместо стрелки Клейсли принимает упакованный результат, чтобы вернуть его `m b` либо первый аргумент `m a` на основе эффекта, который содержит `m a`:

```hs
(>>) :: m a -> m b -> m b
x >> y = x >>= \_ -> y
```

Здесь вместо тривиального `x >> y = y` определение `x >> y = x >>= \_ -> y` будет корректным, так как учитывает `x` при возврате, таким образом, например, возвращая ошибку `Left err`, вместо результата `Right result`

Рассмотрим обертку `Identity`, для которой определим аппликативный функтор и монаду:

```hs
newtype Identity a = Identity { runIdentity :: a }
  deriving (Eq, Show)

instance Functor Identity where
  fmap f m = Identity { runIdentity = (f (runIdentity m)) }

instance Applicative Identity where
  pure x = Identity { runIdentity = x }
  (Identity f) <*> (Identity x) = Identity $ f x

instance Monad Identity where
  (>>=) :: Identity a -> (a -> Identity b) -> Identity b
  (Identity x) >>= k = k x
  -- или аналогично
  m >>= k = k (runIdentity m)
```

Возьмем стрелку Клейсли, которая берет целое число, прибавляет один и запаковывает в `Identity`:

```hs
plusOneM :: Integer -> Identity Integer
plusOneM x = Identity (x + 1)
```

Пример использования:

```hs
ghci> plusOneM 5
Identity {runIdentity = 6}
ghci> runIdentity (plusOneM 5)
6
ghci> runIdentity $ plusOneM 5 >>= plusOneM >>= plusOneM >>= plusOneM
9
```

`Monad` расширяет возможности `Applicative` в том, что можно задать порядок, если следующий шаг обработки зависит от результата предыдущего, что делает оператор `>>=`

Для `Monad` справедливы следующие свойства:

* Существование левой единицы: `return x >>= k = k x`, где `k` - это стрелка Клейсли, а `x` - аргумент с подходящим типом для нее
* Существование правой единицы: `m >>= return = m`, где `m` - это какое-либо монадическое значение
* Ассоциативность: `(m >>= k1) >>= k2 = m >>= (\x -> k1 x >>= k2)`
