## Лекция 5. Порождающие паттерны

<!-- Лектор - Круглов Г. Н. -->

В ходе разработки возникают классы, объекты которых создаются уж слишком тяжело и громоздко. Для этих случаев
разрабатывают другие методы/объекты, за которыми лежит ответственность за их созданием

Такие объекты следуют порождающим паттернам (Creational Patterns) или порождающим шаблонам

### Фабричный метод

**Фабричный метод** (Factory Method) - метод, который определяет общий интерфейс для создания объектов в родительском классе, позволяя дочерним классам изменять тип создаваемых объектов

Фабричный метод позволяет разделить логику и создания объектов на иерархию типов

Пример: у нас есть объект заказа (`Order`), хранящий различные позиции (`OrderItem`); мы хотим передавать этот заказ в калькулятор платежа (`PaymentCalculator`), применять всякие скидки и купоны, и возвращать готовый платеж наличными (`CashPayment`) с просчитанным значением:

```csharp
public record OrderItem(decimal Price, int Amount)
{
    public decimal Cost => Price * Amount;
}

public record Order(IEnumerable<OrderItem> Items)
{
    public decimal TotalCost => Items.Sum(x => x.Cost);
}

public record CashPayment(decimal Amount);

public class PaymentCalculator
{
    public CashPayment Calculate(Order order)
    {
        var totalCost = order.TotalCost;

        // применить скидки и купоны
        ...

        return new CashPayment(totalCost);
    }
}
```

Здесь мы хотим ввести возможность оплаты не только наличными, но и банковской картой, поэтому создаем объект `BankPayment` (от интерфейса `IPayment`) и различные калькуляторы для них

```csharp
public interface IPayment
{
    decimal Amount { get; }
}

public record CashPayment(decimal Amount) : IPayment;
public record BankPayment(
    decimal Amount,
    string ReceiverAccountId) : IPayment;

public abstract class PaymentCalculator
{
    public IPayment Calculate(Order order)
    {
        var totalCost = order.TotalCost;

        // применить скидки и купоны
        ...

        return CreatePayment(totalCost);
    }

    protected abstract IPayment CreatePayment(decimal amount);
}

public class CashPaymentCalculator : PaymentCalculator
{
    protected override IPayment CreatePayment(decimal amount)
        => new CashPayment(amount);
}

public class BankPaymentCalculator : PaymentCalculator
{
    private readonly string _currentReceiverAccountId;

    public BankPaymentCalculator(string currentReceiverAccountId)
    {
        _currentReceiverAccountId = currentReceiverAccountId;
    }
    protected override IPayment CreatePayment(decimal amount)
    {
        return new BankPayment(amount, _currentReceiverAccountId);
    }
}
```

Здесь же можно выделить в паттерне фабричного метода две сущности:

* создатель (creator) - содержит логику создания объектов-наследников
* продукт (product) - содержит бизнес-логику

В данном примере продукт - это реализация интерфейса `IPayment`, а создатель - метод `CreatePayment` в абстрактном классе `PaymentCalculator`.
Фабричный метод применяется для переиспользования логики создания на наборе типов. Но при этом фабричный метод считается _антипаттерном_ из-за следующих недостатков:

* Сильная связность реализаций: из-за наследования переиспользования логики в конкретных создателях невозможно; в примере мы не можем имплементировать реализации метода `Calculate` для разных типов
* Неявное нарушение _принципа единственной ответственности_: хотя логика создания и бизнес-логика разделены по классах, конечный объект имеет две ответственности

### Абстрактная фабрика

**Абстрактная фабрика** (или просто **фабрика**, Abstract Factory) - объект, который позволяет создавать семейства связанных объектов, не привязываясь к конкретным классам создаваемых объектов

Это позволяет вынести логику создания объектов в отдельные типы, объекты-фабрики которых будут ответственны только за это

При использовании фабричного метода возникает такая проблема: мы хотим использовать логику создания не только в пределах нашего `PaymentCalculator`, но и где-то еще - приходится переиспользовать логику. Поэтому здравой идеей будет вынести логику из фабричного метода в отдельный класс - фабрику:

