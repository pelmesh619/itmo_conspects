## Лекция 9. Поведенческие паттерны. Воркшоп 4 

<!-- Лектор - Круглов Г. Н. -->

На этом воркшопе будут рассматриваться поведенческие паттерны. Рассматриваемый код доступен в этом репозитории: <https://github.com/is-oop-y27/workshop-4>

### Template method

> Шаблонный метод

Проблема: у нас в методе есть кусочек кода, который мы хотим параметризировать - изменять для разных обстоятельств этот кусочек кода.

Пример: у нас есть куча сотрудников, у которых есть количество выполненных задач и количество отработанных часов, хотим иметь возможность делать сортировку по этим параметрам. Сделаем `IEmployeeEvaluator`

```csharp
public interface IEmployeeEvaluator
{
    Employee FindBestEmployee(IEnumerable<RatedEmployee> employees);
}
```

и абстрактный класс:

```csharp
public abstract class EmployeeEvaluatorBase : IEmployeeEvaluator
{
    public Employee FindBestEmployee(IEnumerable<RatedEmployee> employees)
    {
        IEnumerable<RatedEmployee> sorted = Sort(employees);
        return sorted.First().Employee;
    }

    protected abstract IEnumerable<RatedEmployee> Sort(
        IEnumerable<RatedEmployee> employees);
}
```

Здесь `Sort` - _шаблонный метод_. Для различных реализаций мы можем переопределять это защищенный метод, который используется в методе абстрактного класса.

```csharp
public class TaskEmployeeEvaluator : EmployeeEvaluatorBase
{
    protected override IEnumerable<RatedEmployee> Sort(
        IEnumerable<RatedEmployee> employees)
    {
        return employees.OrderByDescending(x => x.Rating.TaskCompletedCount);
    }
}

public class HoursEmployeeEvaluator : EmployeeEvaluatorBase
{
    protected override IEnumerable<RatedEmployee> Sort(IEnumerable<RatedEmployee> employees)
    {
        return employees.OrderByDescending(x => x.Rating.HoursWorked);
    }
}
```

