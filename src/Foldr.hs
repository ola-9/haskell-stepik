import Prelude hiding (foldr)

-- Module 3. Lists
-- 3.4 Правая свертка

-- 1) Определение правой свёртки
    -- Задача 1 
-- 2) Оформление сворачивающей функции
    -- Задача 2 
    -- Задача 3
-- 3) Порядок обхода списка при свёртке
    -- Задача 4
    -- Задача 5


-- 1) Определение правой свёртки

sumList :: [Integer] -> Integer
sumList []      = 0
sumList (x:xs)  = x + sumList xs
sumList' xs = foldr (+) 0 xs
sumList'' = foldr (+) 0

productList :: [Integer] -> Integer
productList []      = 1
productList (x:xs)  = x * productList xs

concatList :: [[a]] -> [a]
concatList []      = []
concatList (x:xs)  = x ++ concatList xs
concatList' = foldr (++) []

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f ini []      = ini
foldr f ini (x:xs)  = x `f` foldr f ini xs


-- 2) Оформление сворачивающей функции

-- посчитать сумму квадратов положительных элементов списка
sumPositiveSquares :: [Integer] -> Integer
sumPositiveSquares = foldr (\x s -> if x > 0 then x^2 + s else s)  0
-- ghci> sumPositiveSquares [1,(-2),3]
-- 10
sumPositiveSquares' :: [Integer] -> Integer
sumPositiveSquares' = foldr f  0 where
    f x s | x > 0 = x^2 + s 
          | otherwise = s


    -- Задача 2 
{-
Используя функцию foldr, напишите реализацию функции lengthList,
вычисляющей количество элементов в списке.

GHCi> lengthList [7,6,5]
3
-}

lengthList :: [a] -> Int
lengthList = foldr (\x s -> s + 1) 0
-- lengthList = foldr (\_ s -> s + 1) 0

    -- Задача 3
{-
Реализуйте функцию sumOdd, которая суммирует элементы списка целых чисел,
имеющие нечетные значения:

GHCi> sumOdd [2,5,30,37]
42
-}

sumOdd :: [Integer] -> Integer
sumOdd = foldr (\x s -> if odd x  then x+s else s) 0


-- 3) Порядок обхода списка при свёртке

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f ini []      = ini
foldr' f ini (x:xs)  = x `f` foldr f ini xs

{-
foldr' f ini []  1:2:3:[]
~> 1 `f` foldr' f ini (2:3:[])
~> 1 `f` (2 `f `foldr' f ini (3:[]))
~> 1 `f` (2 `f` (3 `f`foldr' f ini []))
~> 1 `f` (2 `f` (3 `f` ini ))           -- ini = []
-}

-- ghci> foldr (-) 5 [1,2,3]
-- -3
-- ghci> (1 - (2 - (3 - 5)))
-- -3

    -- Задача 4
-- Какой функции стандартной библиотеки, суженной на списки, эквивалентно
-- выражение foldr (:) []? -- id
-- ghci> foldr (:) [] [1, 2, 3, 4] 
-- [1,2,3,4]
-- Какой список приняли, такой и возвращаем, т.е. работает как id


    -- Задача 5
-- Какой функции стандартной библиотеки эквивалентно выражение
-- foldr const undefined?
-- ghci> foldr const undefined [1,2,3]
-- 1
-- head
