# Базы данных

## Введение

Курс базы данных находится в цикле курсов "Управление данными" на направлении ИС

В отличие от математиков, перед которыми не стоят как таковые ограничения, у инженеров существуют ограничения, будь-то
бюджет или время. Поэтому инженеры вынуждены искать компромиссы между тремя главными параметрами: надежность,
производительность и безопасность.

В XX веке был сформулирован закон Мура, который прогнозировал увеличение числа транзисторов в два раза каждые два года,
но в 10-ых годах закон Мура перестал работать из-за физических ограничений. Далее появилось большое желание увеличивать
память, в следствие чего появились распределенные системы, но ограничениями
стала [теорема CAP](https://ru.wikipedia.org/wiki/%D0%A2%D0%B5%D0%BE%D1%80%D0%B5%D0%BC%D0%B0_CAP)

Британский учёный [Эдгар Кодд](https://ru.wikipedia.org/wiki/%D0%9A%D0%BE%D0%B4%D0%B4,_%D0%AD%D0%B4%D0%B3%D0%B0%D1%80) в
70-ых сформулировал основы теории **реляционных баз данных**, на основе которой созданы современные реляционные базы
данных

## Лекция 1. Что такое данные?

Выделяют 5 информационных процессов:

* Сбор
* Обработка
* Хранение
* Передача
* Представление

И эти процессы хотелось бы автоматизировать

До появления Computer Science как науки все эти процессы существовали в пределах небольших библиотеки, в которых книги
искались линейным или двоичным поисками. После этого библиотеки увеличивались, появились картотеки, каталоги.

Тем не менее определение информации так и не сформулировалось по многим философским вопросам: что такое информация?
Является ли информация атрибутом материи или энергии? Существует ли информация без человека? Поэтому информацию следует
воспринимать как триединство сигнала, данных и знаний.

В начале XX века Гёдель, целью которого была создать систему доказательств в математике, и, следовательно,
автоматизировать их, изобрел систему представления математических доказательств и доказал, что такая система не может
быть
полной ([теорема о неполноте](https://ru.wikipedia.org/wiki/%D0%A2%D0%B5%D0%BE%D1%80%D0%B5%D0%BC%D1%8B_%D0%93%D1%91%D0%B4%D0%B5%D0%BB%D1%8F_%D0%BE_%D0%BD%D0%B5%D0%BF%D0%BE%D0%BB%D0%BD%D0%BE%D1%82%D0%B5))

После Гёделя появился Джон фон Нейман, целью которого была представить информацию в конечном пространстве. Из этой идеи
вывелась архитектура фон Неймана, где числа представлялись в двоичном виде. В итоге получается, что данные - это
информация, которая закодирована заранее обговоренным способом:

<a name="data_definition"></a>

> **Данные** (ISO / IEC 2382:2015) - поддающееся многократной интерпретации представление информации в формализованном
> виде, пригодном для передачи, интерпретации или обработке

Из этого появляется потребность моделировать данные. Но у моделей появляются свои ограничения. Приведем пример таблицы
студентов:

| Студент | Группа | Дисциплина | Преподаватель | Аудитория | Время |
|---------|--------|------------|---------------|-----------|-------|
|         |        |            |               |           |       |
|         |        |            |               |           |       |

Поиск конкретного студента реализовать легко, но что если нам нужно иметь в виду несколько дисциплин для одного
студента? Приходит другая реализация:

| Студент | Группа | (Дисциплина1, ...) | (Дисциплина2, ...) |
|---------|--------|--------------------|--------------------|
|         |        |                    |                    |
|         |        |                    |                    |

Но в ней мы не сможем запросто составить расписание для какого-то преподавателя. Тогда приходит идея разделить на
несколько табличек для студентов:

| Номер студента | ФИО студента |
|----------------|--------------|
|                |              |

Для групп:

| Номер группы | Факультет группы |
|--------------|------------------|
|              |                  |

И для предметов:

| Номер дисциплины | Название дисциплины | Преподаватель |
|------------------|---------------------|---------------|
|                  |                     |               |

В этом случае повышается целостность данных, но уменьшается производительность системы, и в итоге мы не сможем найти
идеального решения
