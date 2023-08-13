
-- Module 1. Intro
-- 1.6 Local Bindings and Indentation Rules

-- 1) Отступы

{-
    Отступы имеют содержательную роль, задают так называемый
    двумерный синтаксис и распознаются компилятором. Табуляция 
    равна 8 пробелам вне зависимости от настроек редактора.
    
    Основной принцип: увеличение отступа безопасно, а уменьшение
    отступа может привести к проблемам.

    Увеличение отступа говорит о том, что мы продолжаем текущее
    объявление, которое началось на предыдущей строке.

    Решение квадратного уравнения:
    ax^2 + bx + c = 0
    D = b^2 - 4ac
    if D<0  действительных корней нет
       D=0  x= -b/2a
       D>0  x1,2 = (-b +/- sqrt(D)) / (2a)
-}


roots :: Double -> Double -> Double 
            -> (Double, Double)

roots a b c =
    (
        (-b - sqrt (b ^ 2 - 4 * a * c)) / (2 * a)
    ,
        (-b + sqrt (b ^ 2 - 4 * a * c)) / (2 * a)
    )

{-
    С нулевого отступа начинаются глобальные объявления: 27 и 29 строка
    ghci> roots 1 (-4) (-5)
    (-1.0,5.0)
-}

-- 2) Выражение let...in...Applicative


roots' a b c =
    let d = sqrt (b ^ 2 - 4 * a * c) in -- local binding: некоторая переменная связывается с некоторым выражением
    ((-b - d) / (2 * a), (-b + d) / (2 * a))

roots'' :: Floating b => b -> b -> b -> (b, b)
roots'' a b c =
    -- порядок связывания не важен
    let {d = sqrt (b ^ 2 - 4 * a * c); x1 = (-b - d) / (2 * a); x2 = (-b + d) / (2 * a)}
    in (x1, x2)

roots''' a b c =
    let
        -- здесь локальные связывания должны иметь один и тот же отступ
        x1 = (-b - d) / aTwice
        x2 = (-b + d) / aTwice
        d = sqrt (b ^ 2 - 4 * a * c)
        aTwice = (2 * a)
    in (x1, x2)

-- 3) Локальные связывания функций и образцов

factorial5 n | n >= 0 = helper 1 n
             | otherwise = error "arg must be >= 0"

{- эта функция нужна только для расчета факториала, поэтому она засоряет
    глобальное пространство имен и лучше определить ее локально.
-}
helper acc 0 = acc
helper acc n = helper (acc * n) (n - 1) 

factorial6 n | n >= 0 = let
                    helper acc 0 = acc
                    helper acc n = helper (acc * n) (n - 1) 
                in helper 1 n
             | otherwise = error "arg must be >= 0"

rootsDiff a b c = let
    (x1, x2) = roots a b c
    in x2 - x1

{-
    возможно также не только локальное связывание функций, но и локальное
    связывание образцов
    ghci> rootsDiff 1 (-4) (-5)
    6.0
-}

{-
    Задача
    Реализуйте функцию seqA, находящую элементы следующей рекуррентной последовательности
    a_{0}=1;a_{1}=2;a_{2}=3;a_{k+3}=a_{k+2}+a_{k+1}-2a_{k} 
    GHCi> seqA 301
    1276538859311178639666612897162414
-}


seqA n = let
        helper n a b c | n == 0 = a
                       | otherwise = helper (n - 1) b c (b + c - 2 * a)
        in helper n 1 2 3 


-- 4) Конструкция where

{-
    Сначала идет конструкция, в которой используются какие-то переменные, 
    а потом внутри выражения where происходит локальное связывание.
    
    Конструкция where может использоваться только в определении функции
    только на определенном месте в качестве глобальной части тела этой функции
-}
 
roots'''' a b c = (x1, x2) where
     -- здесь локальные связывания должны иметь один и тот же отступ
    x1 = (-b - d) / aTwice
    x2 = (-b + d) / aTwice
    d = sqrt (b ^ 2 - 4 * a * c)
    aTwice = 2 * a

-- let... in является выражением, where выражением не является

{-
    ghci> let x = 2 in x ^ 2
    4
    ghci> (let x = 2 in x ^ 2) ^ 2
16
-}

-- Используется там, где выражение let... in использовать нельзя
-- в примере ниже благодаря where стало возможным использовать helper
-- в нескольких уравнениях с охранным выражением

factorial7 :: Integer -> Integer
factorial7 n | n>= 0     = helper 1 n
             | otherwise = error "arg must be >=0"
    where
        helper acc 0 = acc
        helper acc n = helper (acc * n) (n - 1)


{-
    ЗАДАЧА

    Реализуйте функцию, находящую сумму и количество цифр 
    десятичной записи заданного целого числа.

    sum'n'count :: Integer -> (Integer, Integer)
    sum'n'count x = undefined

    GHCi> sum'n'count (-39)
    (12,2)

-}

-- sum'n'count n = abs n

sum'n'count :: Integer -> (Integer, Integer)
sum'n'count n
    | n == 0 = (0,1)
    | otherwise = 
        countDigits (abs n) 0 0
        where
            countDigits 0 count sum = (sum, count)
            countDigits num count sum = 
                countDigits (div num 10) (count + 1) (sum + mod num 10)

-- sum'n'count :: Integer -> (Integer, Integer)
-- sum'n'count x = f (abs x) (0,0) where
--   f n (sum, count) | n < 10 = (sum+n, count+1)
--                    | otherwise = f (div n 10) (sum+(rem n 10), count+1)

{-
    ЗАДАЧА

    Реализуйте функцию, находящую значение определённого интеграла 
    от заданной функции f на заданном интервале [a, b] методом трапеций.
    (Используйте равномерную сетку; достаточно 1000 элементарных отрезков.)

    integration :: (Double -> Double) -> Double -> Double -> Double
    integration f a b = undefined

    GHCi> integration sin pi 0
    -2.0

    Результат может отличаться от -2.0, но не более чем на 1e-4.
    
-}

{-
    Подсказки

    Вот формула для вычисления значения определенного интеграла методом трапеций:
    см википедия, численное интегрирование
    Integral ≈ h * (f(a) + f(b))/2 + sum(f(xi)), где i = 1 до n-1

    где:
    - h - шаг между соседними точками на равномерной сетке (h = (b - a) / n)
    - f(a) и f(b) - значения функции на концах интервала a, b
    - f(xi) - значения функции на промежуточных точках xi, где i = 1 до n-1
    - n - количество элементарных отрезков (в данном случае 1000)
-}

integration :: (Double -> Double) -> Double -> Double -> Double
integration f a b = h * ((f a + f b) / 2 + f'sum 0 (n - 1))
    where
        n = 1000
        h = (b - a) / n
        f'sum acc i | i == 0    = acc
                    | otherwise = f'sum (acc + f (a + i * h)) (i - 1)


