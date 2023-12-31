import Data.Function (on)

-- Module 2. Basics
-- 2.2 Параметрический полиморфизм (2)

-- 1) Оператор композиции функций
-- Задача 1
-- 2) Полиморфизм кортежей и списков
-- Задача 2
-- 3) Каррирование
-- Задача 3
-- Задача 4
-- Задача 5


-- 1) Оператор композиции функций

{-
    Есть 2 полиморфные функции f и g
    Нам хочется описать композиции этих функций,
    то есть такую функцию, которая принимает функции f и g,
    а возвращает функцию, которая выполняет следующие действия:
    она берет некоторый аргумент, применяет функцию g к этому
    аргументу, а потом к результату этого применения применяет функцию f

    f:: b -> c

    g :: a -> b

    x :: a

    f (g x) :: c -- но нам хочется получить функцию из a в c, которая принимает а, а возвращает с

    -- если мы абстрагируемся по иксу
    \x -> f (g x) :: a -> c 
-}

compose f g = \x -> f (g x)

-- compose :: (t1 -> t2) -> (t3 -> t1) -> t3 -> t2
-- t1 = b, t2 = c, t3 = a

{-
    ghci> :i (.)
    (.) :: (b -> c) -> (a -> b) -> a -> c   -- Defined in ‘GHC.Base’
    infixr 9 .
-}

sumFstFst = (+) `on` helper
    where helper pp = fst $ fst pp

sumFstFst' = (+) `on` (fst . fst)

{-
    композиция 2 функций fst и fst представляет собой функцию, которая
    принимает аргумент аргумент и передает его в первую функцию, потом 
    передает его во вторую функцию и возвращает некоторый результат.
-}

{-
    Цепочка последовательных применений может быть заменена композицией
    doIt x = f (g (h x)) = f((g .h)x) = (f . (g . g)) x
    doIt = f . (g. h)
-}

{-
    Бесточечный стиль — это когда при определении функции явно не используется 
    её параметр. Карирование — это про то, что функция от нескольких параметров 
    представляется как функция от одного параметра, возвращающая другую функцию.
-}

doItYourself = f . g . h

f = logBase 2

g = (^ 3)
h = max 42


-- 2) Полиморфизм кортежей и списков

    {-
        кортежи более полиморфные чем списки

        (,) True 3 -- естественно префиксный стиль конструирования пары
        (,,) True 3 'c'

        ghci> :t (,)
        (,) :: a -> b -> (a, b)
        
        ghci>  :t (,) True 'c'
        (,) True 'c' :: (Bool, Char)
        
        ghci> let dup x = (x,x)
        ghci> :t dup
        dup :: b -> (b, b)
    -}

    {-
        ЗАДАЧА 2

        Сколько разных всегда завершающихся функций с типом 
        a -> (a,b) -> a -> (b,a,a) можно реализовать?

        Ответ: 9
        функция принимает 3 аргумента: 2 типа а и один кортеж типа (a, b)
        f1 a (b, c) d = (c, a, b)
        f2 a (b, c) d = (c, a, d)
        f3 a (b, c) d = (c, b, d)
        f4 a (b, c) d = (c, b, a)
        f5 a (b, c) d = (c, d, a)
        f6 a (b, c) d = (c, d, b)
        f7 a (b, c) d = (c, a, a)
        f8 a (b, c) d = (c, b, b)
        f9 a (b, c) d = (c, d, d)
    -}

    -- 3) Каррирование


{-
    ЗАДАЧА 5

    В модуле Data.Tuple стандартной библиотеки определена функция swap :: (a,b) -> (b,a), переставляющая местами элементы пары:

    GHCi> swap (1,'A')
    ('A',1)
    Эта функция может быть выражена в виде:

    swap = f (g h)
    где f, g и h — некоторые идентификаторы из следующего набора:

    curry uncurry flip (,) const
    Укажите через запятую подходящую тройку f,g,h.

    Ответ: uncurry, flip, (,)
    Пояснение:
    Код uncurry (flip (,)) использует функции uncurry и flip для создания 
    новой функции, которая меняет местами элементы пары:

    1. Функция (,) представляет собой конструктор пары значений. 
        Например, (1, 'A') создаст пару, в которой первый элемент 
        равен 1, а второй элемент равен 'A'.

    2. Функция flip принимает функцию с двумя аргументами и 
    меняет их местами. Например, flip (,) 'A' 1 вернет пару 
    (1, 'A'), где 'A' становится первым элементом, а 1 - вторым элементом.

    3. Функция uncurry принимает функцию с двумя аргументами и применяет
     ее к паре значений. Например, uncurry (+) (2, 3) вернет 
     результат сложения 2 и 3, то есть 5.

    Таким образом, выражение uncurry (flip (,)) использует 
    flip (,) для создания новой функции, которая меняет 
    местами элементы пары, и затем uncurry применяет эту функцию 
    к паре значений. Например, uncurry (flip (,)) ('A', 1) вернет пару (1, 'A'), где 'A' становится первым элементом, а 1 - вторым элементом.
-}
