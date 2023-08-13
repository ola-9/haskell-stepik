import Prelude hiding ((==), Eq)

-- Module 2. Basics
-- 2.3 Классы типов

-- 1) Контексты
    -- Задача 1
-- 2) Объявление класса типов
    -- Задача 2
-- 3) Объявление представителей класса типов
    -- Задача 3
-- 4) Полиморфизм при объявлении представителей
    -- Задача 4


-- 1) Контексты

{-
    Специальный полиморфизм - функция может вызываться на разных типах данных,
    но каждый тип данных, который использует специальный полиморфизм должен
    обеспечивать реализацию соответствующего интерфейса для того, чтобы функция
    могла его вызвать. Этот интерфейс называется классом  типов.
    
    Класс типов описывает интерфейс целиком, и есть еще одно понятие реализация
    класса типов, реализация представителя, тип данных должен объявлять 
    представителя класса типов, то есть имплементировать соответствующий
    интерфейс и после того, как имплементирован соответствующий интерфейс, мы можем
    уже в специальную полиморфную функцию такой тип данных передавать.

    ghci> :t 7
    7 :: Num a => a

    справа сам тип выражения
    слева контекст, который состоит из 2 частей:
    1) имя интерфейса, который должен выставлять тип, который используется
    в правой части 
    2) этот интерфейс применен к соответствующему типу

    7 имеет полиморфный тип а, но для этого типа а должен быть выставлен 
    интерфейс Num.
-}


-- 2) Объявление класса типов

{-
    Класс типов задает интерфейс, который конкретные типы
    могу реализовывать. 
    Класс типов представляет самой именованный набор функций с 
    сигнатурами параметризованный общим типовым параметром.
-}

-- class Eq a where
--     (==),(/=) :: a -> a -> Bool
--     x /= y = not (x == y)


-- instance Eq Bool where
--     True == True  = True
--     False == False = True 
--     _     == _     = False

    -- x /= y = not (x == y)

{-
        -- Задача 4

    Реализуйте класс типов Printable, предоставляющий один метод toString — функцию одной переменной, которая преобразует значение типа, являющегося представителем Printable, в строковое представление.

    Сделайте типы данных Bool и () представителями этого класса типов, обеспечив следующее поведение:

    GHCi> toString True
    "true"
    GHCi> toString False
    "false"
    GHCi> toString ()
    "unit type"
-}

class Printable b where
    toString :: b -> [Char]

instance Printable Bool where
    toString True = "true"
    toString False = "false"
    -- toString x | x == True = "true"
    --            | x == False = "false"

instance Printable () where
    toString () = "unit type"
--   toString _ = "true" -- _ все остальное

{-
    ghci> toString True
    "true"
    ghci> toString False
    "false"
    ghci> toString ()
    "unit type"
    ghci> toString 5

    <interactive>:135:1: error:
        • Ambiguous type variable ‘b0’ arising from a use of ‘toString’
        prevents the constraint ‘(Printable b0)’ from being solved.
        Probable fix: use a type annotation to specify what ‘b0’ should be.
        These potential ...
-}


-- 4) Полиморфизм при объявлении представителей


class Eq a where
    (==),(/=) :: a -> a -> Bool
    x /= y = not (x == y)
    -- x == y = not (x /= y)


instance Eq Bool where
    True == True  = True
    False == False = True 
    _     == _     = False

instance (Eq a, Eq b) => Eq (a, b) where
    p1 == p2 = fst p1 == fst p2 && snd p1 == snd p2

-- instance Eq a => Eq [a] where
    -- ==

{-
    -- Задача 4

    Сделайте тип пары представителем класса типов Printable, 
    реализованного вами в предыдущей задаче, 
    обеспечив следующее поведение:

    GHCi> toString (False,())
    "(false,unit type)"
    GHCi> toString (True,False)
    "(true,false)"
    Примечание. Объявление класса типов Printable и представителей этого класса 
    для типов () и  Bool заново реализовывать не надо — они присутствуют в программе, вызывающей ваш код.
-}

instance (Printable a, Printable b) => Printable (a, b) where
    toString (a, b) = "(" ++ toString a ++ "," ++ toString b ++ ")"