```csharp
public interface IPaymentFactory
{
    IPayment Create(decimal amount);
}

public class CashPaymentFactory : IPaymentFactory
{
    public IPayment Create(decimal amount) => new CashPayment(amount);
}

public class BankPaymentFactory : IPaymentFactory
{
    private readonly string _currentReceiverAccountId;
    public BankPaymentFactory(string currentReceiverAccountId)
    {
        _currentReceiverAccountId = currentReceiverAccountId;
    }
    public IPayment Create(decimal amount)
    {
        return new BankPayment(amount, _currentReceiverAccountId);
    }
}

public interface IPaymentCalculator
{
    IPayment Calculate(Order order);
}

public class PaymentCalculator : IPaymentCalculator
{
    private readonly IPaymentFactory _paymentFactory;
    public PaymentCalculator(IPaymentFactory paymentFactory)
    {
        _paymentFactory = paymentFactory;
    }
    public IPayment Calculate(Order order)
    {
        var totalCost = order.TotalCost;

        // применить скидки и купоны
        ...

        return _paymentFactory.Create(totalCost);
    }
}
```

Здесь все фабрики с разными логикам создания нашего `Payment` реализуются от интерфейса `IPaymentFactory`. Поэтому мы можем какой-нибудь другой калькулятор `FixedPaymentCalculator`, который этим пользуется:

```csharp
public class FixedPaymentCalculator : IPaymentCalculator
{
    private readonly decimal _fixedPrice;
    private readonly IPaymentFactory _paymentFactory;

    public FixedPaymentCalculator(decimal fixedPrice, IPaymentFactory paymentFactory)
    {
        _fixedPrice = fixedPrice;
        _paymentFactory = paymentFactory;
    }
    public IPayment Calculate(Order order)
    {
        var totalCost = order.Items.Sum(item =>_fixedPrice * item.Amount);

        // применить скидки и купоны
        ...

        return _paymentFactory.Create(totalCost);
    }
}
```

При этом заметить следующие преимущества у абстрактной фабрики:

* Настоящее соблюдение _принципа единственной ответственности_, ведь в такой реализации нет прямой связанности между реализациями
* Соблюдение _принципа открытости/закрытости_: мы можем добавить в систему новые виды платежей и реализовать фабрики для них, тем самым расширить логику, не меняя реализацию калькуляторов

### Строитель

**Строитель** (или билдер, Builder) - объект, при помощи которого мы можем создать более сложный и составной объект. В строителе мы можем разбить логику сбора аргументов на методы, уменьшить мутабельность, задавать некоторые значения по умолчанию

Примером работы строителя может являться процесс создания пиццы: в строителе мы можем принять такие типы, как соус, начинка, топпинги, чтобы строитель сам собрал нам пиццу

Разделяют 2 вида строителей:

* **Удобный строитель** (Convenience Builder) позволяет упрощено создавать объектов с большим конструктором
* **Строитель с сохранением состояния** (Stateful Constructor Builder) используется как конструктор, имеющий состояние, что помогает проверять данные на этапе создания объекта

С помощью удобного строителя мы упрощаем создание объектов с гигантским конструктором, предполагая, что некоторые аргумент можем сделать по умолчанию. Пример:

```csharp
class Service
{
    public Service(IDependency1? one, IDependency2 two, IDependency3 three)   { ... }
    ...
}
internal interface IDependency3 { ... }
internal interface IDependency2 { ... }
internal interface IDependency1 { ... }

class ServiceBuilder
{
    private IDependency1? _one;
    private IDependency2? _two;
    private IDependency3? _three;
    public ServiceBuilder()
    {
        _one = null;
        _two = new Dependency2();
        _three = new Dependency3();
    }
    public ServiceBuilder WithOne(IDependency1 one) { ... }
    public ServiceBuilder WithTwo(IDependency2 two) { ... }
    public ServiceBuilder WithThree(IDependency3 three) { ... }
    public Service Build()
    {
        return new Service(
            _one,
            _two ?? throw new InvalidOperationException(),
            _three ?? throw new InvalidOperationException());
    }
}
```

С помощью строителя с сохранением состояния мы можем принимать аргументы через методы строителя. В итоге вместо такого вызова конструктора:

```csharp
var model = new Model(arg1, arg2, arg3, arg4, arg5);
```

мы получаем:

```csharp
var builder = new ModelBuilder()
    .AddArg1(arg1)
    .AddArg2(arg2)
    .AddArg3(arg3)
    .AddArg4(arg4)
    .AddArg5(arg5);

var model = new builder.Build();
```

