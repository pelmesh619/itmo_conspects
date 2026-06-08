## Лекция 7. Структурные паттерны

<!-- Лектор - Круглов Г. Н. -->

На этой лекции разберем структурные паттерны (Structural Patterns), которые помогают в проектировании проектной модели

### Адаптер

**Адаптер** (Adapter) - промежуточный тип, использующий объект одного типа, для реализации интерфейса другого типа

Для применения паттерна "_Адаптер_" обычно есть цель (Target), которая представляет целевой интерфейс, через который мы хотим взаимодействовать с объектом, изначально его не реализующий. Далее должен быть адаптируемый тип (Adaptee) с другим интерфейсом, который мы хотим использовать через целевой интерфейс с помощью _адаптера_ - обертки, реализующей целевой интерфейс, содержащей объект адаптируемого типа и перенаправляющей в него вызовы поведений целевого интерфейса

Яркий пример применения _адаптера_ - это различие форматов розетки и вилки во всем мире. Так, например, британский стандарт использует три прямоугольных штыря - один для фазы, другой для нейтрали, а третий для заземления. Чтобы подключить британскую вилку (она является адаптируемым типом) к европейской розетке, которая принимает европейские вилки, состоящей из двух цилиндрических штырей (это целевой интерфейс), нужен адаптер - кусок пластика с металлическим контактами, которые изогнуты так, чтобы подключать британскую вилку к европейской розетке

С помощью _адаптера_ можно достичь полиморфизма между несовместимыми объектами. Например: есть два типа логгеров, которые имеют разный интерфейс, но нужно к ним обращаться одинаково:

```csharp
public class PostgresLogStorage
{
    public void Save(
        string message,
        DateTime timeStamp,
        int severity)
    {
        ...
    }
}
public class ElasticSearchLogStorage
{
    public void Save(ElasticLogMessage message)
    {
        ...
    }
}
public interface ILogStorage
{
    void Save(LogMessage message);
}

public class PostgresLogStorageAdapter : ILogStorage
{
    private readonly PostgresLogStorage _storage;
    public void Save(LogMessage message)
    {
        _storage.Save(
            message.Message,
            message.DateTime,
            message.Severity.AsInteger());
    }
}
public class ElasticLogStorageAdapter : ILogStorage
{
    private readonly ElasticSearchLogStorage _storage;
    public void Save(LogMessage message)
    {
        _storage.Save(message.AsElasticLogMessage());
    }
}
```

И вся прелесть _адаптеров_ раскрывается в том случае, если эти логгеры из _разных_ библиотек - естественно, мы не можем менять их исходный код и исправлять интерфейсы друг под друга

Помимо этого адаптеры это:

* соблюдение _принципов открытости/закрытости_ и _инверсии зависимостей_
* изоляция объектной модели (то, чего мы достигаем при помощи абстракций)

Помимо этого с помощью _адаптеров_ можно проводить адаптивный рефакторинг. Допустим, что есть такая ситуация: все долгие годы мы использовали в проекте старый синхронный логгер, теперь все процессы в коде асинхронные, и нам нужен асинхронный логгер. Тогда сделаем все в 2 шага:

1. Меняем абстракцию - создаем крутой _адаптер_, интерфейс которого поддерживает и старую, и новую реализации, и используем этот адаптер в нашем коде
2. Меняем реализацию - подставляем в этот _адаптер_ асинхронный логгер

Таким образом, мы получаем два этапа, которые легче тестировать по отдельности

### Мост

Допустим, что у нас есть абстракции сложные (низкоуровневые) и простые (верхнеуровневые). Тогда, чтобы через простую абстракцию использовать сложную, создадим _мост_

**Мост** (Bridge) - это объект, который разделяет один или несколько классов на две отдельные иерархии, позволяя изменять их независимо друг от друга

Пусть у нас будет сложное устройство "Телевизор":

```csharp
public interface IDevice
{
    public bool IsEnabled { get; set; }
    public int Channel { get; set; }
    public int Volume { get; set; }
}
```

И простое устройство "Пульт управления":

```csharp
public interface IControl
{
    void ToggleEnabled();
    void ChannelForward();
    void ChannelBackward();
    void VolumeUp();
    void VolumeDown();
}
```

Мост между ними будет выглядеть так:

```csharp
public class Control : IControl
{
    private readonly IDevice _device;
    public void ToggleEnabled()
        => _device.IsEnabled = !_device.IsEnabled;
    public void ChannelForward()
        => _device.Channel += 1;
    public void ChannelBackward()
        => _device.Channel -= 1;
    public void VolumeUp()
        => _device.Volume += 10;
    public void VolumeDown()
        => _device.Volume -= 10;
}
```

При помощи _моста_ мы можем разделить объектную модель на две иерархии - иерархию пультов и телевизоров

Можем заметить, что по сути _мост_ - это адаптер, поэтому _мост_ тоже соблюдает _принципы открытости/закрытости_ и _инверсии зависимостей_. Отличие _моста_ от адаптера в том, что _мост_ проектируется изначально

### Компоновщик

**Компоновщик** (Composite) - это представление древовидной структуры объектов в виде одного композитного объекта

Допустим, что у нас есть куча объектов, реализующих один интерфейс, и мы хотим сделать со всеми ними какое-то действие:

```csharp
public interface IGraphicComponent
{
    void MoveBy(int x, int y);
    void Draw();
}
public class Circle : IGraphicComponent
{
    public void MoveBy(int x, int y) { ... }
    public void Draw() { ... }
}
public class Line : IGraphicComponent
{
    public void MoveBy(int x, int y) { ... }
    public void Draw() { ... }
}
```

