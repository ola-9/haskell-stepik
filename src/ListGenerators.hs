import Debug.Trace (traceShow)
import Prelude hiding (repeat, replicate, cycle, iterate)

-- Module 3. Lists
-- 3.3 Генераторы списков

-- 1) Бесконечные списки
    -- Задача 1
-- 2) Функции, порождающие бесконечные списки
    -- Задача 2
-- 3) Арифметические последовательности
    -- Задача 3
-- 4) Выделение списков (list comprehension)
    -- Задача 4


-- 1) Бесконечные списки


-- Типы расходящихся программ:
bot = not bot -- просто зависает
ones = 1 : ones -- эта продуктивная, т.е. за каждый конечный интервал времени,
                -- она выполняет какую-то работу по выводу единицы на экран
-- ленивая природа haskell  позволяет работать с продуктивными расходящимися
-- программами.

nats n = n :nats (n + 1)
-- ghci> take 10 $ nats 5
-- [5,6,7,8,9,10,11,12,13,14]

-- ghci> head $ nats 42
-- 42

{-
head (x:xs) = x
head [] = error "empty list"

head $ nats 42              -- сопоставление с образцов в head
~> head (42: nats (42 + 1)) -- подстановка определения head
~> 42

head $ nats (40+2)             
~> head ((40+2): nats ((40+2) + 1)) 
~> 40+2
~> 42
-}

-- вычисление происходит до того момента, когда станет понятно, какое уравнение
-- подходит, вычисление nats (42 + 1) не происходит, потому что они просто не
-- нужны для выполнения head

squares = map (^2) $ nats 1

-- ghci> take 10 $ squares 
-- [1,4,9,16,25,36,49,64,81,100]


    -- Задача 1
{-
    Реализуйте c использованием функции zipWith функцию fibStream,
    возвращающую бесконечный список чисел Фибоначчи.

    GHCi> take 10 $ fibStream
    [0,1,1,2,3,5,8,13,21,34]
-}
fibStream  = 0: 1 : zipWith (+) fibStream (tail fibStream)

-- ghci> zipWith (+) [0] [1]
-- [1]
-- ghci> zipWith (+) [1] [1]
-- [2]
-- ghci> zipWith (+) [1] [2]
-- [3]
-- ghci> zipWith (+) [2][3]
-- [5]
-- ghci> zipWith (+) [3][5]
-- [8]


-- 2) Функции, порождающие бесконечные списки

repeat :: a -> [a]
repeat x = xs where xs = x : xs
-- ghci> take 5 $ repeat 'z'
-- "zzzzz"

{-
В определении xs = x : xs, мы создаем список xs, который состоит из
элемента x, за которым следует список xs. Таким образом, xs
ссылается на саму себя, создавая рекурсивную структуру данных.

Когда мы вызываем repeat x, список xs начинает с элемента x,
и каждый последующий элемент списка также является x,
за которым следует список xs. Это позволяет нам создать
бесконечный список, состоящий из повторяющихся элементов x.
-}

-- > repeat' x = x : repeat' x
-- > repeat'' x = xs where xs = x:xs - более эффективна по использованию памяти
-- > repeat'' 42 !! 100000000
-- 42
-- > repeat' 42 !! 100000000
-- Interrupted.

replicate :: Int -> a -> [a]
replicate n x = take n (repeat x)

cycle :: [a] -> [a]
cycle [] = error "cycle: empty list"
cycle xs = ys where ys = xs ++ ys
-- ghci> take 10 $ cycle [1,2,3]
-- [1,2,3,1,2,3,1,2,3,1]

iterate :: (a -> a) -> a -> [a]
iterate f x = x: iterate f (f x)
-- ghci> take 5 $ iterate (^2) 2
-- [2,4,16,256,65536]

    -- Задача 2

{-
    Предположим, что функция repeat, была бы определена следующим
    образом:
    repeat = iterate repeatHelper
    определите, как должна выглядеть функция repeatHelper.
-}

repeatHelper :: a -> a
repeatHelper x = x
-- repeatHelper = id


-- 3) Арифметические последовательности

{- в Х есть специальные полезные синтаксические конструкции, которые
позволяют генерировать большие списки с регулярной структурой.

ghci> [1..10]
[1,2,3,4,5,6,7,8,9,10]
синтаксический сахар для:
ghci> enumFromTo 1 10
[1,2,3,4,5,6,7,8,9,10]

ghci> ['a'..'z']
"abcdefghijklmnopqrstuvwxyz"

ghci> [1,3..10]  -- если нужно задать шаг = enumFromThenTo 1 3 10
[1,3,5,7,9]

ghci> take 5 $ [1..] -- take 5 $ enumFrom 1
[1,2,3,4,5]
-}

    -- Задача 3

