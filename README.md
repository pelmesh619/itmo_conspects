# itmo_conspects

**Конспекты по разным предметам первого потока ИСy27 университета ИТМО**

## III семестр (текущий)

### Физические основы компьютерных и сетевых технологий

* [Лекция №1](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_2024_09_02.pdf)

### Теория вероятности

* [Лекция №1](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_2024_09_03.pdf)

## II семестр

### Математический анализ II

[**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/calculus/calculus_superconspect.pdf)


### Специальные разделы высшей математики

[**Весь курс с неполной программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/specsec/specsec_superconspect.pdf)

### Дискретная математика II

[**Почти весь курс с неполной программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/dismath/dismath_superconspect.pdf)

[**Шпаргалка по Комбинаторике**](https://pelmesh619.github.io/itmo_conspects/conspects/dismath/dismath_cheatsheet_combinatorics.pdf)

[**Шпаргалка по Рекуррентностям и Производящим функциям**](https://pelmesh619.github.io/itmo_conspects/conspects/dismath/dismath_cheatsheet_recurrences.pdf)

### Алгоритмы и Структуры Данных I-II

Почти все алгоритмы из курса и некоторые пояснения к ним есть в моем другом репозитории: [pelmesh619/algorithm_archives](https://github.com/pelmesh619/algorithm_archives)



## TODO

Буду рад, если вы поможете мне:

* Сделать картинки примеров (желательно какие-нибудь приличные и красивые, из графкалькуляторов)

* Проверить на очепятки и неточности

## PS

linter.py автоматически добавляет форматирование (добавляет \displaystyle, где надо и т.д.), создает новый файл в ./linted/ и рендерит .pdf в директорию ./conspects/ при помощи pdflatex:

```bash
python linter.py ./directory/tex_file.tex
```

В основном, я делаю пдфки так (мне было проще написать скрипт на питоне, чем загуглить, как сделать везде \displaystyle)

superconspect.py автоматически "соединяет" все .tex файлы конспектов лекций из данной директории в один файл, добавляет содержание и делает то, что делает linter.py

```bash
python superconspect.py ./directory
```

compile_all.py рендерит все .tex в данной директории (в том числе создает суперконспект) (полезно, если что-то поменял глобально и нужно все перерендерить)

```bash
python compile_all.py ./directory
```

for contact write me: [t.me/pelmeshke](https://t.me/pelmeshke)

## Extra

### A Playful Production Process

Конспект книги "A Playful Production Process for Game Designers (and Everyone)"
("Игровая разработка без боли и кранчей. Как выжить в игровой индустрии и сохранить вдохновение" в русском издательстве)
об игровом дизайне и продакшене от автора и гейм-дизайнера Ричарда Лемаршана.

[**A Playful Production Process**](aplayfulproductionprocess/aplayfulproductionprocess_superconspect.md) (закончен на ~25%)

