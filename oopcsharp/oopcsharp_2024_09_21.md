## Лекция 3. Принципы SOLID

<!-- Лектор - Круглов Г. Н. -->

Принципы SOLID были сформированы в статье Роберта Мартина "Design Principles and Design Patterns" ([источник](https://web.archive.org/web/20150906155800/http://www.objectmentor.com/resources/articles/Principles_and_Patterns.pdf)) в 2000 году, которые были предложены в ответ на деградацию программного обеспечения - процесс, в течение которого код становится трудно поддерживаемым

Аббревиатура SOLID состоит из первых букв названий соответствующих принципов:

* Single Responsibility Principle (SRP) - принцип единственной ответственности
* Open-Closed Principle (OCP) - принцип открытости/закрытости
* Liskov Substitution Principle (LSP) - принцип подстановки Лисков
* Interface Segregation Principle (ISP) - принцип разделения интерфейса
* Dependency Inversion Principle (DIP) - принцип инверсии зависимостей

### Принцип единственной ответственности

Принцип единственной ответственности (SRP) гласит, что класс должен быть ответственным только за одну сущность

Например: делать класс, который создает отчеты и для Excel, и в .pdf - плохо, так как в них могут быть методы с одинаковыми названиями, но с разной логикой, этот класс будет труднее изменять

```cs
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

```cs
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

### Принцип открытости/закрытости


Принцип открытости и закрытости гласит, что программные сущности должны быть открытыми для расширения и закрытыми для изменения

Пример несоблюдения OCP:

```cs
public enum BinaryOperation
{
    Summation,
    Subtraction,
}

public class BinaryOperand
{
    private readonly int _left;
    private readonly int _right;

    public BinaryOperand(int left, int right)
    {
        _left = left;
        _right = right;
    }

    public int Evaluate(BinaryOperation operation) => operation switch
    {
        BinaryOperation.Summation => _left + _right,
        BinaryOperation.Subtraction => _left - _right,
    };
}
```

В этом примере калькулятор использует перечисления для определения оператора и оператор `switch`, чтобы возвращать нужный результат. В итоге, чтобы добавить операцию умножения, нужно изменить инструкции в операторе `switch`. Поэтому более расширяемым будет такой код:

```cs
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

    public BinaryOperand(int left, int right)
    {
        _left = left;
        _right = right;
    }

    public int Evaluate(IBinaryOperation operation)
        => operation.Evaluate(_left, _right);
}
```

Создаем интерфейс операции, классы конкретных операторов с их реализацией, и передаем объекты классов в класс `BinaryOperand`


### Принцип подстановки Лисков

Принцип подстановки Лисков гласит, что при замене похожих объектов логика программы не должна нарушаться

Например: создадим классы для обычной птицы, пингвина и летучей мыши, чтобы заставить их мигрировать:

```cs
public record Coordinate(int X, int Y);

public class Creature
{
    public void Die()
    {
        Console.WriteLine("Я мертв");
    }
}

public class Bird : Creature
{
    public virtual void FlyTo(Coordinate coordinate)
    {
        Console.WriteLine("Я летаю");
    }
}

public class Penguin : Bird
{
    public override void FlyTo(Coordinate coordinate)
    {
        Die();  // пингвины не летают :(
    }
}

public class Bat : Creature
{
    public void FlyTo(Coordinate coordinate)
    {
        Console.WriteLine("Я летучая мышь и летаю");
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

```cs
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
        Console.WriteLine("Я мертв");
    }
}

public class Bird : CreatureBase {
    public virtual void FlyTo(Coordinate coordinate)
    {
        Console.WriteLine("Я летаю");
    }
}

public class Penguin : Bird { }

public class Hummingbird : Bird, IFlyingCreature
{
    public void FlyTo(Coordinate coordinate)
    {
        Console.WriteLine("Я колибри и летаю");
    }
}

public class Bat : CreatureBase, IFlyingCreature
{
    public void FlyTo(Coordinate coordinate)
    {
        Console.WriteLine("Я летучая мышь и летаю");
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

### Принцип разделения интерфейса


Принцип разделения интерфейса является аналогом SRP для интерфейсов - когда абстракции начинают выполнять больше одной задачи, их реализации тоже начинают брать более одной ответственности.

Поэтому лучше делать не так:

```cs
public interface ICanAllDevice
{
    void Print();
    void PlayMusic();
    void BakeBread();
}
```

А так:

```cs
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

### Принцип зависимости инверсий

**Принцип зависимости инверсий** (Dependency Inversion Principle) гласит, что реализации должны зависеть только от интерфейсов, а не от самих реализаций

Например: есть общий сервис `NotificationService`, отправляющий уведомления, который использует определенный отправитель для электронной почти и для SMS:

```cs
public class EmailSender
{
    public void Send(string message) => Console.WriteLine($"Email: {message}");
}

public class SmsSender
{
    public void Send(string message) => Console.WriteLine($"SMS: {message}");
}

public class NotificationService
{
    private readonly EmailSender _emailSender;
    private readonly SmsSender _smsSender;

    public NotificationService()
    {
        _emailSender = new EmailSender();
        _smsSender = new SmsSender();
    }

    public void NotifyByEmail(string message) => _emailSender.Send(message);
    public void NotifyBySms(string message) => _smsSender.Send(message);
}

var service = new NotificationService();
service.NotifyByEmail("Hello!");
service.NotifyBySms("Hello!");
```

Получаем, что `NotificationService` зависит от реализаций `EmailSender` и `SmsSender`, несмотря на то, что они выполняют одну цель - отправить сообщение методом `Send`. Поэтому лучше сделать интерфейс `IMessageSender`, реализации которого принимает `NotificationService`:

```cs
public interface IMessageSender
{
    void Send(string message);
}

public class EmailSender : IMessageSender
{
    public void Send(string message) => Console.WriteLine($"Email: {message}");
}

public class SmsSender : IMessageSender
{
    public void Send(string message) => Console.WriteLine($"SMS: {message}");
}

public class PushSender : IMessageSender
{
    public void Send(string message) => Console.WriteLine($"Push: {message}");
}

public class NotificationService
{
    private readonly IMessageSender _messageSender;

    public NotificationService(IMessageSender messageSender)
    {
        _messageSender = messageSender;
    }

    public void Notify(string message) => _messageSender.Send(message);
}

var emailService = new NotificationService(new EmailSender());
emailService.Notify("Hello by Email");

var smsService = new NotificationService(new SmsSender());
smsService.Notify("Hello by SMS");

var pushService = new NotificationService(new PushSender());
pushService.Notify("Hello by Push");
```

