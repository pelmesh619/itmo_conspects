## Лекция 3. Принципы SOLID

### Single responsibility principle

Принцип единственной ответственности (SRP) гласит, что класс должен быть ответственным только за одну сущность

Например: делать класс, который создает отчеты и для Excel, и в .pdf - плохо, так как в них могут быть методы с одинаковыми названиями, но с разной логикой, этот класс будет труднее изменять. 

```csharp
public record OperationResult(...);

public class ReportGenerator
{
    public void GenerateExcelReport(OperationResult result)    
    {
        ...    
    }
    public void GeneratePdfReport(OperationResult result)    
    {
        ...
    }
}
```

Поэтому лучше сделать интерфейс генераторов отчета, от которого наследуются классы генераторов в Excel и pdf

```csharp
public record OperationResult(...);
public interface IReportGenerator
{
    void GenerateReport(OperationResult result);
}
public class ExcelReportGenerator : IReportGenerator
{
    public void GenerateReport(OperationResult result)    
    {
        ...
    }
}
public class PdfReportGenerator : IReportGenerator
{
    public void GenerateReport(OperationResult result)    
    {
        ...
    }
}

```

**Преимущества несоблюдения**:

 * простота: нет необходимости в абстракциях, низкий порог вхождения
 * переиспользование логики: часто логика в типах не соблюдающих SRP имеет общие части, вызвать приватный метод типа в нескольких местах проще, чем реализовывать грамотную декомпозицию

**Последствия несоблюдения**:

* сильная связанность реализации различных бизнес требований; от простого: загрязнённый контекст для анализатора; до тяжёлого: усложнение тестирования 
* усложнённая кастомизация отдельных реализаций - изменения в общем коде могут поломать другие решения

> **Single Responsibility Principle** - проектирование типов, таким образом, что они имеют единственную причину для изменения


### Open/closed principle 

Принцип открытости и закрытости гласит, что программные сущности должны быть открытыми для расширения и закрытыми для изменения

Пример несоблюдения OCP:

```csharp
public enum BinaryOperation
{
    Summation,
    Subtraction,
}
public class BinaryOperand
{
    private readonly int _left;
    private readonly int _right;
    
    public int Evaluate(BinaryOperation operation)    
    {
        return operation switch {
            BinaryOperation.Summation !=>_left + _right
            BinaryOperation.Subtraction !=>_left - _right,        
        };   
    }
}
```

В этом примере калькулятор использует перечисления для определения оператора и оператор `switch`, чтобы возвращать нужный результат. В итоге, чтобы добавить операцию умножения, нужно изменить инструкции в операторе `switch`. Поэтому более расширяемым будет такой код:

```csharp
public interface IBinaryOperation
{
    int Evaluate(int left, int right);
}
public class Summation : IBinaryOperation
{
    public int Evaluate(int left, int right) => left + right;
}
public class Subtraction : IBinaryOperation
{
    public int Evaluate(int left, int right) => left - right;
}
public sealed class BinaryOperand
{
    private readonly int _left;
    private readonly int _right;
    
    public int Evaluate(IBinaryOperation operation) => operation.Evaluate(_left, _right);
}
```

Создаем интерфейс операции, классы конкретных операторов с их реализацией, и передаем объекты классов в класс `BinaryOperand`

> **Open/Closed Principle** - проектирование типов, таким образом, что их логику можно расширять, не изменяя их исходный код; тип должен быть открытым для расширения, но закрытым для изменений

### Liskov substitution principle

Принцип подстановки Лисков гласит, что при замене похожих объектов логика программы не должна нарушаться

Например: создадим классы для обычной птицы, пингвина и летучей мыши, чтобы заставить их мигрировать:

```csharp
public record Coordinate(int X, int Y);

public class Creature{
    public void Die()    
    {
        Console.WriteLine("I am dead now");    
    }
}

public class Bird : Creature
{
    public virtual void FlyTo(Coordinate coordinate)    
    {        
        Console.WriteLine("I am flying");    
    }
}

public class Penguin : Bird
{
    public override void FlyTo(Coordinate coordinate)    
    {
        Die();  // it cannot fly :(   
    }
}

public class Bat : Creature
{
    public void FlyTo(Coordinate coordinate)    
    {
        Console.WriteLine("I bat and am flying");    
    }
}

void StartMigration(IEnumerable<Creature> creatures, Coordinate coordinate)
{
    foreach (var creature in creatures)    
    {
        if (creature is Bird bird)        
        {
            bird.FlyTo(coordinate);        
        }
        if (creature is Bat bat)        
        {            
            bat.FlyTo(coordinate);        
        }
    }
}
```

В этом случае, летучая мышь не является птицей, но летать и мигрировать она умеет, поэтому в функции миграции нам пришлось отдельно переопределять поведение для летучей мыши, так как она не является наследником птицы. Поэтому лучше сделать отдельный интерфейс для летающий существ:

```csharp
public record Coordinate(int X, int Y);
public interface ICreature
{
    void Die();
}
public interface IFlyingCreature : ICreature
{
    void FlyTo(Coordinate coordinate);
}
public class CreatureBase : ICreature
{
    public void Die()    
    {
        Console.WriteLine("I am dead now");    
    }
}
public class Bird : CreatureBase { }
public class Penguin : Bird { }
public class Colibri : Bird, IFlyingCreature
{
    public void FlyTo(Coordinate coordinate)    
    {
        Console.WriteLine("I am colibri and I'm flying");    
    }
}
public class Bat : CreatureBase, IFlyingCreature
{
    public void FlyTo(Coordinate coordinate)    
    {
        Console.WriteLine("I am bat and I'm flying");    
    }
}

void StartMigration(IEnumerable<IFlyingCreature> creatures, Coordinate coordinate)
{
    foreach (var creature in creatures)    
    {
        creature.FlyTo(coordinate);  
    }
}

```

В итоге, получаем, что для летучей мыши не нужны дополнительный if


> **Liskov Substitution Principle** - проектирование иерархий типов, таким образом, что логика дочерних типов не нарушает инвариант и интерфейс родительских типов


### Interface segregation principle

Принцип разделения интерфейса является аналогом SRP для интерфейсов - когда абстракции начинают выполнять больше одной задачи, их реализации тоже начинают брать более одной ответственности.

Поэтому лучше делать не так:

```csharp
public interface ICanAllDevice
{
    void Print();
    void PlayMusic();
    void BakeBread();
}
```

А так:

```csharp
public interface IPrinter
{
    void Print();
}
public interface IMusicPlayer
{
    void Play();
}
public interface IBakery
{
    void BakeBread();
}
```

> **Interface segregation principle** - проектирование маленьких абстракций, которые ответственны за свой конкретный функционал, а не одной всеобъемлющей, содержащий много различного


### Dependency inversion principle

Принцип зависимости инверсий гласит, что реализации должны зависеть только от интерфейсов.

Например: пусть будет консольный логгер для клиента, сделаем зависимость клиента от методов логгер, тогда, когда мы захотим сделать второй логгер, файловый, то придется изменять логику клиента. В этом случае лучше сделать прослойку, состоящую из интерфейса логгера - мы избавляемся от сильной связанности между типами, улучшаем расширяемость типов и упрощаем тестирование

> **Dependency inversion principle** - проектирование типов, таким образом, что одни реализации не зависят от других напрямую


