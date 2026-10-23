# Отладочная страница

<script>
window.MathJax = {
  tex: {
    inlineMath: {'[+]': [['$', '$']]}
  }
};
</script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@4/tex-mml-chtml.js"></script>

<!-- recently-visited -->

<script type="application/json" id="subject-info">
{
    "recommended": [
        {
            "title": "Другой конспект",
            "link": "/itmo_conspects/opersys/opersys_superconspect.html"
        }
    ],
    "seeAlso": [
        {
            "title": "Еще какой-то конспект",
            "link": "/itmo_conspects/telecomm/telecomm_superconspect.html"
        }
    ]
}
</script>

Это - отладочная страница. Она служит для поиска визуальных багов в работе CSS-стилей, а именно:

* Форматирования

    * _Курсив_
    * **Жирное** начертание
    * [Ссылка на что-то](https://ru.wiktionary.org/wiki/%D1%87%D1%82%D0%BE-%D1%82%D0%BE)
    * ~~Перечеркивание~~
    * <u>Подчеркивание</u>

* Цитаты:

    > _В жизни всегда есть две дороги: одна — первая, а другая — вторая._  
    > `Джейсон Стэтхэм`

* Заголовков:

# Заголовок 1 `Заголовок 1`
## Заголовок 2 `Заголовок 2`
### Заголовок 3 `Заголовок 3`
#### Заголовок 4 `Заголовок 4`
##### Заголовок 5 `Заголовок 5`
###### Заголовок 6 `Заголовок 6`

* Прямой линии:

    ---

* Таблицы:

    | Заголовок 1 | Заголовок 2 | `Заголовок 3` | Заголовок 4 |
    |-|-|-|-|
    | Клетка 1-1 | Клетка 1-2 | Клетка 1-3 | Клетка 1-4 |
    | Клетка 2-1 | Клетка 2-2 | Клетка 2-3 | Клетка 2-4 |
    | Клетка 3-1 | Клетка 3-2 | Клетка 3-3 | Клетка 3-4 |
    | Клетка 4-1 | Клетка 4-2 | Клетка 4-3 | Клетка 4-4 |

* Вложенных списков:

* А
* Б
* В

    * А
    * Б
    * В

        * А
        * Б
        * В

1. 1
2. 2
3. 3

    1. 1
    2. 2
    3. 3

        1. 1
        2. 2
        3. 3

*   Подсветки синтаксиса:

    ```rb
    # SINGLE_LINE: Обычный комментарий

    =begin
        MULTI_LINE:
        Многострочный
        комментарий
    =end

    <ошибка-синтаксиса>

    $global_variable = :symbol_token
    @instance_var, @@class_var = 42, 0.123e-4

    class ThemeTester < Object
        include Mat
        extend self

        REGEX_CHECK = %r{[a-z\d]+}i
        HEREDOC_TEXT = <<~TEXT
            Многострочный текст (Heredoc)
            Проверка строковых литералов
        TEXT

        attr_reader :name

        def initialize(name = "Jekyll", *args, **kwargs)
            @name = name
            @is_active = true
            @empty = nil
        end

        def process!(yield_target)
            raise ArgumentError, "Ошибка!" if @name.empty?

            puts "Привет, #{@name}! Результат: #{2 + 2}" 

            yield_target.each do |item|
            next unless item.is_a?(String)
            yield item.upcase
            end
        rescue StandardError => e
            __line__
            nil
        ensure
            return self
        end
    end
    ```

* Изображения:

    ![Альтернативный текст](../javatech/images/catmeme.jpg)

    ![Несуществующее изображение](./bla-bla-bla)

* Матформул:

    $$ h\nu = A_{\text{вых}} + E_{\text{кин} \max}, $$

    где: $h$ - постоянная Планка, $\nu$ - частота падающего света, $A_{\text{вых}}$ - работа выхода электрона из металла, $E_{\text{кин} \max}$ - максимальная кинетическая энергия фотоэлектрона
