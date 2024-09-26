# <a name="%D0%BE%D0%B1%D1%8A%D0%B5%D0%BA%D1%82%D0%BD%D0%BE-%D0%BE%D1%80%D0%B8%D0%B5%D0%BD%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D0%BE%D0%B5-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5"></a> Объектно-ориентированное программирование


* [Объектно-ориентированное программирование](#%D0%BE%D0%B1%D1%8A%D0%B5%D0%BA%D1%82%D0%BD%D0%BE-%D0%BE%D1%80%D0%B8%D0%B5%D0%BD%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D0%BE%D0%B5-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5)
  * [Лекция 1. Основы ООП](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-1.-%D0%BE%D1%81%D0%BD%D0%BE%D0%B2%D1%8B-%D0%BE%D0%BE%D0%BF)
    * [Концепции ООП](#%D0%BA%D0%BE%D0%BD%D1%86%D0%B5%D0%BF%D1%86%D0%B8%D0%B8-%D0%BE%D0%BE%D0%BF)
    * [Выводы](#%D0%B2%D1%8B%D0%B2%D0%BE%D0%B4%D1%8B)
  * [Лекция 2. Проектирование модели](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-2.-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D0%B8)
    * [Иммутабельность](#%D0%B8%D0%BC%D0%BC%D1%83%D1%82%D0%B0%D0%B1%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE%D1%81%D1%82%D1%8C)
    * [Find/Get](#find%2Fget)
    * [Обработка ошибок](#%D0%BE%D0%B1%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B0-%D0%BE%D1%88%D0%B8%D0%B1%D0%BE%D0%BA)
    * [Domain Driven Design](#domain-driven-design)
  * [Лекция 3. Принципы SOLID](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-3.-%D0%BF%D1%80%D0%B8%D0%BD%D1%86%D0%B8%D0%BF%D1%8B-solid)
    * [Single responsibility principle](#single-responsibility-principle)
    * [Open/closed principle](#open%2Fclosed-principle)
    * [Liskov substitution principle](#liskov-substitution-principle)
    * [Interface segregation principle](#interface-segregation-principle)
    * [Dependency inversion principle](#dependency-inversion-principle)



Все презентации к лекциям можно найти по ссылке [github.com/is-oop-y27](https://github.com/is-oop-y27)

## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-1.-%D0%BE%D1%81%D0%BD%D0%BE%D0%B2%D1%8B-%D0%BE%D0%BE%D0%BF"></a> Лекция 1. Основы ООП

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

### <a name="%D0%BA%D0%BE%D0%BD%D1%86%D0%B5%D0%BF%D1%86%D0%B8%D0%B8-%D0%BE%D0%BE%D0%BF"></a> Концепции ООП

* **Инкапсуляция** - объединение данных и их поведения
* **Сокрытие** - управление доступа к полям класса, тем самым сохранение инварианта
* **Композиция** - объединение различного поведения в один объект

Агрегация - объект получает уже созданные данные
Ассоциация - объект сам управляет циклом жизни своих данных (выделяет и освобождает память для них)

* **Полиморфизм**

Концепция полиморфизма заключается в более абстрактном понимании объектов 

> Полиморфизм подтипов - отделение абстракции от реализации, позволяющее пользователю прозрачно использовать различные реализации поведений

Примером абстракции может быть объект для доступа к базе данных - мы можем создать классы для доступа к базам данным SQL и NoSQL, которые имеют одни и те же публичные методы с одинаковыми аргументами - и тогда мы приходим к понятию интерфейса, который описывает методы у классов

> Реализация (наследование поведений): в C# реализовывать интерфейсы могут как классы, так и структуры. Говорят, что тип реализует интерфейс (класс `Point` реализует интерфейс `IPoint`)

> Наследование реализаций: используются классы, в C# одна структура не может быть унаследована от другой, либо от класса. Говорят, что класс является наследником другого класса, либо же его подклассом (класс `Cat` является наследником класса `Animal`)

При этом наследники могут переопределять методы класса/интерфейса и определять новые

> Объект - набор атрибутов и поведений, реализаций и данные которого сокрыты от конечного пользователя объекта. Также абстракция, представляющая какой-то объект моделируемой предметной области

### <a name="%D0%B2%D1%8B%D0%B2%D0%BE%D0%B4%D1%8B"></a> Выводы

* Парадигма ООП представляет собой концепцию объединения данных и логики, их обрабатывающей
* Сокрытие принуждает пользователей использовать поведения, соответствующие бизнес-правилам
* Локализация изменений данных позволяет упростить поддержание их инварианта




## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-2.-%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D0%B8"></a> Лекция 2. Проектирование модели

### <a name="%D0%B8%D0%BC%D0%BC%D1%83%D1%82%D0%B0%D0%B1%D0%B5%D0%BB%D1%8C%D0%BD%D0%BE%D1%81%D1%82%D1%8C"></a> Иммутабельность

> Иммутабельность (immutable) - свойство данных, не подразумевающее изменения в ООП, которое используется в виде сокрытия мутабельных данных, значения которых не требуют изменений

Мутабельность данных усложняет систему, повышая количество допускаемых состояний, из-за чего система становится менее предсказуемой

Пример - группа студентов. У группы студентов может быть идентификатор, имя и список студентов, и очевидно, что идентификатор и имя у группы в дальнейшем никак не изменится. Если не применять к данным иммутабельность, то получим:

```csharp
public class StudentGroup 
{ 
    public long Id { get; set; } 
    
    public string Name { get; set; } 
    
    public List<long> StudentIds { get; set; } 
    
    public void AddStudent(long studentId)     
    { 
        if (StudentIds.Contains(studentId) is false) 
            StudentIds.Add(studentId);     
    } 
}
```

Но мы можем сделать эти поля только для чтения при помощи модификатора `readonly`:

```csharp
public class StudentGroup { 
    private readonly HashSet<long> _studentsIds; // ну еще лист на хешсетик поменяли 
    
    public StudentGroup(long id, string name)     
    { 
        Id = id; 
        Name = name; 
        _studentsIds = new HashSet<long>();     
    } 
    
    public long Id { get; } 
    
    public string Name { get; set; } 
    
    public IReadOnlyCollection<long> StudentIds => _studentsIds; 
    
    public void AddStudent(long studentId)     
    { 
        _studentsIds.Add(studentId);     
    } 
} 
```

В итоге мы поставили ограничение, что айди и имя группы мы можем только инициализировать.

### <a name="find%2Fget"></a> Find/Get

Если же у нас есть метод, который возвращает какой-то `X`, то неплохо было бы определиться, что будет происходить, если метод не нашел `X`. Тогда можно действовать так:

* выбрасывать исключение
* возвращать `null`

Тогда соответственно будем именовать методы `Get__By__`, если метод будет возвращать ошибку, и `Find__By__`, если метод возвращает `null`. Пример:

```csharp
public record Post(long Id, string Title, string Content); 

public class User { 
    private readonly List<Post> _posts; 
    
    public User(IEnumerable<Post> posts)     
    { 
        _posts = posts.ToList();     
    } 
    
    public Post GetPostById(long postId)     
    { 
        return _posts.Single(x => x.Id.Equals(postId));     
    } 
    
    public Post? FindPostByTitle(string title)     
    { 
        return _posts.SingleOrDefault(x => x.Title.Equals(title));   
    } 
}
```

При этом использование статического полиморфизма (перегрузки методов) вместо методов с суффиксами `By__` снижает читаемость и расширяемость:

```csharp
public Post? FindPost(long postId) 
{ 
    return _posts.Single(x => x.Id.Equals(postId)); 
} 
public Post? FindPost(string title) 
{ 
    return _posts.SingleOrDefault(x => x.Title.Equals(title)); 
} 
```


### <a name="%D0%BE%D0%B1%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%BA%D0%B0-%D0%BE%D1%88%D0%B8%D0%B1%D0%BE%D0%BA"></a> Обработка ошибок

При использовании исключений могут возникнуть следующие ситуации:

* исключения не отражены в сигнатуре метода
* поиск конкретного типа исключения и ситуации, когда оно кидается, приводят к протекшей абстракции
* неудачное выполнение операции != исключительная ситуация

> Протекшая абстракция - абстракция, для работы с которой, необходимо иметь знание о деталях ее реализации

Вместо исключений можно возвращать `bool`, который означает успех операции:

```csharp
if (long.TryParse("123", out long number)) 
{
    Console.WriteLine(number);
}
```

Но, если нам нужно более 2 значений, чтобы передать, что именно пошло не так, можно воспользоваться Result Types:

```csharp
public abstract record AddStudentResult 
{ 
    private AddStudentResult() { } 
    public sealed record Success : AddStudentResult; 
    public sealed record AlreadyMember : AddStudentResult; 
    public sealed record StudentLimitReached(int Limit) : AddStudentResult; 
} 
```

В итоге мы можем возвращать `AddStudentResult`:

```csharp
public AddStudentResult AddStudent(long studentId) 
{ 
    if (_studentsIds.Count.Equals(MaxStudentCount)) 
        return new AddStudentResult.StudentLimitReached(MaxStudentCount); 
        
    if (_studentsIds.Add(studentId) is false) 
        return new AddStudentResult.AlreadyMember(); 
    
    return new AddStudentResult.Success(); 
} 
```

И после этого уже проверять наш Result Type:

```csharp
if (result is AddStudentResult.AlreadyMember) 
{ 
    Console.WriteLine("Student is already member of specified group"); 
    return; 
} 
if (result is AddStudentResult.StudentLimitReached err) 
{ 
    var message = $"Cannot add student to specified group, maximum student count of {err.Limit} already reached"; 
    Console.WriteLine(message); 
    return; 
} 
if (result is not AddStudentResult.Success) 
{ 
    Console.WriteLine("Operation finished unexpectedly"); 
    return; 
} 

Console.WriteLine("Student successfully added"); 
```

В итоге это выходит:

* дешевле и быстрее исключений (тип результата хранится на стеке, а исключение на куче)
* более информативно перечислений и булевого значения
* возвращаемый результат более понятный


### <a name="domain-driven-design"></a> Domain Driven Design

Приведем пример: 

```csharp
public class Account 
{ 
    public decimal Balance { get; private set; } 
    
    public void Withdraw(decimal value)     
    { 
        if (value < 0) 
            throw new ArgumentException("Value cannot be negative", nameof(value)); 
            
        Balance -= value;     
    } 
} 
```

Здесь можно сделать обертку вокруг `decimal value`, которая будет заниматься валидацией данных:

```csharp
public struct Money 
{ 
    public Money(decimal value)     
    { 
        if (value < 0)         
        { 
            throw new ArgumentException("Value cannot be negative", nameof(value));         
        } 
        Value = value;     
    } 
    public decimal Value { get; } 
    public static Money operator -(Money left, Money right)     
    { 
        var value = left.Value - right.Value; 
        return new Money(value);     
    } 
} 
public class Account 
{ 
    public Money Balance { get; private set; } 
    public void Withdraw(Money value)     
    { 
        Balance -= value;     
    } 
} 
```

И в этом случае деньги будут "value object"

Также структура файлов проекта должна быть семантической, а не инфраструктурной для упрощенного поиска той или иной сущности

![](images/oopcsharp_2024_09_14_01.png)



## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-3.-%D0%BF%D1%80%D0%B8%D0%BD%D1%86%D0%B8%D0%BF%D1%8B-solid"></a> Лекция 3. Принципы SOLID

### <a name="single-responsibility-principle"></a> Single responsibility principle

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


### <a name="open%2Fclosed-principle"></a> Open/closed principle 

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
        return switch operation {
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

### <a name="liskov-substitution-principle"></a> Liskov substitution principle

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


### <a name="interface-segregation-principle"></a> Interface segregation principle

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


### <a name="dependency-inversion-principle"></a> Dependency inversion principle

Принцип зависимости инверсий гласит, что реализации должны зависеть только от интерфейсов.

Например: пусть будет консольный логгер для клиента, сделаем зависимость клиента от методов логгер, тогда, когда мы захотим сделать второй логгер, файловый, то придется изменять логику клиента. В этом случае лучше сделать прослойку, состоящую из интерфейса логгера - мы избавляемся от сильной связанности между типами, улучшаем расширяемость типов и упрощаем тестирование

> **Dependency inversion principle** - проектирование типов, таким образом, что одни реализации не зависят от других напрямую