Пример такого строителя (здесь он вложен в сам класс, чтобы он мог пользоваться приватным конструктором):

```csharp
public class Model
{
    private Model(IReadOnlyCollection<Data> data, ...)
    {
        Data = data;
        ...
    }

    public IReadOnlyCollection<Data> Data { get; }

    public static ModelBuilder Builder => new ModelBuilder();

    public class ModelBuilder
    {
        private readonly List<Data> _data;
        ...

        public ModelBuilder AddData(Data data)
        {
            _data.Add(data);
            return this;
        }
        public Model Build()
        {
            return new Model(_data, ...);
        }
    }
}
```

Конечно же, строитель может реализовывать интерфейс, чтобы иметь возможность создавать разные модели и осуществить полиморфизм:

```csharp
public interface IModelBuilder {
    ...

    Model Build();
}

public class ConcreteBuilderA : IModelBuilder
{
    ...

    public Model Build() { ... }
}
public class ConcreteBuilderB : IModelBuilder
{
    ...

    public Model Build() { ... }
}
```

Заметим, что строитель - это инфраструктурный код, неприоритетный при проектировании

Здесь же можем к строителю внедрить директора:

```csharp
public static class BuilderDirector
{
    public static Builder DirectNumeric(
        this Builder builder,
        int count)
    {
        var enumerable = Enumerable.Range(0, count);
        foreach (var i in enumerable)
        {
            var data = new DataA(i);
            builder = builder.WithDataA(data);
        }
        return builder;
    }
}

public interface IBuilderDirector
{
    Builder Direct(Builder builder);
}

public class InstanceDirector : IBuilderDirector
{
    private readonly int _size;
    private IEnumerable<Model> _prototypes;
    ...
    public Builder Direct(Builder builder) { ... }
}
```

Директор определяет порядок вызова строительных шагов для производства той или иной конфигурации продуктов

<!-- не понял, че тут происходит -->

Или же можно сделать цепочку из интерфейсов для получения данных:

```csharp
public interface IAddressBuilder
{
    ISubjectBuilder WithAddress(string address);
}
public interface ISubjectBuilder
{
    IEmailBuilder WithSubject(string subject);
}
public interface IEmailBuilder
{
    IEmailBuilder WithBody(string body);
    Email Build();
}
public class Email
{
    public static IAddressBuilder Builder => new EmailBuilder();
    private class EmailBuilder : IAddressBuilder, ISubjectBuilder, IEmailBuilder { }
}

var email = Email.Builder
 .WithAddress("aboba@email.com")
 .WithSubject("subject")
 .Build();
```

Здесь мы принуждаем к порядку сбора данных: адрес -> тема -> тело письма

### Прототип

**Прототип** (Prototype) позволяет копировать объекты, не вдаваясь в подробности их реализации, что упрощает копирование объекта. Почему не пользоваться просто конструктором:

* Логика копирования может быть необходима в нескольких местах
* Данные могут быть сокрыты, модифицированы в конструкторе
* Объект находится в иерархии, и он может использоваться как интерфейс или родительский тип, поэтому при копировании конкретный тип не известен

Примитивный прототип может быть таким:

```csharp
public class Prototype
{
    private readonly IReadOnlyCollection<int> _relatedEntityIds;
    public Prototype(IReadOnlyCollection<int> relatedEntityIds)
    {
        _relatedEntityIds = relatedEntityIds;
    }
    public Prototype Clone()
    {
        return new Prototype(_relatedEntityIds);
    }
}
```

Заметим, что здесь в методе `Clone` передаем ссылку на коллекцию, то есть не копируем ее. Такое копирование называется поверхностным. Сделаем прототип с глубокой копией:

```csharp
public class WrappedValue
{
    public int Value { get; set; }
    public WrappedValue Clone()
        => new WrappedValue{ Value = Value };
}
public class DeepCopyPrototype
{
    private readonly List<WrappedValue> _values;
    public DeepCopyPrototype(List<WrappedValue> values)
    {
        _values = values;
    }
    public DeepCopyPrototype Clone()
    {
        List<WrappedValue> values = _values.Select(x => x.Clone()).ToList();
        return new DeepCopyPrototype(values);
    }
}
```

Теперь внедрим прототип в иерархию классов:

