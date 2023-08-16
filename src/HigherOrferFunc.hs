import Prelude hiding (
    filter, takeWhile, dropWhile, span, break,
    map, concat, concatMap,
    and, or, all, any,
    zipWith, zipWith3)
import Data.Char (isDigit, isUpper, isLower)
import Data.Binary.Get (Decoder(Fail))

-- Module 3. Lists
-- 1.2 Higher Order Functions 

-- 1) Функции с аргументами предикатами
    -- Задача 1
    -- Задача 2
    -- Задача 3
-- 2) Функция map
    -- Задача 4
    -- Задача 5
-- 3) Использование map
    -- Задача 6
-- 4) Семейство zipWith
    -- Задача 7

-- 1) Функции с аргументами предикатами

filter :: (a -> Bool) -> [a] -> [a] -- унарный предикат
filter p [] = []
filter p (x:xs)
    | p x       = x : filter p xs -- предикат p применяем к голове списка x
    | otherwise = filter p xs

-- ghci> filter (<3) [1,2,3,4,1,2,3,4]
-- [1,2,1,2]


takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile _ [] = []
takeWhile p (x:xs)
    | p x      = x: takeWhile p xs
    |otherwise = []

-- ghci> takeWhile (<3) [1,2,3,4,1,2,3,4]
-- [1,2]

-- пока предикат выполняется, элементы отбрасываются
dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile _ [] = []
dropWhile p xs@(x:xs') -- xs@ локальный псевдоним для (x:xs')
    | p x       = dropWhile p xs'
    | otherwise = xs

-- ghci> dropWhile (<3) [1,2,3,4,1,2,3,4]
-- [3,4,1,2,3,4]


span :: (a -> Bool) -> [a] -> ([a], [a]) -- первый список удовляетворяет предикату, второй нет
span p xs = (takeWhile p xs, dropWhile p xs)

-- ghci> span (<3) [1,2,3,4,1,2,3,4]
-- ([1,2],[3,4,1,2,3,4])


-- пока предикат не выполняется конструирует первый список
-- второй список где выполняется предикат
break :: (a -> Bool) -> [a] -> ([a], [a])
break p = span (not . p)

-- ghci> break (>3) [1,2,3,4,1,2,3,4]
-- ([1,2,3],[4,1,2,3,4])

-- break и span разрыв происходит в той точке где первый раз происходит переключение
-- выполнение предиката на него не выполнение


    -- Задача 1

{-
    Напишите функцию readDigits, принимающую строку и возвращающую пару строк.
    Первый элемент пары содержит цифровой префикс исходной строки, а второй 
    - ее оставшуюся часть.Applicative

    ghci> readDigits "365ads"
    ("365", "ads")

    ghci> readDigits "365"
    ("365", "")
-}

readDigits :: String -> (String, String)
readDigits = span isDigit


    -- Задача 2

{-
    Реализуйте функцию filterDisj, принимающую два унарных предиката и список,
    и возвращающую список элементов, удовлетворяющих хотя бы одно из предикатов

    ghci> filterDisj (<10) odd [7,8,10,11,12] 
    [7,8,11]
-}

filterDisj :: (a -> Bool) -> (a -> Bool) -> [a] -> [a]
filterDisj p1 p2 [] = []
filterDisj p1 p2 (x:xs)
    | p1 x || p2 x   = x : filterDisj p1 p2 xs
    | otherwise = filterDisj p1 p2 xs


filterDisj' p1 p2 = filter (\x -> p1 x || p2 x)

filterDisj'' p1 p2 = filter p where
    p x = p1 x || p2 x

    -- Задача 3
{-
    Напишите реализацию функции qsort. Функция qsort должна принимать на вход
    список элементов и сортировать его в порядке возрастания с помощью сортировки
    Хоара: для какого-то элемента х изначального списка (обычно назначают первый)
    делить список на элементы меньше и не меньше х, потом запускаться рекурсивно
    на обеих частях.

    ghci> qsort [1,3,2,5]
    [1,2,3,5]

    Разрешается использовать только функции, доступные из библиотеки Prelude
-}

qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
  where smaller = filter (<= x) xs
        larger = filter (> x) xs


-- better:
qsort' :: Ord a => [a] -> [a]
qsort' [] = []
-- qsort' (x:xs) = qsort (filter (<x) xs) ++ (x : qsort (filter (>=x) xs))
qsort' (x:xs) = qsort (filter (<x) xs) ++ [x] ++ qsort (filter (>=x) xs)


