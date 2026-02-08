## Лекция 6. Воркшоп 2

<!-- Лектор - Круглов Г. Н. -->

На этой лекции был воркшоп[^whysecond], на котором рассматривался пример предметной области и его решения, соблюдающего
принципы, сказанные на лекциях ранее, и применяющего порождающие паттеры. Здесь же будут некоторые нудные комментарии того, что происходило на воркшопе, но могут быть полезными в некоторых случаях

[^whysecond]: Почему второй? А вот первый был у y26

Код с воркшопа можно посмотреть здесь: [https://github.com/is-oop-y27/workshop-2/tree/master-12-10-2024](https://github.com/is-oop-y27/workshop-2/tree/master-12-10-2024)

Перед нами стоят такие требования:

* Реализовать систему создания статей и их красивого вывода
* Статья состоит из названия, параграфов, может иметь автора
* Параграф же состоит из заголовка, абзацев, может иметь заключение (футер)
* Мы хотим задавать разное форматирование для всего параграфа
* Мы хотим редактировать статьи после их создания
* Мы хотим выводить красиво статьи в консоль

Сразу же выделим сущности "Текст" (со строкой и с форматированием), "Параграф" (с заголовком, несколькими "Текстами" и с опциональным заключением) и "Статья" (с названием)

Лучше всего начинать с абстракций, которые меньше всего зависят от других, поэтому создадим общий [интерфейс](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/IRenderable.cs) `IRenderable` для объектов, которые мы будем отображать в консоль, с методом `Render`, возвращающий строку

Диаметрально сделаем [интерфейс для отрисовщиков](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/IDrawer.cs) `IDrawer`, принимающий реализацию интерфейса `IRenderable`. Сделаем [реализацию](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Drawers/ConsoleDrawer.cs) `ConsoleDrawer`, который просто вызывает метод `Render` и выводит строку в консоль классическим методом.

Теперь сделаем [интерфейс](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/IText.cs) `IText` с рекурсивным дженериком:

```csharp
public interface IText<T> : IRenderable
    where T : IText<T>
{
    T Clone();

    T AddModifier(IRenderableModifier modifier);
}
```

Рекурсивный дженерик нам нужен, чтобы возвращать копию с исходным типов (подробнее об этом в паттерне ["Прототип"](https://pelmesh619.github.io/itmo_conspects/oopcsharp/oopcsharp_superconspect.html#prototype))

Создадим [реализацию](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Renderables/Text.cs) `Text`

Так как текст мы хотим форматировать, сделаем [интерфейс для модификатора](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/IRenderableModifier.cs) `IRenderableModifier` с методом `Modify`, который принимает строку и возвращает ее отформатированный вариант

Форматировать текст в консоль будем при помощи библиотеки Crayon, сделаем [модификатор для цвета](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Modifiers/ColorModifier.cs) `ColorModifier` и [модификатор для жирного текста](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Modifiers/BoldModifier.cs) `BoldModifier`

Теперь дополним наш класс `Text` до такой имплементации:

```csharp
public class Text : IText<Text>
{
    private readonly List<IRenderableModifier> _modifiers;

    public Text(string value)
    {
        Value = value;
        _modifiers = [];
    }

    private Text(string value, IEnumerable<IRenderableModifier> modifiers)
    {
        Value = value;
        _modifiers = modifiers.ToList();
    }

    public string Value { get; set; }

    public Text Clone()
        => new(Value, _modifiers);

    public string Render()
    {
        return _modifiers.Aggregate(
            Value,
            (v, m) => m.Modify(v));
    }

    public Text AddModifier(IRenderableModifier modifier)
    {
        _modifiers.Add(modifier);
        return this;
    }
}
```

Немного комментариев: здесь мы сделали приватный конструктор для метода клонирования и неполный публичный

Сделаем [интерфейс для параграфа](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/IParagraph.cs) `IParagraph` и саму [реализацию](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/Paragraph.cs) `Paragraph`. В ней довольно тривиально реализовываем конструктор и метод `Render`

Также сделаем другую [реализацию/обертку](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/StyledParagraph.cs) `StyledParagraph` для применения модификаторов на весь параграф

Объект параграф довольно-таки громоздкий - 3 атрибута, один из которых список, поэтому сделаем для него билдер. Наш билдер будет состоять из [2 интерфейсов](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/IParagraphBuilder.cs)[^workshoponefile]: `IParagraphHeaderSelector` и `IParagraphBuilder`. Таким образом мы отделили метод `WithHeader` от `AddSection` и `WithFooter`

[^workshoponefile]: Говорилось, что лучше бы эти два интерфейса разделить на два файла, так что так не делайте

Сделаем [абстрактную реализацию](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/Builders/ParagraphBuilderBase.cs) `ParagraphBuilderBase` - в нем через методы мы собираем данные. Аналогично сделаем реализацию билдера [обычного параграфа](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/Builders/DefaultParagraphBuilder.cs) `DefaultParagraphBuilder` и [стилизованного параграфа](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/Builders/StyledParagraphBuilder.cs) `StyledParagraphBuilder`, который передает модификаторы в `StyledParagraph`

Теперь самое вкусное: сделаем [интерфейс фабрики билдера параграфа](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/IParagraphBuilderFactory.cs) с методом `Create`, возвращающим нужный билдер, но в виде интерфейса `IParagraphHeaderSelector`, чтобы принудить пользователя ввести обязательно заголовок параграфа и не дает собрать параграф

Теперь накатим реализации [обычной фабрики](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/Factories/DefaultParagraphBuilderFactory.cs) `DefaultParagraphBuilderFactory` и [стилизованной фабрики](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Paragraphs/Factories/StyledParagraphBuilderFactory.cs) `StyledParagraphBuilderFactory` - в ней мы передаем модификатор, в последствии фабрика передает его в билдер:

```csharp
public class StyledParagraphBuilderFactory : IParagraphBuilderFactory
{
    private readonly IRenderableModifier _modifier;

    public StyledParagraphBuilderFactory(IRenderableModifier modifier)
    {
        _modifier = modifier;
    }

    public IParagraphHeaderSelector Create()
    {
        return new StyledParagraphBuilder(_modifier);
    }
}
```

Перейдем к созданию статей: сделаем [интерфейс](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Articles/IArticle.cs) `IArticle`, который наследуется от `IRenderable` и `IArticleBuilderDirector` - директора билдера. [Интерфейс директора билдера](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Articles/IArticleBuilderDirector.cs) `IArticleBuilderDirector` дает нам метод `Direct` принимающий и возвращающий билдер статьи (о нем позже)

Создадим [интерфейс билдера](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Articles/IArticleBuilder.cs) с методами `WithName`, `AddParagraph`, `WithAuthor` и `Build` и тривиальную [реализацию](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Articles/ArticleBuilder.cs) `ArticleBuilder`

Сделаем [реализацию статьи](https://github.com/is-oop-y27/workshop-2/blob/master-12-10-2024/src/Articles/Articles/Article.cs) `Article` с уже понятными конструктором и методом `Render`, и методом `Direct`, который берет созданный извне билдер, передает ему данные текущей статьи и возвращает обратно - таким образом делает копию статьи в билдере:

```csharp
    public IArticleBuilder Direct(IArticleBuilder builder)
    {
        builder = builder.WithName(_name);

        if (_author is not null)
        {
            builder = builder.WithAuthor(_author);
        }

        builder = _paragraphs.Aggregate(
            builder,
            (b, p) => b.AddParagraph(p));

        return builder;
    }
```
