# itmo_conspects

**Конспекты по разным предметам первого потока ИСy27 университета ИТМО**

Если нашли какую-то ошибку - напишите мне ([t.me/pelmeshke](https://t.me/pelmeshke)) или сделайте [форк](https://github.com/pelmesh619/itmo_conspects/fork) с исправлением и пулл реквест

[![Спросить DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/pelmesh619/itmo_conspects)

## [IV семестр](meta/IV.md)

* Проектирование баз данных (лекторы Мацнев Н. И., Самигуллин Р. Ф., Карчевский А. Д.)

    [**Весь курс**](https://pelmesh619.github.io/itmo_conspects/dbdesign/dbdesign_superconspect.html)

* История российской науки и техники (лектор Васильев А. В.)
    
    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/sathistory/sathistory_superconspect.html)

* Технологии программирования на Java (лекторы Макаревич Р. Д., Сомов А. В.)

    [**Весь курс**](https://pelmesh619.github.io/itmo_conspects/javatech/javatech_superconspect.html)

* Дополнительные главы высшей математики II (лектор Далевская О. П.)

    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/addchapters2/addchapters2_superconspect.pdf)

* Физические основы компьютерных и сетевых технологий II (лектор Герт А. В.)

    [**Весь курс**](https://pelmesh619.github.io/itmo_conspects/conspects/physics2/physics2_superconspect.pdf)

* Математическая статистика (лектор Блаженов А. В.)

    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/mathstat/mathstat_superconspect.pdf)

* Операционные системы (лектор Маятин А. В.)

    [**Весь курс**](https://pelmesh619.github.io/itmo_conspects/opersys/opersys_superconspect.html)

## [III семестр](meta/III.md)

* Физические основы компьютерных и сетевых технологий (лектор Музыченко Я. Б.)

    [**Весь курс**](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_superconspect.pdf)

    Решение задач: [Решение задач №6](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_6.pdf), [Решение задач №7](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_7.pdf), [Решение задач №8](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_8.pdf), [Решение задач №9](https://pelmesh619.github.io/itmo_conspects/conspects/physics1/physics1_homework_9.pdf)

* Теория вероятности (лектор Блаженов А. В.)

    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/probtheory/probtheory_superconspect.pdf)

* Базы данных (лектор Маятин А. В.)

    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/databases/databases_superconspect.html)

* Дополнительные главы высшей математики (лектор Далевская О. П.)

    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/addchapters1/addchapters1_superconspect.pdf)

    [Карточки для Anki](https://github.com/pelmesh619/itmo_conspects/releases/tag/anki.addchapters1.v1.1)

* Объектно-ориентированное проектирование и программирование (лекторы Макаревич Р. Д., Круглов Г. Н.)

    [**Весь курс**](https://pelmesh619.github.io/itmo_conspects/oopcsharp/oopcsharp_superconspect.html)

## [II семестр](meta/II.md)

* Математический анализ II (лектор Далевская О. П.)

    [**Весь курс с программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/calculus/calculus_superconspect.pdf)

* Специальные разделы высшей математики (лектор Далевская О. П.)

    [**Весь курс с неполной программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/specsec/specsec_superconspect.pdf) [✨Remastered]

* Дискретная математика II (лектор Чухарев К. И.)

    [**Почти весь курс с неполной программой экзамена**](https://pelmesh619.github.io/itmo_conspects/conspects/dismath/dismath_superconspect.pdf)

    [**Шпаргалка по Комбинаторике**](https://pelmesh619.github.io/itmo_conspects/conspects/dismath/dismath_cheatsheet_combinatorics.pdf)

    [**Шпаргалка по Рекуррентностям и Производящим функциям**](https://pelmesh619.github.io/itmo_conspects/conspects/dismath/dismath_cheatsheet_recurrences.pdf)

## Другие заметки

* Алгоритмы и Структуры Данных I-II

    Почти все алгоритмы из курса и некоторые пояснения к ним есть в моем другом репозитории: [pelmesh619/algorithm_archives](https://github.com/pelmesh619/algorithm_archives)



## TODO

Буду рад, если вы поможете мне:

* Сделать картинки примеров (желательно какие-нибудь приличные и красивые, из графкалькуляторов)

* Проверить на очепятки и неточности

* Рефактор второго сема физики + побольше картинок (миссия невыполнима)

## PS

Для компиляции tex-файла используется скрипт `linter.py`. Он:

* автоматически добавляет во всех $-выражения `\displaystyle` там, где есть дроби, суммы, интегралы для лучшего отображения (область применения можно регулировать, после `%nodisplay` вставка не производится; после `%yesdisplay` вставка производится)
* добавляет в начало специфичную для тему преамбулу из файла `directory/__preamble.sty`
* сохраняет промежуточный tex-файл в `./linted/directory/tex_file.tex`
* компилирует при помощи `pdflatex` pdf-файл в директорию `./conspects/directory`

```bash
python linter.py ./directory/tex_file.tex
```

Рендеринг лучше делать прямо из `itmo_conspects/`, чтобы была поддержка преамбулы. В таком случае пути для картинок будут выглядеть так: `directory/images/...`

Чтобы сделать конспект всего курса, используется `superconspect.py`. Для tex-конспектов он:

* соединяет все tex-файлы (за исключением `directory_superconspect.tex`)
* добавляет содержание
* сохраняет в файл `directory_superconspect.tex`
* компилирует его с помощью `linter.py`

```bash
python superconspect.py ./directory
```

Для md-конспектов он соединяет все md-файлы, добавляет содержание и сохраняет в `directory_superconspect.md`

`compile_all.py` рендерит все .tex в данной директории, а также вызывает `superconspect.py` для директории 

```bash
python compile_all.py ./directory
```

`simple_tex.py` создан для упрощенных tex-файлов:

```tex
$subject$=left header
$date$=central header
$teacher$=right header

Уравнение Эйнштейна: $h \nu = \frac{m v^2}{2} + A$
```

Делает обертку в `\begin{document}\end{document}`, добавляет колонтитулы (оч бесило делать отступы)

## Extra

### Anki

Anki - приложение для запоминания материала с помощью карточек. Гайд установки - [*тык*](https://pelmesh619.github.io\itmo_conspects\Add-Chapters-Cards\GUIDE.html)

Пока что доступны карточки по [дополнительным главам высшей математики](https://github.com/pelmesh619/itmo_conspects/tree/main/Add-Chapters-Cards) (числовые, функциональные ряды, ряды Фурье, интеграл Фурье)

### A Playful Production Process

Конспект книги "A Playful Production Process for Game Designers (and Everyone)"
("Игровая разработка без боли и кранчей. Как выжить в игровой индустрии и сохранить вдохновение" в русском издательстве)
об игровом дизайне и продакшене от автора и гейм-дизайнера Ричарда Лемаршана.

[**A Playful Production Process**](https://pelmesh619.github.io/itmo_conspects/aplayfulproductionprocess/aplayfulproductionprocess_superconspect.html) (закончен на ~25%)

