## Лекция 2. Проектирование модели

### Иммутабельность

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

### Find/Get

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


### Обработка ошибок

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


### Domain Driven Design

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

