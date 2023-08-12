
import Data.Function

-- Module 2. Basics
-- 2.1 Параметрический полиморфизм

-- 1) Полиморфные функции
    -- Задача 1
    -- Задача 2
-- 2) Наиболее общий тип
-- 3) Функции высших порядков
    -- Задача 3
-- 4) Анонимные функции - лямбда
    -- Задача 4

-- 1) Полиморфные функции

{-
    Про функция говорят, что она обладает полиморфным поведением если она
    может быть вызвана на значениях разных типов.
    Например, оператор сложения, это функция, которая может быть вызвана на int,
    возвращая тип результата int, и double, возвращая тип результат double.
    Таким образом сложение - это полиморфный оператор.

    Выделяют 2 типа полиморфных функций:
    1) параметрический полиморфизм - код функции одинаков для всех типов, 
        на которых можно вызывать эту функцию
    2) специальный полиморфизм - для каждого типа, для которого вызов этой функции
        допустим, имеется своя собственная реализация. Пример выше с int и double
        как раз специальный полиморфизм

    Все конкретные типы начинаются с большой буквы, произвольные с маленькой.
-}

{-
    ЗАДАЧА 1
    Напишите функцию трех аргументов getSecondFrom, полиморфную по каждому из них,
    которая полностью игнорирует первый и третий аргумент, а возвращает второй.
    Укажите ее тип.

    GHCi> getSecondFrom True 'x' "Hello"
    'x'
    GHCi> getSecondFrom 'x' 42 True 
    42
-}


getSecondFrom :: t1 -> t2 -> t3 -> t2
getSecondFrom a b c = b

{-
    ЗАДАЧА 2

    Сколько разных всегда завершающихся функций 
    с типом a -> a -> b -> a -> a можно реализовать?

    Две функции одинаковой арности считаются разными, 
    если существует набор значений их аргументов, на 
    котором они дают разные результирующие значения.

    ПОДСКАЗКА
    Каждая из функций принимает 4 аргумента:
    3 аргумента типа a и один аргумент типа b
    и всегда возвращает одно и то же значение типа a.

    => Нужно посмотреть на возвращаемый функцией тип, 
    и подсчитать количество аргументов данного типа.

    ответ - 3
    f1 :: a -> a -> b -> a -> a
    f1 x y z w = x

    f2 :: a -> a -> b -> a -> a
    f2 x y z w = y

    fn4 :: a -> a -> b -> a -> a
    fn4 x y z w = w
-}


-- 2) Наиболее общий тип

{-
    Можно ограничить степень полиморфизма функции с помощью
    явного указания ее типа.
    Система вывод типов базируется на алгоритме Хиндли - Милнера.
    Выводится самый общий из допустимых типов, если на тип не
    наложено никаких ограничений, как в примерах ниже mono & semiMono
-}

mono :: Char -> Char
mono x = x -- мономорфная функция, может работать только с типом Char

semiMono :: Char -> a -> Char -- а - переменная типа
semiMono x y = x -- мономорфна по первому аргументу и полиморфна по второму

-- 3) Функции высших порядков

{-
    ФВП называется функция, которая принимает в качестве аргумента
    другую функцию.

    при выводе типов возникают уравнения на тип
-}

apply2 :: (t -> t) -> t -> t
apply2 f x = f (f x) -- полиморфна только по 1 параметру, 
-- который выступает и в роли аргумента и в роли возвращаемого значения

example = apply2 (+5) 22 --32 --(+5) сечение оператора сложения
example' = apply2 (++ "AB") "CD" -- ABCD

-- flip f y x = f x y
{-
    ghci> flip (/) 4 2
    0.5

    ghci> flip const 5 True
    True
    ghci> :t flip
    flip :: (a -> b -> c) -> b -> a -> c
    ghci> :t flip const
    flip const :: b -> c -> c

    flip :: (a -> b -> c) -> b -> a -> c
    flip f y x = f x y 
    f это (a -> b -> c)
    y это b
    x это a

    Лево ассоциативное применение функций
     - c начала flip меняет местами 5 и true
     - потом применяем const true 5
    
-}


{-
    ЗАДАЧА 3

    В модуле Data.Function определена полезная функция высшего порядка

    on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    on op f x y = f x `op` f y

    Она принимает четыре аргумента: бинарный оператор с однотипными 
    аргументами (типа b), функцию f :: a -> b, возвращающую значение 
    типа b, и два значения типа a. Функция on применяет f дважды к 
    двум значениям типа a и передает результат в бинарный оператор.

    Используя on можно, например, записать функцию суммирования 
    квадратов аргументов так:

    sumSquares = (+) `on` (^2)

    Функция multSecond, перемножающая вторые элементы пар, 
    реализована следующим образом

    multSecond = g `on` h
    g = undefined
    h = undefined

    Напишите реализацию функций g и h.

    GHCi> multSecond ('A',2) ('E',7)
    14
-}

sumSquares = (+) `on` (^2)

multSecond = g `on` h

g x y = x * y

h (a, b)  = b

-- красивый вариант:

multSecond' :: (a, Int) -> (a, Int) -> Int
multSecond' = g `on` h
  where
    g :: Int -> Int -> Int
    g  = (*)

    h :: (a, Int) -> Int
    h = snd


-- 4) Анонимные функции - лямбда

p1 = ((1,2), (3,4))
p2 = ((3,4), (5,6))

sumFstFst = (+) `on` helper
    where helper pp = fst $ fst pp

 -- sumFstFst p1 p2  получим 4

{-
    ЗАДАЧА 4
    Реализуйте функцию on3, имеющую семантику, схожую с on, но принимающую в качестве первого аргумента трехместную функцию:

    on3 :: (b -> b -> b -> c) -> (a -> b) -> a -> a -> a -> c
    on3 op f x y z = undefined
    Например, сумма квадратов трех чисел может быть записана с использованием on3 так

    GHCi> let sum3squares = (\x y z -> x+y+z) `on3` (^2)
    GHCi> sum3squares 1 2 3
    14
-}

on3 :: (b -> b -> b -> c) -> (a -> b) -> a -> a -> a -> c
on3 op f x y z = op (f x) (f y) (f z)


{-
    Функция принимает 5 аргументов:
   1) бинарный оператор с однотипными аргументами типа b
   2) функцию f :: a -> b, возвращающую значение типа b
   3) 3 значения типа a

    Функция on3 применяет f трижды к трем значениями типа а и передает результат
    в бинарный оператор.
-}


sum3plus5 = (\x y z -> x+y+z) `on3` (+5)
result = sum3plus5 1 2 3 -- 21
