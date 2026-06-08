## Лекция 4. Шаблоны GRASP

<!-- Лектор - Круглов Г. Н. -->

GRASP (General Responsibility Assignment Software Principles) -  общие принципы распределения ответственности в ПО

GRASP основывается на мыслях из SOLID, в него входят 9 принципов

### Informational expert

> Информация должна отбрабатываться там, где она содержится

Приведем пример заказа и создателя чека:

```csharp
public record OrderItem(
    int Id,
    decimal Price,
    int Quantity);
public class Order
{
    private readonly List<OrderItem> _items;
    public Order()
    {
        _items = new List<OrderItem>();
    }
    public IReadOnlyCollection<OrderItem> Items => _items;
}
public record Receipt(
    decimal TotalCost,
    DateTime Timestamp);
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

В этом примере при составлении чека мы подсчитываем стоимость позиции заказа - `order => order.Price * order.Quantity`

Почему не использовать информационного эксперта:

* это нарушение SRP
* проблемы с переиспользованием: либо много одинакового кода, либо нелогичная связь между сущностями
* усложнённое тестирование

Исправим пример:

```csharp
public record OrderItem(
    int Id,
    decimal Price,
    int Quantity)
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

public record Receipt(
    decimal TotalCost,
    DateTime Timestamp);
    
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

Здесь объект заказа сам подсчитывает стоимость заказа - на нем лежит эта ответственность

### Creator

> Ответственность за создание используемых объектов должна лежать на типах, их использующих

Приведем пример: здесь сервис заказа создает позицию заказа, которая передается в объект заказа

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
    public Order AddItem(
        int id,
        decimal price,
        int quantity)
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

Недостатки Creator:

* Появляется неявная зависимость между конструктором и методом создания: если мы захотим в OrderItem добавить новый аргумент, будет больно везде изменять
* Необходимость обладания всеми данными может привести к нарушению SRP создателем
* Пересборка объектов плохо влияет производительность

### Controller

Контроллер - переходник между моделями бизнес-логики и моделями представления

Различают 3 вида контроллеров:

1. Use-case Controller - инкапсулирует один метод (чаще всего мало и неудобно)

2. Use-case Group Controller - инкапсурирует группу методов из одного класса

3. Facade Controller - инкапсулирует набор методов из разных классов (чаще всего громоздко)

### Low coupling

> Coupling (зацепление) - мера зависимости модулей друг между другом

Сильное зацепление (High coupling) - это плохо

Например: есть класс `DataProvider`, методы которого выводят температуру в конкретном месте и используемую сборщиком мусора память. Логически эти данные не связаны, поэтому лучше всего ослабить их зацепление - создать 2 отдельных класса для вывода температуры и для вывода памяти

### High cohesion

> Cohesion (связность) - мера логической соотнесенности логики в рамках модуля

Слабая связность (Low cohesion) - это плохо

Пример: сделаем класс `DataMonitor`, который отображает нужную метрику от `DataProvider` в зависимости от переданного `enum MetricType`; так как мы работаем с перечислением, то не избежать использования `switch`, а значит код будет трудно расширять - нарушается OCP

В этом случае создадим интерфейс для `DataProvider`, реализации которого будут использоваться в `DataMonitor`

### Indirection

> Object Indirection (Объектное перенаправление) - любое взаимодействие с данными, поведениями, модулями, реализованное не напрямую, а через какой-либо агрегирующий их объект

> Interface Segregetion (Разделение интерфейса) - любое взаимодействие с данными, поведениями, модулями, реализованное не напрямую, а через какой-либо интерфейс

Перенаправление тесно связано с ISP и DIP. Принцип перенаправления используется в архитектуре Model-View-Controller: бизнес-логика из Model общается с сущностями представления View через контроллер Controller

### Polymorphism

пу-пу-пу🦆

![кря](images/oopcsharp_2024_09_28_1.png)

### Protected variations

Protected variations (Устойчивость к изменениям) подразумевает о поиске условий, при которых инвариант объекта может сломаться; в этом случае применяется сокрытие и вытеснение доступа к полям через интерфейс

### Pure fabrication - Чистая выдумка

Pure fabrication (Чистая выдумка) подразумевает создание выдуманной сущности, которая не входит в моделирование бизнес-логики. Чаще всего это инфраструктурные модули (логгер, доступ к базе данных, т.д.). Такие типы не рекомендуется вносить в доменную модель
