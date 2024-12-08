## Лекция 11. NoSQL

На прошлой лекции разбирали, что такое распределенные хранилища. Вспомним, зачем мы их так хотели:

* **Производительность** - несколько маленьких узлов работают быстрее, чем один большой
* **Надежность** - с помощью репликаций мы можем сделать так, чтобы система работала после сбоя какого-то узла
* **Модульность** - разбиваем громоздкую систему на небольшие модули
* **Локальная автономность** - данные расположены там, где они чаще всего нужны

Минусы:

* **Сложность** - сложно согласовать все эти узлы
* **Стоимость** - люди, занимающиеся этим, стоят дорого
* **Защита** - создать отдельный "контур" безопасности для распределенного хранилища почти невозможно
* **Контроль целостности данных** - в том числе сложность распределенных транзакций

---

Но что же привело к проблеме NoSQL?

1. **Большие данные** (Big Data)

    В наше время возрастает прирост появления данных. По оценкам к 2030 году количество всех созданных данных будет размером в 100 зеттабайт (10^23 байт)

    Сейчас же 47% всех данных - это сфера развлечений, 23% всех данных имеет _потенциальную_ ценность, а 3% доступных нам данных используются

    В связи с этим появилось такое являние, как датамайнинг

2. **Взаимосвязность данных**

    Раньши книги были в каком-то смысле автономны; потом в книгах появились ссылки на другие книги - так называемые явные связи.

    Помимо этих есть неявные связи, например, камеры в супермаркете могут отследить, какие товары купил какой-либо покупатель

    <!-- wtf пример -->

3. **Слабоструктурированная информация**

    Пример: вначале маркетплейс продавал телевизоры, потом начал продавать планшеты. В связи с этим мы не можем создать базу данных с какой-то жесткой структурой, потому что товары могут обладать разные свойствами
    
4. **Архитектура информационных систем**

    С появлением микросервисов, у которых чаще всего стек технологий отличается друг от друга, появились гетерогенные хранилища, использующие разные СУБД

---

Считается, что есть 4 свойства, определяющие NoSQL решение:

1. No SQL - не использует язык SQL для запросов к себе

    Однако современное развитие NoSQL-языков привело к похожести на SQL😯

2. Schemaless - неструктурность

    Допустим, у студентов есть 15 атрибутов и появляется студент с 16-ым атрибутом. С помощью Schemaless мы можем менять количество атрибутов или расширять домен значения

3. Aggregates - аггрегированность

    Целью SQL и реляционных БД была декомпозиция отношений с целью нормализации и сохранения целостности

    Aggregates гласит, что давайте хранить сразу аггрегированные данные. Тем самым мы улучшим производительность в жертву целостности. При правильном использовании мы можем достичь баланса целостности и скорости

    Получается, что с одной стороны получаем быстроту одних запросов (например, чтения данных), с другой - медленность других

4. Weak ACID - не делаем ACID

    Все свойства ACID выполнить почти невозможно, поэтому проще допустить где-то ошибку в базе данных и потом извиниться перед клиентом за овербукинг

    Вместо ACID появилась модель BASE:

    * Вasic Availability - базовая доступность: хранилище обязано ответить через гарантированный определенный промежуток времени

    <!-- есть ли товар? нету? скажи есть, потом разберемся -->

    * Soft state - гибкое состояние: допускаем, что в какой-то момент данные будут не целостны
    * Evential consistency - итоговая консистентность: в конечном счете, целостность данных соблюдется

    В итоге, в NoSQL базах данных существует некий алгоритм, который в фоновом режиме согласует все противоречия и исправляет нарушения целостности данных


Здесь же при выборе СУБД надо понимать, что больше всего подходит под задачи проекта, и найти баланс между производительностью и надежностью

На следующей лекции будет рассмотрено, почему распределенные хранилища невозможны из-за CAP-теоремы