Как можем заметить, шаблонный метод подозрительно похож на [фабричный метод](https://pelmesh619.github.io/itmo_conspects/oopcsharp/oopcsharp_superconspect.html#-factory-method), у него такие же недостатки: 

* неявное нарушение SRP
* сильная связность из-за наследования

При этом фабричный метод - паттерн порождающий, а шаблонный - поведенческий. Полный код примера с шаблонным методом - https://github.com/is-oop-y27/workshop-4/tree/master/src/1_TemplateMethod

### Strategy

> Стратегия

Проблема: та же, что и с шаблонным методом - параметризируем задачу; отличие в том, что в шаблонном методе используем наследование, а в стратегии - композицию

Пример: тот же самый: сортировка сотрудников. Здесь вынесем метод `Sort` в классы `EmployeeSorter`, которые будем передавать в `EmployeeEvaluator`:

```csharp
var sorter = new TaskEmployeeSorter();

var evaluator = new EmployeeEvaluator(sorter);

Employee bestEmployee = evaluator.FindBestEmployee(ratedEmployees);
```

Помимо этого этот `sorter` можно использовать в двух или более местах.

В целом, стратегией можно называть любую выделенную абстракцию. Код стратегии: https://github.com/is-oop-y27/workshop-4/tree/master/src/2_Strategy

### Responsibility chain

> Цепочка обязанностей

Проблема: хотим иметь настраиваемое подобие switch-case, для этого сделаем обработчики - сущности, которые принимают какое-то значение и решают, что делать: обрабатывать их и/или передавать следующим обработчикам.

Пример: парсинг аргументов. Пускаем по цепочке обработчиков слово из командной строки: если это какое-то имя аргумента, начинающееся с дефиса, то парсим следующее слово, иначе передаем другому обработчику в цепочке:

```csharp
public class OutputRunner : IOutputRunner
{
    private readonly IParameterHandler _handler;

    public OutputRunner(IParameterHandler handler)
    {
        _handler = handler;
    }

    public void Run(IEnumerable<string> args)
    {
        using IEnumerator<string> request = args.GetEnumerator();
        ITextModifier? modifier = null;

        while (request.MoveNext())
        {
            ITextModifier? nextModifier = _handler.Handle(request);

            if (nextModifier is not null)
            {
                modifier = new AggregateModifier(modifier, nextModifier);
            }
        }

        var text = "Hello world!";
        text = modifier?.Modify(text) ?? text;

        Console.WriteLine(text);
    }
}
```


В итоге, каждый обработчик ответственнен за одну какую-то штуку. Код пример цепочки: https://github.com/is-oop-y27/workshop-4/tree/master/src/3_ResponsibilityChain

### Observer

> Издатель - подписчик

Проблема: у нас есть сущность, которая производит какие-то события, и сущности, которые хотят отслеживать эти события

Пример: есть годовалый ребенок, о чьих события родители хотели бы знать. В этом случае ребенок - издатель событий, а родители - подписчики. Другой пример: чатик и сообщения, в этом случае чат - это издатель, а пользователи - подписчики:

```csharp
public interface IChatObserver
{
    void OnChatMessageReceived(ChatUserMessage message);
}

public class Chat
{
    private readonly List<IChatObserver> _observers = [];

    public Chat(long id, string name)
    {
        Id = id;
        Name = name;
    }

    public long Id { get; }

    public string Name { get; }

    public void SendMessage(UserMessage message)
    {
        foreach (IChatObserver observer in _observers)
        {
            observer.OnChatMessageReceived(new ChatUserMessage(
                this,
                message));
        }
    }

    public void AddObserver(IChatObserver observer)
    {
        _observers.Add(observer);
    }
}
```

Код издателя-подписчика: https://github.com/is-oop-y27/workshop-4/tree/master/src/4_Observer

### Command

> Команда

Вместо того, чтобы вызывать метод, мы создаем объект, метод которого выполняет нужный нам метод. В итоге с такими объектами появляется больше возможностей, чем с обычными методами: их мы можем вызывать, когда и как захотим, например, фильтровать команды, логгировать, устранять дубликаты.

Пример использования команд: todo список, где команда - это изменение списка. В этом случае для каждой команды мы можем определить обратную к ней и откатывать состояние todo списка

Пример использования команд в веб-приложении: https://github.com/is-oop-y27/workshop-4/tree/master/src/5_Command

### Visitor

> Визитор

Не всегда какая-то дополнительная логика хорошо привязана к объектной модели. С помощью визитора можно добавлять дополнительные операции, не модифицируя наш объект

Пример: делаем вывод дерева файловой системы, для этого сделаем визитор, реализующий этот интерфейс с методами посещения файла и директории:

```csharp
public interface IFileSystemComponentVisitor
{
    void Visit(FileFileSystemComponent component);

    void Visit(DirectoryFileSystemComponent component);
}
```

В реализации `ConsoleVisitor` сделаем вывод имени файла/директории

А в самих объектах, представляющих файлы и директории, сделаем метод `Accept(IFileSystemComponentVisitor visitor)`:

```csharp
public void Accept(IFileSystemComponentVisitor visitor)
{
    visitor.Visit(this);
}
```

Этот метод дает объекту понять, что его посетили, и дает свой тип визитору. Тем самым вот так

```csharp
var factory = new FileSystemComponentFactory();
IFileSystemComponent component = factory.Create("sample_folder");

var visitor = new ConsoleVisitor();

component.Accept(visitor);
```

мы можем пройтись по всем директории и файлам в них. Код примера: https://github.com/is-oop-y27/workshop-4/blob/master/src/6_Visitor

### Snapshot

> Снимок

В паттерне снимок есть 2 сущности:

Ориджинатор (Originator) - сущность, снимки которой мы хотим сохранять

Кейртейкер (Caretaker) - сущность, которая хранит снимки

По сути снимок - это просто копия всех полей ориджинатор в конкретный момент времени. Благодаря этому, мы можем вернуть ориджинатор к какому-то предыдущему состоянию из прошлого

Пример:

```csharp
var caretaker = new TextFieldHistory(new TextField());

caretaker.UpdateValue("1");
TextFieldSnapshot snapshot = caretaker.UpdateValue("2");

Console.WriteLine(string.Join("\n", caretaker.History.Select(x => x.ToString())));

Console.WriteLine(caretaker.Value);
caretaker.Restore(snapshot);
Console.WriteLine(caretaker.Value);
```

Здесь кейртейкер хранит в себе и ориджинатор и может изменять его через свой метод, возвращающий снимок. Код из примера: https://github.com/is-oop-y27/workshop-4/tree/master/src/7_Snapshot

Но в каком-то случае использования, если изменяемый объект тяжелый, а изменения маленькие, то лучше использовать команды

### State

> Состояние

По сути, просто конечная машина состояний (finite state machine) - представляем объекты как состояния, а переходы между ними как методы, возвращающие результирующий тип, показывающий, есть такой переход или нет

Машина состояний на примере состояний лабораторной работы:

```csharp
var submission = new Submission(new ActiveSubmissionStateHandler());

submission.Complete();
submission.Ban();

SubmissionActionResult result = submission.Complete();
Console.WriteLine(result);
```

Код примера: https://github.com/is-oop-y27/workshop-4/blob/master/src/8_State


### Iterator

> Итератор

Ну тут нечего говорить, паттерн, при помощи которого можем проитерироваться по сложной штуковине. 

В C# итерируемые объекты реализованы через интерфейс `IEnumerable`, метод `GetEnumerator` 
которого возвращает "итератор" - реализацию интерфейса `IEnumerator`:

* с методом `GetNext()` - подвинуть итератор вперед
* со свойство `Current` - получить значение по итератору
* и с методом `Reset()` - сбросить итератор к начальному значению

Применяя это к примеру файловой системы выше, с помощью методов расширения:

```csharp
public static class FileSystemComponentExtensions
{
    public static IEnumerator<IFileSystemComponent> EnumerateBreadth(this IFileSystemComponent component)
        => new FileSystemBreadthIterator(component);

    public static IEnumerator<IFileSystemComponent> EnumerateDepth(this IFileSystemComponent component)
        => new FileSystemDepthIterator(component);
}
```

и реализации итераторов (в данном кейсе сделаем итераторы обходов в глубину и в ширину) мы можем сделать так:

```csharp
var factory = new FileSystemComponentFactory();
IFileSystemComponent component = factory.Create("sample_folder");

using IEnumerator<IFileSystemComponent> breadthIterator = component.EnumerateBreadth();

while (breadthIterator.MoveNext())
{
    Console.WriteLine(breadthIterator.Current.Name);
}
```

Код примера итератора: https://github.com/is-oop-y27/workshop-4/tree/master/src/9_Iterator

