import Data.IntMap (fromDistinctAscList)
-- Module 2. Basics
-- 2.4 Стандартные классы типов

-- 1) Расширение класса (Class Extention)
    -- Задача 1
-- 2) Классы Show и Read
    -- Задача 2
-- 3) Классы Enum и Bounded
    -- Задача 3
-- 4) Класс Num и его расширения
    -- Задача 4

-- 1) Расширение класса (Class Extension)

{- расширение класса типов механизм слегка похожий на наследование в 
ОО языках, речь идет не о наследовании реализации, а о наследовании 
интерфейсов поскольку классы типов являются некоторым эквивалентом 
интерфейса.
-}

{-
    -- Задача 1

    Пусть существуют два класса типов KnownToGork и KnownToMork,
    которые предоставляют методы stomp (stab) и doesEnrageGork
    (doesEnrageMork) соответственно:

    class KnownToGork a where
        stomp :: a -> a
        doesEnrageGork :: a -> Bool

    class KnownToMork a where
        stab :: a -> a
        doesEnrageMork :: a -> Bool

    Класса типов KnownToGorkAndMork является расширением обоих
    этих классов, предоставляя дополнительно метод stompOrStab:

    class (KnownToGork a, KnownToMork a) => KnownToGorkAndMork a where
        stompOrStab :: a -> a

    Задайте реализацию по умолчанию метода stompOrStab, которая
    
    вызывает метод stomp, если переданное ему значение
    приводит в ярость Морка;
    
    вызывает stab, если оно приводит в ярость Горка
    
    и вызывает сначала stab, а потом stomp, если оно приводит 
    в ярость их обоих.
    
    Если не происходит ничего из вышеперечисленного, метод должен
    возвращать переданный ему аргумент.    
-}

class KnownToGork a where
    stomp :: a -> a
    doesEnrageGork :: a -> Bool

class KnownToMork a where
    stab :: a -> a
    doesEnrageMork :: a -> Bool

class (KnownToGork a, KnownToMork a) => KnownToGorkAndMork a where
    stompOrStab :: a -> a
    stompOrStab x 
        | doesEnrageGork x && not (doesEnrageMork x) = stab x
        | doesEnrageMork x && not (doesEnrageGork x) = stomp x
        | doesEnrageGork x && doesEnrageMork x = stomp (stab x)
        | otherwise = x


-- 2) Классы Show и Read

{-
    класс типов Show, метод show - берет значение некоторого типа и
    возвращает строку, которая является представлением этого значения.
    Сериализация - процесс перевода структуры данных в строку (битовую
    последовательность)

    ghci> :t show
    show :: Show a => a -> String
    ghci> show 5
    "5"
    ghci> show 5.0
    "5.0"
    ghci> show True
    "True"
    ghci> show [1, 2]
    "[1,2]"

    обратная процедура десериализация (создание структуры данных из строки)
    класс Read метод read. По сути это синтаксический разбор ввода.
    функция read полиморфна по возвращаемому значению:

    ghci> read "5"
    *** Exception: Prelude.read: no parse

    пятерка их типа int, integer, double?

    поэтому нужно снять полиморфизм:

    ghci> read "5" :: Int
    5
    ghci> read "5" :: Double
    5.0
    ghci> read "[1, 2]" :: [Double]
    [1.0,2.0]


    функция reads

    ghci> reads "5 rings" :: [(Int,String)]
    [(5," rings")]
-}

{-
        -- Задача 2
    Имея функцию 
    
    ip = show a ++ show b ++ show c ++ show d 
    
    определите значения a, b, c, d так, чтобы добиться 
    следующего поведения:
    
    GHCi> ip
    "127.224.120.12"

    a = 127
    b = 224
    c = 120
    d = 12
-}

ip = show a ++ show b ++ show c ++ show d 

newtype MyIp = MyIp Int
instance Show MyIp where
  show (MyIp a) = show a ++ "."

a = MyIp 127
b = MyIp 224
c = MyIp 120
d = 12

-- brilliant!!!
ip' = show a' ++ show b' ++ show c' ++ show d'
a' = 12
b' = 7.22
c' = 4.12
d' = 0.12

-- -- wow
ip'' = show a ++ show b ++ show c ++ show d 
a'' = 1
b'' = read "27.2" :: Float
c'' = read "24.12" :: Float
d'' = read "0.12" :: Float


