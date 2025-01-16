# itmo_conspects

**Конспекты по разным предметам первого потока ИСy27 университета ИТМО**

Если нашли какую-то ошибку - напишите мне ([t.me/pelmeshke](https://t.me/pelmeshke)) или сделайте [форк](https://github.com/pelmesh619/itmo_conspects/fork) с исправлением и пулл реквест

## [III семестр](meta/III.md) (текущий)

### Физические основы компьютерных и сетевых технологий (лектор Музыченко Я. Б.)

[**Весь курс**](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_superconspect.pdf)

Решение задач: [Решение задач №6](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_6.pdf), [Решение задач №7](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_7.pdf), [Решение задач №8](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_8.pdf), [Решение задач №9](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_9.pdf)

### Теория вероятности (лектор Блаженов А. В.)

[**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_superconspect.pdf)

### Базы данных (лектор Маятин А. В.)

[**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/databases/databases_superconspect.html)

### Дополнительные главы высшей математики (лектор Далевская О. П.)

[**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/addchapters1/addchapters1_superconspect.pdf)

Карточки для Anki - [https://github.com/pelmesh619/itmo_conspects/tree/main/Add-Chapters-Cards](https://github.com/pelmesh619/itmo_conspects/tree/main/Add-Chapters-Cards)

### Объектно-ориентированное проектирование и программирование (лекторы Макаревич Р. Д., Круглов Г. Н.)

[**Весь курс**](https://pelmesh619.github.io/itmo_conspects/oopcsharp/oopcsharp_superconspect.html)

### История российской науки и техники (лектор Васильев А. В.)

[**Весь курс**](https://pelmesh619.github.io/itmo_conspects/sathistory/sathistory_superconspect.html)

## [II семестр](meta/II.md)

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


## Extra

### Anki

Anki - приложение для запоминания материала с помощью карточек. Гайд установки - [*тык*](https://pelmesh619.github.io\itmo_conspects\Add-Chapters-Cards\GUIDE.html)

Пока что доступны карточки по [дополнительным главам высшей математики](https://github.com/pelmesh619/itmo_conspects/tree/main/Add-Chapters-Cards) (числовые, функциональные ряды, ряды Фурье, интеграл Фурье)

### A Playful Production Process

Конспект книги "A Playful Production Process for Game Designers (and Everyone)"
("Игровая разработка без боли и кранчей. Как выжить в игровой индустрии и сохранить вдохновение" в русском издательстве)
об игровом дизайне и продакшене от автора и гейм-дизайнера Ричарда Лемаршана.

[**A Playful Production Process**](https://pelmesh619.github.io/itmo_conspects/aplayfulproductionprocess/aplayfulproductionprocess_superconspect.html) (закончен на ~25%)

