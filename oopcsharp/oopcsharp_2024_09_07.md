# Объектно-ориентированное программирование

Все презентации к лекциям можно найти по ссылке [github.com/is-oop-y27](https://github.com/is-oop-y27)

## Лекция 1. Основы ООП

В самом начале развития Computer Science код выглядел как-то так:

```asm
VAR i
SET i 1
PRINT i
INC i
JIFLS i 10 2
```

Это было очень неудобно, поэтому придумали **структурное программирование**:

```cs
for (var i = 1; i < 10; i++) 
{
    Console.WriteLine(i);
}
```

Но при увеличении кода стало неудобно и это, поэтому придумали функции и **процедурное программирование** - разбиение кода на маленькие независимые участки. Но вскоре появилась надобность разделять бизнес-логику, данные и сохранять инвариант данных

> Инвариант данных - набор корректных состояний данных, определяемый набором бизнес-требований к этим данным

Поэтому появилась парадигма **объектно-ориентированное программирование**

### Концепции ООП

* **Инкапсуляция** - объединение данных и их поведения
* **Сокрытие** - управление доступа к полям класса, тем самым сохранение инварианта
* **Композиция** - объединение различного поведения в один объект

Агрегация - объект получает уже созданные данные
Ассоциация - объект сам управляет циклом жизни своих данных (выделяет и освобождает память для них)

* Полиморфизм

Концепция полиморфизма заключается в более абстрактном понимании объектов 

> Полиморфизм подтипов - отделение абстракции от реализации, позволяющее пользователю прозрачно использовать различные реализации поведений

Примером абстракции может быть объект для доступа к базе данных - мы можем создать классы для доступа к базам данным SQL и NoSQL, которые имеют одни и те же публичные методы с одинаковыми аргументами - и тогда мы приходим к понятию интерфейса, который описывает методы у классов

> Реализация (наследование поведений): в C# реализовывать интерфейсы могут как классы, так и структуры. Говорят, что тип реализует интерфейс (класс `Point` реализует интерфейс `IPoint`)

> Наследование реализаций: используются классы, в C# одна структура не может быть унаследована от другой, либо от класса. Говорят, что класс является наследником другого класса, либо же его подклассом (класс `Cat` является наследником класса `Animal`)

При этом наследники могут переопределять методы класса/интерфейса и определять новые

> Объект - набор атрибутов и поведений, реализаций и данные которого сокрыты от конечного пользователя объекта. Также абстракция, представляющая какой-то объект моделируемой предметной области

### Выводы

* Парадигма ООП представляет собой концепцию объединения данных и логики, их обрабатывающей
* Сокрытие принуждает пользователей использовать поведения, соответствующие бизнес-правилам
* Локализация изменений данных позволяет упростить поддержание их инварианта

