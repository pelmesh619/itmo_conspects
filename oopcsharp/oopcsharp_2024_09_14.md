## Лекция 2. Проектирование модели

<!-- Лектор - Круглов Г. Н. -->

### Иммутабельность

**Иммутабельность** (от immutable) или неизменяемость - свойство данных, не подразумевающее изменения в ООП, которое используется в виде сокрытия изменяемых данных, значения которых не требуют изменений

Изменчивость (или мутабельность) данных усложняет систему, повышая количество допускаемых состояний, из-за чего система становится менее предсказуемой

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

В итоге мы поставили ограничение, что идентификатор и имя группы мы можем только инициализировать

### Методы `Find`/`Get`

Если же у нас есть метод, который возвращает объект `X`, то неплохо было бы определиться, что будет происходить, если метод не нашел этот `X`. Тогда можно действовать так:

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

### Обработка ошибок

При использовании исключений могут возникнуть следующие ситуации:

* исключения не отражены в сигнатуре метода
* поиск конкретного типа исключения и ситуации, когда оно кидается, приводят к протекшей абстракции
* неудачное выполнение операции != исключительная ситуация

**Протекшая абстракция** - это абстракция, для работы с которой, необходимо иметь знание о деталях ее реализации

Вместо исключений можно возвращать `bool`, который означает успех операции:

```csharp
if (long.TryParse("123", out long number))
{
    Console.WriteLine(number);
}
```

Но, если нам нужно более 2 значений, чтобы передать, что именно пошло не так, можно воспользоваться типом результата (Result type):

```csharp
public abstract record AddStudentResult
{
    private AddStudentResult() { }
    public sealed record Success : AddStudentResult;
    public sealed record AlreadyMember : AddStudentResult;
    public sealed record StudentLimitReached(int Limit) : AddStudentResult;
}
```

Здесь описаны 3 результата: успех, студент уже является участником группы и предел группы превышен. Также используются ключевые слова `record`, позволяющее упростить синтаксис кода, и `sealed`, гарантирующее, что от типа нельзя наследовать другой тип, обозначающий другой результат

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

И после этого уже проверять наш тип результата:

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

### Предметно-ориентированное проектирование

Предметно-ориентированное проектирование (Domain driven design, DDD) - проектирование, ориентированное на нужную нам предметную область (или домен), например, область, состоящая из студентов, предметов и преподавателей

При проектировании появляется модель - абстракция, которая упрощённо описывает предметную область, предметы в нем и их взаимоотношений

Рассмотрим паттерны, которые применяются в предметно-ориентированном проектировании:

* Объект со значением (Value Object)

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

    И в этом случае деньги будут объектом со значением, который не позволит отрицательное значение

* Файловая структура

    Также структура файлов проекта должна быть семантической, а не инфраструктурной для упрощенного поиска той или иной сущности

    ![Файловая структура](images/oopcsharp_2024_09_14_01.png)

    Под семантикой подразумевается смысл того, что делает конкретный программный модуль. Поэтому вместо того, чтобы отделять сущности, модели и сервисы, намного более понятно разделять компоненты по тому, с каким объектом модели они взаимодействуют
