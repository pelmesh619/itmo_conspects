# itmo_conspects

**Конспекты по разным предметам первого потока ИСy27 университета ИТМО**

## III семестр (текущий)

### Физические основы компьютерных и сетевых технологий (лектор Музыченко Я. Б.)

[**Весь курс**](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_superconspect.pdf)

* [Лекция №1](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_2024_09_02.pdf)
* [Лекция №2](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_2024_09_09.pdf)
* [Лекция №3](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_2024_09_16.pdf)
* Лекция №4 - отменилась

### Теория вероятности (лектор Блаженов А. В.)

[**Весь курс**](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_superconspect.pdf)

* [Лекция №1](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_2024_09_03.pdf)
* [Лекция №2](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_2024_09_10.pdf)
* [Лекция №3](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_2024_09_17.pdf)
* [Лекция №4](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_2024_09_24.pdf)

### Базы данных (лектор Маятин А. В.)

[**Весь курс**](databases/databases_superconspect.md)

* [Лекция №1](databases/databases_2024_09_04.md)
* [Лекция №2](databases/databases_2024_09_12.md)
* [Лекция №3](databases/databases_2024_09_18.md)
* [Лекция №4](databases/databases_2024_09_26.md)

### Дополнительные главы высшей математики (лектор Далевская О. П.)

[**Весь курс**](https://pelmesh619.github.io/itmo_conspects/conspects/addchapters1/addchapters1_superconspect.pdf)

* [Лекция №1](https://pelmesh619.github.io/itmo_conspects/conspects/addchapters1/addchapters1_2024_09_06.pdf)
* [Лекция №3](https://pelmesh619.github.io/itmo_conspects/conspects/addchapters1/addchapters1_2024_09_20.pdf)

### Объектно-ориентированное программирование (лекторы Макаревич Р. Д., Круглов Г. Н.)

[**Весь курс**](oopcsharp/oopcsharp_superconspect.md)

* [Лекция №1](oopcsharp/oopcsharp_2024_09_07.md)
* [Лекция №2](oopcsharp/oopcsharp_2024_09_14.md)
* [Лекция №3](oopcsharp/oopcsharp_2024_09_21.md)
* [Лекция №4](oopcsharp/oopcsharp_2024_09_28.md)

## II семестр

### Математический анализ II (лектор Далевская О. П.)

[**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/calculus/calculus_superconspect.pdf)


### Специальные разделы высшей математики (лектор Далевская О. П.)

[**Весь курс с неполной программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/specsec/specsec_superconspect.pdf)

### Дискретная математика II (лектор Чухарев К. И.)

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

