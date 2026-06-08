## Лекция 4. Шаблоны GRASP

<!-- Лектор - Круглов Г. Н. -->

Шаблоны GRASP (General Responsibility Assignment Software Principles, Общие принципы распределения ответственности в ПО) - шаблоны, которые решают задачи назначения ответственности программных компонентов

Шаблоны были описаны Крэгом Ларманом в книге "Применение UML и шаблонов проектирования" в 1997 году. Каждый шаблон помогает решить конкретную задачу, возникающую при проектировании ПО, всего их девять:

1. Информационный эксперт (Information Expert)
2. Создатель (Creator)
3. Контроллер (Controller)
4. Слабое зацепление (Low Coupling)
5. Сильная связность (High Cohesion)
6. Перенаправление (Indirection)
7. Полиморфизм (Polymorphism)
8. Устойчивость к изменениям (Protected Variations)
9. Чистая выдумка (Pure Fabrication)

### Информационный эксперт

**Информационный эксперт** (Information Expert) - это принцип, согласно которому обязанность (то есть действие с данными) назначается классу, который обладает всей необходимой информацией для её выполнения

Приведем пример заказа и создателя чека:

```csharp
public record OrderItem(int Id, decimal Price, int Quantity);

public class Order
{
    private readonly List<OrderItem> _items;

    public Order()
    {
        _items = new List<OrderItem>();
    }

    public IReadOnlyCollection<OrderItem> Items => _items;
}

public record Receipt(decimal TotalCost, DateTime Timestamp);

public class ReceiptService
{
    public Receipt CalculateReceipt(Order customer)
    {
        var totalCost = customer.Items
            .Sum(order => order.Price * order.Quantity);
        var timestamp = DateTime.Now;
        return new Receipt(totalCost, timestamp);
    }
}
```

В этом примере при составлении чека мы подсчитываем стоимость позиции заказа `order => order.Price * order.Quantity` внутри сервиса `ReceiptService`

Здесь нет _информационного эксперта_ (обязанность расчета суммы переложена на `ReceiptService`, а не на тех, кто обладает информацией), и из-за этого появляются проблемы:

* Нарушается принцип единственной ответственности
* Появляется либо много одинакового кода (например, если появится другой `ReceiptService`), либо нелогичная связь между сущностями
* Усложнённое тестирование

Исправим пример:

```csharp
public record OrderItem(int Id, decimal Price, int Quantity)
{
    public decimal Cost => Price * Quantity;
}

public class Order
{
    private readonly List<OrderItem> _items;
    public Order()
    {
        _items = new List<OrderItem>();
    }
    public IReadOnlyCollection<OrderItem> Items => _items;
    public decimal TotalCost => _items.Sum(x => x.Cost);
}

public record Receipt(decimal TotalCost, DateTime Timestamp);

public class ReceiptService
{
    public Receipt CalculateReceipt(Order customer)
    {
        var totalCost = customer.TotalCost;
        var timestamp = DateTime.Now;
        return new Receipt(totalCost, timestamp);
    }
}
```

Здесь объект заказа `Order` подсчитывает сумму заказа и формирует объект чека `Receipt`. Объекты `Order` и `OrderItem` выступают в качестве _информационных экспертов_ - каждый знает то, что им нужно для выполнения конкретного метода

### Создатель

**Создатель** (Creator) - шаблон, который решает проблему ответственности за создание используемых объектов. Если объект класса `B` содержит, активно использует объекты класса `A`, а также обладает всеми данными для их создания, то объект класса `B` должен быть _создателем_ объектов класса `A`

Приведем пример: здесь сервис заказа `OrderService` создает позицию заказа `OrderItem`, которая передается в объект заказа `Order`

```csharp
public class Order
{
    private readonly List<OrderItem> _items;

    public Order AddItem(OrderItem item)
    {
        _items.Add(item);
        return this;
    }
}

public class OrderService
{
    public Order CreateDefaultOrder()
    {
        var order = new Order()
            .AddItem(new OrderItem(1, 100, 1))
            .AddItem(new OrderItem(2, 1000, 3));
        return order;
    }
}
```