{-
Пусть задан тип Odd нечетных чисел следующим образом:

data Odd = Odd Integer 
  deriving (Eq, Show)

Сделайте этот тип представителем класса типов Enum.

GHCi> succ $ Odd (-100000000000003)
Odd (-100000000000001)

Конструкции с четным аргументом, типа Odd 2, считаются недопустимыми
и не тестируются.

Примечание. Мы еще не знакомились с объявлениями пользовательских
типов данных, однако, скорее всего, приведенное объявление не
вызовет сложностей. Здесь объявляется тип данных Odd
с конструктором Odd. Фактически это простая упаковка для типа Integer. Часть deriving (Eq, Show) указывает компилятору, чтобы он автоматически сгенерировал представителей соответствующих классов типов для нашего типа (такая возможность имеется для ряда стандартных классов типов). Значения типа Odd можно конструировать следующим образом:

GHCi> let x = Odd 33
GHCi> x
Odd 33

и использовать конструктор данных Odd в сопоставлении с образцом:

addEven :: Odd -> Integer -> Odd
addEven (Odd n) m | m `mod` 2 == 0 = Odd (n + m)
                  | otherwise      = error "addEven: second parameter cannot be odd"
-}
data Odd = Odd Integer 
  deriving (Eq, Show)

instance Enum Odd where
  toEnum i = Odd(toInteger i)
  fromEnum (Odd n) = fromEnum n

  succ (Odd n) = Odd (n+2)
  pred (Odd n) = Odd (n-2)

  enumFrom (Odd n) = map Odd [n,n+2..]
  enumFromTo (Odd n) (Odd m) = map Odd [n,n+2..m]
  enumFromThen (Odd n) (Odd n') = map Odd [n,n'..]
  enumFromThenTo (Odd n) (Odd n') (Odd m) = map Odd [n,n'..m]

{-
Из-за того что стандартный класс Enum имеет методы fromEnum/toEnum c типами a -> Int
и Int -> a, а Odd задан как Integer, и в тестах (невидимых!!!!) есть проверки на
значения превышающие maxInt64, получается нехорошая с образовательной точки зрения
ситуаия, когда решение в общем то правильное, но приходится сидеть гадать почему
тесты не проходят. 
-}


-- 4) Выделение списков (list comprehension)


-- ghci> [x^2| x <- xs] множество x^2 где х принадлежит xs
-- [1,4,9,16,25,36,49,64,81,100,121,144,169,196,225,256,289,324,361,400]

-- ghci> [x^2| x <- xs, x^2 < 200]
-- [1,4,9,16,25,36,49,64,81,100,121,144,169,196]

-- чем правей генератор, тем чаще он меняется
-- ghci> [(x,y) | x <- [1,2], y <- [1,2]]
-- [(1,1),(1,2),(2,1),(2,2)]

-- ghci> [(x,y,z) | x<-xs, y<-xs, z<-xs, x^2+y^2==z^2,x<=y]
-- [(3,4,5),(5,12,13),(6,8,10),(8,15,17),(9,12,15),(12,16,20)]


    -- Задача 4

{-
    Пусть есть список положительных достоинств монет coins, отсортированный по возрастанию.
    Воспользовавшись механизмом генераторов списков, напишите функцию change, которая
    разбивает переданную ей положительную сумму денег на монеты достоинств из списка coins
    всеми возможными способами. Например, если coins = [2, 3, 7]:

 
    GHCi> change 7
    [[2,2,3],[2,3,2],[3,2,2],[7]]

    Примечание. Порядок монет в каждом разбиении имеет значение, то есть наборы [2,2,3] 
    и [2,3,2] — различаются.
    
    Список coins определять не надо.
    
-}
coins = [2, 3, 7]

change :: (Ord a, Num a) => a -> [[a]]
change 0 = [[]]
change amount = [coin:rest | coin <- coins, coin <= amount, rest <- change (amount - coin)]

-- alternative:
-- change :: (Ord a, Num a) => a -> [[a]]
-- change n | n < 0     = []
--          | n == 0    = [[]]
--          | otherwise = [ x : xs | x <- coins, xs <- change (n - x) ]

{-
В базовом случае, когда amount равно 0, мы возвращаем список с одним пустым списком [],
так как сумма 0 может быть представлена без использования монет.

В рекурсивном случае, мы используем генератор списков coin <- coins для выбора каждой
монеты из списка coins. Мы также проверяем, что достоинство монеты coin не превышает
оставшуюся сумму amount. Затем рекурсивно вызываем change (amount - coin), чтобы найти
все возможные разбиения оставшейся суммы. Для каждого разбиения оставшейся суммы rest,
мы добавляем выбранную монету coin в начало разбиения с помощью оператора :.

Таким образом, функция change будет рекурсивно генерировать все возможные разбиения
заданной суммы на монеты из списка coins.
-}