-- 2) Функция map

-- принимает не предикат, а некоторую произвольную функцию
map :: (a -> b) -> [a] -> [b]
map _ []    = []
map f (x:xs) = f x : map f xs

-- ghci> map (+10) [1,2,3,5]
-- [11,12,13,15]

-- ghci> map length ["aa", "bb", "ccccc"]
-- [2,2,5]


-- есть список списков, задача получить список типа а
concat :: [[a]] -> [a]
concat []   = []
concat (xs:xss) = xs ++ concat xss

-- ghci> concat [[1,2],[3,4]]
-- [1,2,3,4]
-- ghci> concat ["hello"," ","world","!"]
-- "hello world!"

concatMap :: (a -> [b]) -> [a] -> [b]
concatMap f = concat . map f -- композиция функций, бесточечный стиль
-- concatMap f xs = concat (map f xs) -- map f xs возвращает список списков

-- ghci> concatMap (\x -> [x,x,x]) "ABCD"
-- "AAABBBCCCDDD"

concatMap' :: (a -> b) -> [a] -> [b]
concatMap' f = map f
-- ghci> concatMap' (\x -> [x,x,x]) "ABCD"
-- ["AAA","BBB","CCC","DDD"]


    -- Задача 4
{-
    Напишите функцию squares'n'cubes, принимающую список чисел,
    и возвращающую список квадратов и кубов элементов исходного списка.
    GHCi> squares'n'cubes [3,4,5]
    [9,27,16,64,25,125]
-}

squares'n'cubes :: Num a => [a] -> [a]
squares'n'cubes l = concatMap (\x -> [x*x, x^3]) l

-- without higher order function
squares'n'cubes' :: Num a => [a] -> [a]
squares'n'cubes' [] = []
squares'n'cubes' (x:xs) = x^2 : x^3 : squares'n'cubes xs

-- another option
squares'n'cubes'' = concat . map (\x -> [x^2, x^3])


    -- Задача 5
{-
    Воспользовавшись функциями map и concatMap, определите функцию perms,
    которая возвращает все перестановки, которые можно получить из данного
    списка, в любом порядке.

    GHCi> perms [1,2,3]
    [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
    Считайте, что все элементы в списке уникальны, и что для пустого списка
    имеется одна перестановка.

-}

perms :: [a] -> [[a]]
perms [] = [[]]
perms [x] = [[x]]
perms (x:xs) = concatMap (insertElem x) (perms xs)
    where
        insertElem x [] = [[x]]
        insertElem x yss@(y:ys) = (x:yss) : map (y:) (insertElem x ys)


{-
    Идея состоит в том, чтобы сгенерировать все перестановки рекурсивно.
    Для этого мы вызываем `perms xs` и, по предположению, получаем
    все перестановки для хвоста нашего списка. Например, если список
    был `[1, 2, 3]`, мы получили все перестановки списка `[2, 3]`,
    то есть `[[2, 3], [3, 2]]`. Теперь надо преобразовать этот ответ
    для хвоста в ответ для нашего исходного списка. Для этого
    требуется недостающий элемент `1` вставить всеми возможными
    способами в полученные перестановки.

    Чтобы сделать это, мы реализуем функцию `insertElem x xs`, которая
    вставляет `x` во все позиции списка `xs`, то есть, первым элементом,
    между первым и вторым, между вторым и третьим, и так далее. Эта
    функция тоже работает рекурсивно.

    Таким образом, `insertElem 1 [2,3] = [[1,2,3], [2,1,3], [2,3,1]]`,
    а `insertElem 1 [3,2] = [[1,3,2], [3,1,2], [3,2,1]]`.
    Соответственно, остается только применить функцию `insertElem x`
    к полученным рекурсивно перестановкам хвоста и сплющить полученный
    список, для чего и подходит функция `concatMap`.    
-}

-- https://stackoverflow.com/questions/24484348/what-does-this-list-permutations-implementation-in-haskell-exactly-do/24564307#24564307

{-
perms :: [a] -> [[a]]
perms [] = [[]]
perms xs = concatMap (\x -> map (x:) (perms (remove x xs))) xs
  where
    remove _ [] = []
    remove x (y:ys)
      | x == y = ys
      | otherwise = y : remove x ys


Функция perms принимает на вход список [a] и возвращает список списков [[a]],
содержащий все возможные перестановки элементов из исходного списка.

В первой строке мы определяем базовый случай: если список пустой,
то возвращаем список, содержащий пустой список [[]].

Во второй строке мы используем функцию concatMap, чтобы применить
анонимную функцию \x -> map (x:) (perms (remove x xs)) ко всем
элементам списка xs и объединить результаты в один список. Здесь x - это текущий элемент из списка xs.

В анонимной функции \x -> map (x:) (perms (remove x xs)) мы создаем
новый список, добавляя текущий элемент x в начало каждой перестановки,
полученной рекурсивным вызовом функции perms на списке, из которого удален
текущий элемент.

Функция remove используется для удаления элемента x из списка xs.
Если текущий элемент y равен x, то мы пропускаем его и рекурсивно
вызываем remove x на оставшейся части списка. Если элемент y не равен
x, то мы его сохраняем и рекурсивно вызываем remove x на оставшейся
части списка.

Таким образом, функция perms рекурсивно генерирует все возможные
перестановки элементов из исходного списка, используя функции map,
concatMap и remove.
-}

    -- 3) Использование map

