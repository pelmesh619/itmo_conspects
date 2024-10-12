## Лекция 5. Порождающие паттерны

### Factory method

В ходе разработки возникают класса, объекты которых создаются уж слишком тяжело и громоздко. Для этих случаев

> **Фабричный метод** - разделение логики и создания объектов на иерархию типов

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

        // Apply discounts and coupons
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

        // Apply discounts and coupons
        ...

        return CreatePayment(totalCost);
    }

    protected abstract IPayment CreatePayment(decimal amount);
}

public class CashPaymentCalculator : PaymentCalculator
{
    protected override IPayment CreatePayment(decimal amount) => new CashPayment(amount);
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

* создатель (creater) - содержит логику создания объектов-наследников
* продукт (product) - содержит бизнес-логику

В данном примере продукт - это реализация интерфейса `IPayment`, а создатель - метод `CreatePayment` в абстрактном классе `PaymentCalculator`.
Фабричный метод применяется для переиспользования логики создания на наборе типов. Но при этом фабричный метод считается _антипаттерном_ из-за следующих недостатков:

* сильная связность реализаций: из-за наследования переиспользования логики в конкретных создателях невозможно; в примере мы не можем имплементировать реализации метода `Calculate` для разных типов
* неявное нарушение SRP: хотя логика создания и бизнес-логика разделены по классах, конечный объект имеет две ответственности

### Abstract factory

> **Абстрактная фабрика** (или просто **фабрика**) - вынесение логики создания объектов в отдельные типы, объекты которых будут ответственны только за это

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

        // Apply discounts and coupons
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

        // Apply discounts and coupons
        ...

        return _paymentFactory.Create(totalCost);
    }
}
```

При этом заметить следующие преимущества у абстрактной фабрики:

* Настоящее соблюдение SRP: ведь в такой реализации нет прямой связанности между реализациями
* Соблюдение OCP: мы можем добавить в систему новые виды платежей и реализовать фабрики для них, тем самым расширить логику, не меняя реализацию калькуляторов

### Builder

Билдер (строитель) - объект, при помощи которого мы можем создать составной объект. В билдере мы можем разбить логику сбора аргументов на методы, уменьшая мутабельность, задавать некоторые значения по умолчанию

Разделяют 2 вида билдеров:

* **Convenience Builder**: упрощенное создание объектов с большим конструктором
* **Stateful Constructor Builder**: используется как конструктор, имеющий состояние (валидации)

С помощью **Convenience Builder** мы упрощаем создание объектов с гигантским конструктором, предполагая, что некоторые аргумент можем сделать по умолчанию. Пример:

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

С помощью **Stateful Constructor Builder** мы можем принимать аргументы через методы билдера. В итоге вместо такого вызова конструктора:

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

Пример такого билдера (здесь мы его вложили в сам класс, чтобы он мог пользоваться приватным конструктором):

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

Конечно же, билдер можно наследовать от интерфейса, чтобы иметь возможность создавать разные модели и осуществить полиморфизм.

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

Заметим, что билдер - инфраструктурный код, неприоритетный при проектировании.

Здесь же можем к билдер внедрить директора:

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

<!-- не понял, че тут происходит -->


Примером работы билдера может явялется процесс создания пиццы из моей любимой франшизы пиццерий Додо Пицца: в билдере мы можем принять такие типы, как соус, начинка, топпинги, чтобы билдер сам сбилдил нам пиццу

### Prototype

С помощью прототипа мы можем упростить себе копирование объекта. Почему не пользоваться просто конструктором:

* Логика копирования может быть необходима в нескольких местах
* Данные могут быть сокрыты, модифицированны в конструкторе
* Объект находится в иерархии, при копировании конкретный тип не извествен


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

Заметим, что здесь в методе `Clone` передаем ссылку на коллекцию, то есть не копируем ее. Сделаем прототип с глубокой копией:

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
        List<WrappedValue> values = _values.Select(x =>x.Clone()).ToList(); 
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

Ну и напишем какой-нибудь скриптик для этого:

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

Здесь строка `clone.DoOtherStuff();` вызовется ошибкой, так как у базового класса нет метода `DoOtherStuff`. Ладно, попробуем сделать прототип при помощи интерфейса:

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

И точно такой же скриптик:

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

Здесь опять же в `clone.DoOtherStuff();` возникнет ошибка - мы ничего не знаем про класс-наследник. В этом случае мы можем скастить интерфейс к известному нами типу:

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

Тот же самый скриптик:

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

### Singleton

Синглтон - объект, для которого мы гарантируем, что одновременно будет существовать не больше одного экземпляра. Синглтоном может быть, например, глобальный кеш. Пример:

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
        _instance = new Lazy<Singleton>(() => new Singleton(), LazyThreadSafetyMode.ExecutionAndPublication);
    }
    private Singleton() { }
    public static Singleton Instance => _instance.Value;
}
```

Синглтон считается антипаттерном и вот почему:

* тестирование: из-за приватного конструктора мы не можем его контролировать в тестах
* внедрение зависимостей: приватный конструктор не дает возможности передавать ему значения
* время жизни объекта нельзя явно контролировать
* объект можно получить из любого места приложения без какого-либо контроля
