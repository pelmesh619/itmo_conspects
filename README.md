# conspects

### Конспекты по разным предметам первого потока ИСy27 университета ИТМО

## Математический анализ II

[**Весь курс**](out/calculus_superconspect.pdf)

* [Лекция №1](out/calculus_2024_02_07.pdf)
* [Лекция №2](out/calculus_2024_02_14.pdf) - STILL [TODO](calculus/calculus_2024_02_14.tex)
* [Лекция №3](out/calculus_2024_02_21.pdf)
* [Лекция №4](out/calculus_2024_02_28.pdf)
* [Лекция №5](out/calculus_2024_03_06.pdf)
* [Лекция №6](out/calculus_2024_03_13.pdf)
* [Лекция №7](out/calculus_2024_03_20.pdf)
* [Лекция №8](out/calculus_2024_03_27.pdf)
* [Лекция №9](out/calculus_2024_04_03.pdf)
* [Лекция №10](out/calculus_2024_04_10.pdf)
* [Лекция №11](out/calculus_2024_04_17.pdf)
* [Лекция №12](out/calculus_2024_04_24.pdf)
* Лекция №13 (был праздник)

## Специальные разделы высшей математики

[**Весь курс**](out/specsec_superconspect.pdf)

* [Лекция №1](out/specsec_2024_02_09.pdf)
* Лекция №2 - [TODO](specsec/specsec_2024_02_16.tex)
* Лекция №3 (был праздник)
* [Лекция №4](out/specsec_2024_03_01.pdf)
* Лекция №5 (был праздник)
* [Лекция №6](out/specsec_2024_03_15.pdf)
* [Лекция №7](out/specsec_2024_03_22.pdf)
* [Лекция №8](out/specsec_2024_03_29.pdf)
* [Лекция №9.1](out/specsec_2024_04_03.pdf)
* [Лекция №9.2](out/specsec_2024_04_05.pdf)
* [Лекция №10](out/specsec_2024_04_12.pdf)
* [Лекция №11.1](out/specsec_2024_04_17.pdf)
* [Лекция №11.2](out/specsec_2024_04_19.pdf)
* [Лекция №12](out/specsec_2024_04_26.pdf)
* [Лекция №13](out/specsec_2024_05_03.pdf)


## Дискретная математика II

[**Весь курс**](out/dismath_superconspect.pdf)

* [Лекция №12](out/dismath_2024_04_23.pdf)
* [Лекция №13](out/dismath_2024_04_30.pdf)
* Лекция №14 (внезапно отменилась)

(исходники лучше смотрите в ./linted/)


## TODO

Буду рад, если вы поможете мне:

* Сделать картинки примеров (желательно какие-нибудь приличные и красивые, из графкалькуляторов)

* Проверить на очепятки и неточности

* Сделать конспекты первых лекций второго семестра

## PS

linter.py автоматически добавляет форматирование (добавляет \displaystyle, где надо и т.д.) и рендерит .pdf в директорию ./out/ при помощи pdflatex, запускаем так: 

```bash
python linter.py tex_file.tex
```

superconspect.py автоматически "соединяет" все .tex файлы в данной директории в один файл, добавляет содержание и рендерит суперконспект👆

compile_all.py рендерит все .tex в данной директории (в том числе создает суперконспект)



for contact write me: [t.me/pelmeshke](https://t.me/pelmeshke)