and, or :: [Bool] -> Bool

-- если в списке все значения True, то возвращается True
and []      = True
and (x:xs)  = x && and xs

or []       = False
or (x:xs)   = x || or xs

all :: (a -> Bool) -> [a] -> Bool
all p = and . map p
-- ghci> all odd [1,3,43]
-- True
-- ghci> all odd [1,3,43, 44]
-- False

-- присутствует ли в списке хотя бы один элемент, удовлетворяющий предикату
any :: (a -> Bool) -> [a] -> Bool
any p = or . map p
-- ghci> any odd [1,3,43, 44]
-- True
-- ghci> any even [1,3,43]
-- False

-- ghci> words "Abc is not ABC"
-- ["Abc","is","not","ABC"]
-- ghci> unwords ["Abc","is","not","ABC"]
-- "Abc is not ABC"
-- ghci> unwords (words "Abc is not ABC")
-- "Abc is not ABC"
-- ghci> unwords . words $ "Abc is not ABC"
-- "Abc is not ABC"
-- ghci> unwords . map reverse . words $ "Abc is not ABC"
-- "cbA si ton CBA"

revWords :: String -> String
revWords = unwords . map reverse . words


    -- Задача 6

{-
    Реализуйте функцию delAllUpper, удаляющую из текста все слова,
    целиком состоящие из символов в верхнем регистре. Предполагается,
    что текст состоит только из символов алфавита и пробелов,
    знаки пунктуации, цифры и т.п. отсутствуют.

    GHCi> delAllUpper "Abc IS not ABC"
    "Abc not"
    
    Постарайтесь реализовать эту функцию как цепочку композиций,
    аналогично revWords из предыдущего видео.
-}


delAllUpper :: String -> String
delAllUpper = unwords . filter (any isLower) . words
delAllUpper' = unwords . filter (not . all isUpper) . words


-- 4) Семейство zipWith

-- вместо того, чтобы строить пару, указывает каким именно способом
-- соединять элементы

-- первый параметр - функция 2 аргументов
-- берет элемент из первого списка [a]
-- берет элемент из второго списка [b]
-- применяет к ним функцию и помещает результат в результирующий список [c]
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith _ []     _      = []
zipWith _ _      []     = []
zipWith f (x:xs) (y:ys) = f x y : zipWith f xs ys
-- ghci> zipWith (+) [1,2] [3,4,5]
-- [4,6]
-- получиется, что zip это частный случай это функции:
-- ghci> zipWith (,) [1,2] [3,4,5]
-- [(1,3),(2,4)]


zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
zipWith3 _  _      _      _     = []
zipWith3 f (x:xs) (y:ys) (z:zs) = f x y z: zipWith3 f xs ys zs


    -- Задача 7

{-
    Напишите функцию max3, которой передаются три списка одинаковой
    длины и которая возвращает список той же длины, содержащий на
    k-ой позиции наибольшее значение из величин на этой позиции
    в списках-аргументах.

    то есть в результирующем списке первый элемент - максимальный из первых элементов трех списков,
    второй - максимальный из вторых элементов, итд.
    
    GHCi> max3 [7,2,9] [3,6,8] [1,8,10]
    [7,8,10]
    GHCi> max3 "AXZ" "YDW" "MLK"
    "YXZ"
-}

max3 :: Ord a => [a] -> [a] -> [a] -> [a]
-- max3 a b c = zipWith3 (\x y z -> max (max x y) z) a b c
max3 = zipWith3 (\x y z -> max (max x y) z)