Сделаем из них объект-_компоновщик_ `GraphicComponentGroup`, который циклом проходится и выполняет это действие у всех объектов:

```csharp
public class GraphicComponentGroup : IGraphicComponent
{
    private readonly IReadOnlyCollection<IGraphicComponent> _components;
    public void MoveBy(int x, int y)
    {
        foreach (var component in _components)
            component.MoveBy(x, y);
    }
    public void Draw()
    {
        foreach (var component in _components)
            component.Draw();
    }
}
```

### Декоратор

**Декоратор** (Decorator) - это тип-обёртка над объектом абстракции, которую он реализует, добавляя к поведению объекта новую логику

Допустим у нас есть абстракция какого-то абстрактного сервиса:

```csharp
public interface IService
{
    void DoStuff(DoStuffArgs args);
}
public class Service : IService
{
    public void DoStuff(DoStuffArgs args) { }
}
```

В последствии возникла потребность журналировать все, что делает сервис. Тогда для нашего декорируемого типа (Decoratee), сделаем _декоратор_ `LoggingServiceDecorator`, реализующий наш интерфейс и расширяющий функционал:

```csharp
public class LoggingServiceDecorator : IService
{
    private readonly IService _decoratee;
    private readonly ILogger _logger;
    public void DoStuff(DoStuffArgs args)
    {
        _logger.Log(ArgsToLogMessage(args));
        _decoratee.DoStuff(args);
    }
    private static string ArgsToLogMessage(DoStuffArgs args) { ... }
}
```

### Заместитель

**Заместитель** (или прокси, Proxy) - тип-обёртка, реализующий логику контроля доступа к объекту, реализующему абстракцию, которую реализует он сам

Возьмем для примера обычный сервис, реализующий интерфейс:

```csharp
public interface IService
{
    void DoOperation(OperationArgs args);
}
public class Service : IService
{
    public void DoOperation(OperationArgs args) { }
}
```

Рассмотрим несколько видов _заместителей_:

* Виртуальный _прокси_ (Virtual proxy)

    Если у нас есть какой-то прям тяжелый объект, который мы хотим инициализировать тогда, когда он нам прям нужен, то нам поможет виртуальный _прокси_:

    ```csharp
    public class VirtualServiceProxy : IService
    {
        private readonly Lazy<IService> _service =
            new Lazy<IService>(() => new Service());
        public void DoOperation(OperationArgs args)
        {
            _service.Value.DoOperation(args);
        }
    }
    ```

* Защищающий _прокси_ (Defensive proxy)

    Используется, если нужно ограничить доступ к объекту:

    ```csharp
    public class ServiceAuthorizationProxy : IService
    {
        private readonly IService _service;
        private readonly IUserInfoProvider _userInfoProvider;
        public void DoOperation(OperationArgs args)
        {
            if (_userInfoProvider.GetUserInfo().IsAuthenticated)
                _service.DoOperation(args);
        }
    }
    ```

* Кеширующий _прокси_ (Caching proxy)

    Используется, если выполнение операции обходится дорого, и мы не хотим каждый раз заново вызывать ее:

    ```csharp
    public class CachingServiceProxy : IService
    {
        private readonly IService _service;
        private readonly Dictionary<OperationArgs, OperationResult> _cache;
        public OperationResult DoOperation(OperationArgs args)
        {
            if (_cache.TryGetValue(args, out var result))
                return result;

            return _cache[args] = _service.DoOperation(args);
        }
    }
    ```

* Удаленный _прокси_ (Remote proxy)

    Используется, если нужно работать с интерфейсом, который не лежит в программе (это может быть классом, который оборачивает HTTP-вызовы)

Как можно заметить, _прокси_ очень подозрительно похож на _декоратор_, однако:

* _Декоратор_ обязан вызывать метод декорируемого типа, тогда как _прокси_ может этого не делать (оборачиваемый объект может и не существовать)
* _Декоратор_ расширяет логику, _прокси_ же контролирует объект
* _Прокси_ - это агрегация или ассоциация, тогда как _декоратор_ - это агрегация

<!-- тяп ляп зеленая галочка -->

### Фасад

> Facade (Фасад) - оркестрация одной или набора сложных операция в каком-либо типе

Фасад рассматривался как контроллер в GRASP. Фасад лучше не использовать, потому что существуют:

* риск сделать класс-бог, который очень много в себя берет
* потеря абстракций засчёт переиспользования логики внутри фасада
* тяжесть рефакторинга и декомпозиции

Но фасад может быть полезен в request-response модели, например, как объектная обертка API вызовов

### Легковес

> Flyweight (Легковес) - декомпозиция объектов, выделенные тяжелых и повторяющихся данных в отдельные модели для дальнейшего переиспользования

При помощи легковеса мы можем отделить тяжелый объект, чтобы каждый раз пользоваться им по ссылке и не создавать новый

```csharp
public record Particle(int X, int Y, byte[] Model);

public class ParticleFactory
{
    private readonly IAssetLoader _assetLoader;
    public Particle Create(string modelName)
    {
        var model = _assetLoader.Load(modelName);
        return new Particle(0, 0, model);
    }
}

public record ModelData(byte[] Value);

public record Particle(int X, int Y, ModelData Model);

public class ParticleFactory
{
    private readonly IAssetLoader _assetLoader;
    private readonly Dictionary<string, ModelData> _cache;
    public Particle Create(string modelName)
    {
        var model = _cache.TryGetValue(modelName, out var data)
            ? data
            : _cache[modelName] =
                new ModelData(_assetLoader.Load(modelName));
        return new Particle(0, 0, model);
    }
}
```