```csharp
public abstract class Prototype
{
    public void DoSomeStuff() { ... }
    public abstract Prototype Clone();
}
public class ClassPrototype : Prototype
{
    public void DoOtherStuff() { ... }
    public override Prototype Clone() => new ClassPrototype();
}
```

Пример использования может быть таким:

```csharp
public class Scenario
{
    public static Prototype CloneAndDoSomeStuff(Prototype prototype)
    {
        var clone = prototype.Clone();
        clone.DoSomeStuff();
        return clone;
    }
    public static void TopLevelScenario()
    {
        var prototype = new ClassPrototype();
        Prototype clone = CloneAndDoSomeStuff(prototype);

        clone.DoOtherStuff();
    }
}
```

Здесь строка `clone.DoOtherStuff();` вызовется с ошибкой, так как у базового класса нет метода `DoOtherStuff()`. Попробуем сделать прототип при помощи интерфейса:

```csharp
public interface IPrototype
{
    IPrototype Clone();
    void DoSomeStuff();
}
public class InterfacePrototype : IPrototype
{
    IPrototype IPrototype.Clone() => Clone();

    public InterfacePrototype Clone() => new InterfacePrototype();
    public void DoSomeStuff() { ... }
    public void DoOtherStuff() { ... }
}
```

И точно такой же сценарий работы:

```csharp
public class Scenario
{
    public static IPrototype CloneAndDoSomeStuff(IPrototype prototype)
    {
        var clone = prototype.Clone();
        clone.DoSomeStuff();

        return clone;
    }
    public static void TopLevelScenario()
    {
        var prototype = new InterfacePrototype();
        IPrototype clone = CloneAndDoSomeStuff(prototype);

        clone.DoOtherStuff();
    }
}
```

Здесь опять же в `clone.DoOtherStuff();` возникнет ошибка - мы ничего не знаем про класс-наследник. В этом случае мы можем преобразовать тип интерфейса к известному нами типу:

```csharp
InterfacePrototype clone = (InterfacePrototype)CloneAndDoSomeStuff(prototype);
```

Но решим это при помощи рекурсивного параметр-типа - параметр-типа, ссылающегося на себя. Реализуем это при помощи дженериков в C#

```csharp
public interface IPrototype<T> where T : IPrototype<T>
{
    T Clone();
    void DoSomeStuff();
}
public class Prototype : IPrototype<Prototype>
{
    public Prototype Clone() => new Prototype();
    public void DoSomeStuff() { ... }
    public void DoOtherStuff() { ... }
}
```

Тот же самый сценарий:

```csharp
public class Scenario
{
    public static T CloneAndDoSomeStuff<T>(T prototype) where T : IPrototype<T>
    {
        var clone = prototype.Clone();
        clone.DoSomeStuff();

        return clone;
    }
    public static void TopLevelScenario()
    {
        var prototype = new Prototype();
        Prototype clone = CloneAndDoSomeStuff(prototype);

        clone.DoOtherStuff();
    }
}
```

И здесь метод `Clone` возвращает именно тип наследника

### Одиночка

**Одиночка** (или синглтон, Singleton) - объект, для которого мы гарантируем, что одновременно не может существовать больше одного экземпляра. Синглтоном может быть, например, глобальный кеш. Пример:

```csharp
public class Singleton
{
    private static readonly object _lock = new();
    private static Singleton? _instance;
    private Singleton() { }
    public static Singleton Instance
    {
        get
        {
            if (_instance is not null)
                return _instance;
            lock (_lock)   // с помощью lock гарантируем, что
            {              // код ниже выполнится только в одном потоке
                if (_instance is not null)
                    return _instance;

                return _instance = new Singleton();
            }
        }
    }
}
```

Также существует реализация через встроенный объект `Lazy`:

```csharp
public class Singleton
{
    private static readonly Lazy<Singleton> _instance;
    static Singleton()
    {
        _instance = new Lazy<Singleton>(()
            => new Singleton(), LazyThreadSafetyMode.ExecutionAndPublication);
    }
    private Singleton() { }
    public static Singleton Instance => _instance.Value;
}
```

Одиночка считается антипаттерном по этим причинам:

* Тестирование: из-за приватного конструктора мы не можем его контролировать в тестах
* Внедрение зависимостей: приватный конструктор не дает возможности передавать ему значения
* Время жизни объекта нельзя явно контролировать
* Объект можно получить из любого места приложения без какого-либо контроля