Можно это исправить так: передадим аргументы к позиции заказа, чтобы в объекте заказа он создавался

```csharp
public class Order
{
    private readonly List<OrderItem> _items;

    public Order AddItem(int id, decimal price, int quantity)
    {
        _items.Add(new OrderItem(id, price, quantity));
        return this;
    }
}

public class OrderService
{
    public Order CreateDefaultOrder()
    {
    var order = new Order()
        .AddItem(1, 100, 1)
        .AddItem(2, 1000, 3);
    return order;
    }
}
```

Недостатки _создателя_:

* Появляется неявная зависимость между конструктором `OrderItem` и методом создания `AddItem`: если мы захотим в `OrderItem` добавить новый аргумент, то будет трудно везде изменять метод
* Если _создателю_ требуются данные, которые не являются его естественной ответственностью, это может привести к нарушению _принципа единственной ответственности_

### Контроллер

Контроллер - переходник между моделями бизнес-логики и моделями представления

Различают 3 вида контроллеров:

1. Use-case Controller - инкапсулирует один метод (чаще всего мало и неудобно)

2. Use-case Group Controller - инкапсурирует группу методов из одного класса

3. Facade Controller - инкапсулирует набор методов из разных классов (чаще всего громоздко)

### Слабое зацепление

> Coupling (зацепление) - мера зависимости модулей друг между другом

Сильное зацепление (High coupling) - это плохо

Например: есть класс `DataProvider`, методы которого выводят температуру в конкретном месте и используемую сборщиком мусора память. Логически эти данные не связаны, поэтому лучше всего ослабить их зацепление - создать 2 отдельных класса для вывода температуры и для вывода памяти

### Сильная связность

> Cohesion (связность) - мера логической соотнесенности логики в рамках модуля

Слабая связность (Low cohesion) - это плохо

Пример: сделаем класс `DataMonitor`, который отображает нужную метрику от `DataProvider` в зависимости от переданного `enum MetricType`; так как мы работаем с перечислением, то не избежать использования `switch`, а значит код будет трудно расширять - нарушается OCP

В этом случае создадим интерфейс для `DataProvider`, реализации которого будут использоваться в `DataMonitor`

### Перенаправление

> Object Indirection (Объектное перенаправление) - любое взаимодействие с данными, поведениями, модулями, реализованное не напрямую, а через какой-либо агрегирующий их объект

> Interface Segregetion (Разделение интерфейса) - любое взаимодействие с данными, поведениями, модулями, реализованное не напрямую, а через какой-либо интерфейс

Перенаправление тесно связано с ISP и DIP. Принцип перенаправления используется в архитектуре Model-View-Controller: бизнес-логика из Model общается с сущностями представления View через контроллер Controller

### Полиморфизм

**Полиморфизм** (Polymorphism) - принцип, согласно которому поведение системы может варьироваться в зависимости от типа объекта, при этом сам код обращается к единому интерфейсу. _Полиморфизм_ позволяет избежать громоздких условных конструкций `if`/`switch` и делегирует выбор конкретного поведения самим объектам. Вместо того чтобы проверять тип объекта и вручную выбирать нужное действие, объявляется абстрактный метод или метод интерфейса, в реализации которого в конкретных классах описано желаемое поведение

![кря](images/oopcsharp_2024_09_28_1.png)

### Устойчивость к изменениям

Protected variations (Устойчивость к изменениям) подразумевает о поиске условий, при которых инвариант объекта может сломаться; в этом случае применяется сокрытие и вытеснение доступа к полям через интерфейс

### Чистая выдумка

Pure fabrication (Чистая выдумка) подразумевает создание выдуманной сущности, которая не входит в моделирование бизнес-логики. Чаще всего это инфраструктурные модули (логгер, доступ к базе данных, т.д.). Такие типы не рекомендуется вносить в доменную модель
