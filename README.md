## Функциональное программирование на [Haskell](https://www.haskell.org/) by [Stepik](https://stepik.org/course/75/info)

Данный  репозиторий содержит резюме ключевых идей из курса с примерами кода, а также решения практических задач.
### 1. Введение
- [1.1 Intro](./src/Intro.hs)
- [1.2 Functions](./src/Functions.hs)
- [1.3 Operatiors](./src/Operators.hs)
- [1.4 Basic Types](./src/BasicTypes.hs)
- [1.5 Recursion](./src/Recursion.hs)
- [1.6 Локальные связывания и правила отступов](./src/Binding.hs)

### 2. Основы программирования
- [2.1 Параметрический полиморфизм](./src/Polymorphism.hs)
- [2.2 Параметрический полиморфизм](./src/Polymorphism2.hs)
- [2.3 Классы типов](./src/TypeClasses.hs)
- [2.4 Стандартные классы типов](./src/StandardTypeClasses.hs)
- [2.5 Нестрогая семантика](./src/Semantics.hs)
- [2.6 Модули и компиляция](./src/Modules.hs)

### 3 Списки
...

### 4 Типы данных
...

### 5 Монады
... 

### Docs:
* [Текущий стандарт](https://www.haskell.org/onlinereport/haskell2010/)
* [hoogle](https://hoogle.haskell.org/)
* [ассоциативность и приоритет операторов](https://rosettacode.org/wiki/Operator_precedence?mobile_internal_deeplink=true&from_mobile_app=true#Haskell) 


### Useful links:
* [лекции + слайды](http://mit.spbau.ru/sewiki/index.php/%D0%A4%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D0%BE%D0%BD%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B5_%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5_2015) by Москвин ДН
* лекции [youtube](https://www.youtube.com/playlist?list=PLlb7e2G7aSpRDR44HMNqDHYgrAOPp7QLr)
* [narod.ru](http://learnhaskellforgood.narod.ru/learnyouahaskell.com/chapters.html)
* [youtube](https://www.youtube.com/watch?v=UIUlFQH4Cvo&list=PLoJC20gNfC2gpI7Dl6fg8uj1a-wfnWTH8) Erik Meijer
* [система вывода типов](https://ru.wikipedia.org/wiki/%D0%92%D1%8B%D0%B2%D0%BE%D0%B4_%D1%82%D0%B8%D0%BF%D0%BE%D0%B2#%D0%90%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC_%D0%A5%D0%B8%D0%BD%D0%B4%D0%BB%D0%B8_%E2%80%94_%D0%9C%D0%B8%D0%BB%D0%BD%D0%B5%D1%80%D0%B0)
* численное интегрирование, [метод трапеций](https://ru.wikipedia.org/wiki/%D0%A7%D0%B8%D1%81%D0%BB%D0%B5%D0%BD%D0%BD%D0%BE%D0%B5_%D0%B8%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5#%D0%9C%D0%B5%D1%82%D0%BE%D0%B4_%D1%82%D1%80%D0%B0%D0%BF%D0%B5%D1%86%D0%B8%D0%B9)


### Docker
* образ GHC-7.8 на [docker hub]( https://hub.docker.com/r/alanz/haskell-ghc-7.8-64/dockerfile)
* команда для запуска:
```bash
docker run -it -v $HOME/<your folder>:/home/ alanz/haskell-ghc-7.8-64
```