-- 3) Классы Enum и Bounded

{-
    Многие встроенные типы является типами перечисления.
-}

-- class Enum a where
--     succ, pred :: a -> a
--     toEnum :: Int -> a
--     fromEnum :: a -> Int

{-
    ghci> minBound :: Bool
    False
    ghci> maxBound :: Bool
    True
    ghci>
    ghci> maxBound :: Int
    9223372036854775807
    ghci> minBound :: Int
    -9223372036854775808
    ghci> minBound :: Char
    '\NUL'
    ghci> maxBound :: Char
    '\1114111'
    ghci> 

    Единственный тип, который является перечислением но при этом не является 
    bounded это integer
-}


{-
    ЗАДАЧА 3

    Реализуйте класс типов

    class SafeEnum a where
    ssucc :: a -> a
    spred :: a -> a
    
    обе функции которого ведут себя как succ и pred стандартного класса Enum, 
    однако являются тотальными, то есть не останавливаются с ошибкой на 
    наибольшем и наименьшем значениях типа-перечисления соответственно, 
    а обеспечивают циклическое поведение. 
    Ваш класс должен быть расширением ряда классов типов стандартной 
    библиотеки, так чтобы можно было написать реализацию по умолчанию 
    его методов, позволяющую объявлять его представителей без необходимости
    писать какой бы то ни было код. Например, для типа Bool должно быть 
    достаточно написать строку

    instance SafeEnum Bool

    и получить возможность вызывать

    GHCi> ssucc False
    True
    GHCi> ssucc True
    False
-}

class (Eq a, Prelude.Enum a, Bounded a)  => SafeEnum a where
  ssucc :: a -> a
  ssucc x | x == maxBound = minBound
          | otherwise     = Prelude.succ x  

  spred :: a -> a
  spred x | x == minBound = maxBound
          |  otherwise    = Prelude.pred x

instance SafeEnum Bool where
-- instance SafeEnum Char where


--     -- 4) Класс Num и его расширения

class Num a where
    (+), (-), (*) :: a -> a -> a
    negate :: a -> a
    abs :: a -> a
    signum :: a -> a
    fromInteger :: Integer -> a

    -- x - y = x + negate y
    -- negate x = 0 - x

    {-
        Для классов типов есть некоторые законы, которые не может проверить 
        компилятор, но им должен следовать программист
        LAW abs x * signum x == x

        Деление в класс не определено, так как деление для целых чисел
        и числе с плавающей точкой реализуется по-разному.
        
        У класса типа Num есть 2 расширения: классы типа Integral & Fractional

        от класса типов Fractional наследуется класс типов Floating
        В этом классе типов определена вся стандартные математические функции.

        RealFrac наследуется от Real & Fractional, содержит функции связанные
        с округлением

        RealFloat - класс типов, который описывает внутреннее представление
        чисел с плавающей точкой

        https://www.haskell.org/onlinereport/haskell2010/haskellch6.html#x13-1270011
    -}

    {-
        ЗАДАЧА 4

        Напишите функцию с сигнатурой:

        avg :: Int -> Int -> Int -> Double
        вычисляющую среднее значение переданных в нее аргументов:

        GHCi> avg 3 4 8
        5.0
    -}


avg :: Int -> Int -> Int -> Double
avg a b c = fromInteger (toInteger a + toInteger b + toInteger c) / 3 

-- alternative-1:
toDouble :: Int -> Double
toDouble = fromInteger . toInteger

avg' :: Int -> Int -> Int -> Double
avg' a b c = (toDouble a + toDouble b + toDouble c) / 3


-- alternative-2:
avg'' :: Int -> Int -> Int -> Double
avg'' a b c = (f a + f b + f c) / 3 where
    f = fromIntegral

{-
    Этот код решает проблему возможного переполнения при сложении целых чисел типа `Int`. 

1. `toInteger a` конвертирует значение переменной `a` из типа `Int` в тип `Integer`. 
Это действие гарантирует, что при сложении чисел не будет происходить переполнение.

4. `fromInteger` конвертирует результат сложения обратно в тип `Double`. Теперь мы можем работать с числом с плавающей запятой без потери точности.

5. Наконец, результат сложения приводится к типу `Double` и делится на 3 с помощью деления `/ 3`. Это дает нам среднее значение этих трех чисел.
-}
