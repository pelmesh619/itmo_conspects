## Лекция 11. Воркшоп 5

<!-- Лектор - Макаревич Р. Д. -->

> На пятом воркшопе разбирался код абстрактного магазина, спроектированного по трехслойной архитектуре. Код воркшопа: <https://github.com/is-oop-y27/workshop-5/>

Проект с воркшопа использует анемичную модель данных. Если взглянуть на структуру проекта, то мы увидим это:

```tree
📂src
    📂Application
        📂Workshop5.Application
            📂Extensions
                📄ServiceCollectionExtensions.cs
            📂Shops
                📄ShopService.cs
            📂Users
                📄CurrentUserManager.cs
                📄UserService.cs
            📄Workshop5.Application.csproj
        📂Workshop5.Application.Abstractions
            📂Repositories
                📄IShopRepository.cs
                📄IUserRepository.cs
            📄Workshop5.Application.Abstractions.csproj
        📂Workshop5.Application.Contracts
            📂Shops
                📄IShopService.cs
            📂Users
                📄ICurrentUserService.cs
                📄IUserService.cs
                📄LoginResult.cs
            📄Workshop5.Application.Contracts.csproj
        📂Workshop5.Application.Models
            📂Products
                📄Product.cs
                📄ProductCategory.cs
            📂Shops
                📄Shop.cs
            📂Users
                📄User.cs
                📄UserRole.cs
            📄Workshop5.Application.Models.csproj
    📂Infrastructure
        📂Workshop5.Infrastructure.DataAccess
            📂Extensions
                📄ServiceCollectionExtensions.cs
                📄ServiceScopeExtensions.cs
            📂Migrations
                📄01_Initial.cs
            📂Plugins
                📄MappingPlugin.cs
            📂Repositories
                📄ShopRepository.cs
                📄UserRepository.cs
            📄Workshop5.Infrastructure.DataAccess.csproj
    📂Presentation
        📂Workshop5.Presentation.Console
            📄ChainLinkBase.cs
            📂Extensions
                📄ServiceCollectionExtensions.cs
            📄IChainLink.cs
            📄IScenario.cs
            📄IScenarioProvider.cs
            📄ScenarioRunner.cs
            📂Scenarios
                📂AddShopProduct
                    📄AddShopProductScenario.cs
                📂Login
                    📄LoginScenario.cs
                    📄LoginScenarioProvider.cs
            📄Workshop5.Presentation.Console.csproj
    📂Workshop5
        📄Program.cs
        📄Workshop5.csproj
```

Основной код разделен на три папки: `Infrastructure`, `Presentation` и `Application`. Как можем заметить, все типы в бизнес-логике `Application` разделены на 3 вида:

* Классы типа `record`, хранящие данные: `User`, `Shop`, `Product`, `ProductCategory`
* Интерфейсы сервисов, реализации которых хранят логику: `ICustomerUserService`, `IUserService`, `IShopService`
* Интерфейсы репозиториев для доступа к базе данных

Здесь мы приходим к концепции внедрения зависимостей (Dependency Injection, подробнее на [learn.microsoft.com](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection-basics)).

Идея: сделаем коллекцию сервисов, положим туда наших сервисов, построим ее и получим поставщика сервисов - далее в любом месте нашего проекта мы сможем доставать из поставщика услуг нужные нам сервисы, не заботясь о их инициализации.

В .NET внедрение зависимостей реализовано с помощью пакета `Microsoft.Extensions.DependencyInjection`. Пример его работы:

```csharp
// Сделаем сервисы вывода в консоль
public interface IMyConsole {
    void Write(string output);
};

public class MyConsole {
    void Write(string output) {
        Console.WriteLine(output);
    }
};

// Сделаем сервис вывода имени
public class MyAnotherService(IMyConsole console)
{
    public void SayMyName(string name)
    {
        console.WriteLine(name);
        console.WriteLine("> You're god damn right!");
    }
}

// Создаем коллекцию
var services = new ServiceCollection();

// Добавляем сервисы
services.AddSingleton<IMyConsole, MyConsole>();
services.AddSingleton<MyAnotherService>();

// Билдим поставщик сервисов
var serviceProvider = services.BuildServiceProvider();
```

Теперь, получая поставщик сервисов, мы можем запросить какой-либо сервис через метод:

* `GetService<T>()`, который возвращает сервис типа `T?`
* `GetRequiredService<T>()`, который возвращает сервис типа `T` или вызывает исключение

Теперь участники архитектуры будут доставать из этого контейнера нужным им интерфейс сервиса.

Также у сервисов есть циклы жизни, которые устанавливаются непосредственно до сборки провайдера:

* Временный сервис (Transient) - каждый раз при вызове `GetService` создается новый объект сервиса

* Ограниченный областью сервис (Scoped) - сервис живет в рамках одной явно установленной области жизни (scope)

    ```csharp
    // начало скоупа
    var scope = provider.CreateScope();

    // вызов сервиса
    T t = scope.ServiceProvider.GetRequiredService<T>();

    // вызов того же сервиса
    T t2 = scope.ServiceProvider.GetRequiredService<T>();

    // конец скоупа
    scode.Dispose();
    ```

    Сервисы, возвращенные непосредственно через провайдера, живут в глобальной области, которая заканчивается с удалением провайдера

* Сервис-одиночка (Singleton) - единственный объект сервиса на контейнер (как в примере выше)

Самая главное преимущество этого провайдера - внедрение зависимостей. Для примера выше такой код:

```csharp
serviceProvider.GetRequiredService<MyAnotherService>().SayMyName("Walter White");
```

выведет в консоль текст, несмотря на то, что конструктор `MyAnotherService` требует сервис `IMyConsole` - поставщик сервисов догадался об этом и засунул вместо `IMyConsole` добавленный нами ранее `MyConsole`.

При помощи расширений в C# мы можем добавить расширение для `ServiceCollection`, которое пачкой добавляет нужные нам сервисы для нашего проекта, например, `Workshop5.Application/Extensions/ServiceCollectionExtensions`:

```csharp
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddApplication(this IServiceCollection collection)
    {
        collection.AddScoped<IUserService, UserService>();
        collection.AddScoped<IShopService, ShopService>();

        collection.AddScoped<CurrentUserManager>();
        // Здесь мы добавили в качестве аргумента метода фабрику 
        // по созданию реализации интерфейса ICurrentUserService
        collection.AddScoped<ICurrentUserService>(
            p => p.GetRequiredService<CurrentUserManager>());

        return collection;
    }
}
```

---

<!-- [на этом этапе я перестал слушать (каюсь), поэтому мельком прокомментирую код] -->

Рассмотрим слой `Infrastructure`. В файле [`Infrastructure/Workshop5.Infrastructure.DataAccess/Migrations/01_Initial.cs`](https://github.com/is-oop-y27/workshop-5/blob/master/src/Infrastructure/Workshop5.Infrastructure.DataAccess/Migrations/01_Initial.cs) происходит миграция базы данных. При помощи библиотеки `Itmo.Dev.Platform.Postgres` мы устанавливаем то, как будет создана (и удалена) наша база данных через SQL-запросы

Здесь же в слое `Infrastructure` представлены реализации репозиториев, которые связывают слои `Application` и `Infrastructure` и содержит SQL-запросы к БД для получения данных и преобразования этих данных в объекты домена

Далее при помощи расширений мы можем добавить репозитории и другие сервисы в провайдер сервисов

---

В слое `Presentation` мы реализуем представление в консоль при помощи пакета `Spectre.Console`

Поведение представления реализуем с помощью сценариев (данный воркшоп реализует сценарии входа в систему и частично выбора магазина). Далее `ScenarioRunner` предлагает выбрать нужный сценарий пользователю через умную консоль из `Spectre.Console` и запускает его

<!-- почему-то явно видно, что воркшоп не дописан, раз есть IChainLink и ChainLinkBase, хотя уже год прошел😡😡😡 -->

<!-- лол 👆, привет из 2026 -->

---

В итоге [точка входа](https://github.com/is-oop-y27/workshop-5/blob/master/src/Workshop5/Program.cs) нашей программы выглядит так:

```csharp
var collection = new ServiceCollection();

collection
    // Добавляем сервисы из Application
    .AddApplication()
    // Добавляем сервисы из Infrastructure и настраиваем подключение
    // к базе данных
    .AddInfrastructureDataAccess(configuration =>
    {
        configuration.Host = "localhost";
        configuration.Port = 6432;
        configuration.Username = "postgres";
        configuration.Password = "postgres";
        configuration.Database = "postgres";
        configuration.SslMode = "Prefer";
    })
    // Добавляем сервисы из Presentation
    .AddPresentationConsole();

// Собираем провайдер и создаем область жизни
var provider = collection.BuildServiceProvider();
using var scope = provider.CreateScope();

// Синхронный метод, делающий миграцию из `Itmo.Dev.Platform.Postgres`
scope.UseInfrastructureDataAccess();

// Достаем ScenarioRunner
var scenarioRunner = scope.ServiceProvider
    .GetRequiredService<ScenarioRunner>();

// Запускаем цикл, в котором выполняются выбранные пользователем сценарии
while (true)
{
    scenarioRunner.Run();
    AnsiConsole.Clear();
}
```
