## Лекция 3. Работа с сетью и UI

### Сетевое взаимодействие

Сейчас самым распространенным сетевым стеком является TCP/IP. Он состоит из:

* Физический уровень - Ethernet, Wi-Fi и другие протоколы и технологии
* Сетевой уровень - протоколы IP 4-ой и 6-ой версий
* Транспортный уровень - протоколы TCP и UDP
* Прикладной уровень - протокол HTTP/HTTPS

> Подробнее о нем описано в курсе ["Телекоммуникационные системы и технологии"](https://pelmesh619.github.io/itmo_conspects/telecomm/telecomm_superconspect.html#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-5.-%D1%81%D1%82%D0%B5%D0%BA-tcp%2Fip)

Чтобы Android-приложение могло работать с сетью, необходимо в `AndroidManifest.xml` прописать нужные разрешения:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

Для доступа к сетевому API все чаще используется HTTP (HyperText Transfer Protocol). Обычно HTTP работает так:

* Клиент запрашивает ресурс от сервера по заранее заданному IP-адресу или доменному имени и порту (обычно 80 или 443)
* Сервер, зная адрес отправителя, отправляет ответ

> Подробнее про HTTP описано в курсе ["Web-разработка: Backend"](https://pelmesh619.github.io/itmo_conspects/webbackend/webbackend_superconspect.html#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-1.-%D0%B2%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D0%B5)

HTTP поддерживает типы запросов, которые семантически обозначают, что надо сделать с ресурсом, самые используемые это:

* `GET` - получение информации о ресурсе
* `POST` - создание нового ресурса
* `PUT` - обновление существующего ресурса
* `DELETE` - удаление ресурса

По умолчанию, протокол HTTP не поддерживает шифрование запросов, и любой участник передачи сообщения может его прочитать. Для борьбы с этим был создан протокол HTTPS (HTTP Secure)

Чаще всего ответом сервера на запрос будут данные в формате JSON (JavaScript Object Notation). Чтобы перевести JSON-текст в объектную модель, в Android-экосистеме используют:

* [GSON](https://github.com/google/gson) - библиотека с открытым исходным кодом для Java, разработанная Google
* [Jackson](https://github.com/FasterXML/jackson) - еще одна библиотека с открытым исходным кодом для Java
* Встроенный в экосистему Java пакет `org.json` с классом `JSONObject`:

    ```java
    String json = "{\"name\":\"Alice\",\"age\":30}";
    JSONObject obj = new JSONObject(json);
    String name = obj.getString("name");
    int age = obj.getInt("age");
    ```

Рассмотрим библиотеку GSON. Ее возможности включают автоматически маппинг JSON-объекта в сущность домена в виде POJO (Plain Old Java Object):

```kotlin
data class Person(
    @SerializedName("full_name")
    val name: String,
    val age: Int,

    @SerializedName(value = "email_address", alternate = ["email", "e"])
    val email: String? = null
)

val gson = Gson()

// Сериализация
val p = Person("Alice", 30)
val json: String = gson.toJson(p)
println(json) // {"name":"Alice","age":30}

// Десериализация
val jsonString = """{"name":"Bob","age":25,"email":"bob@example.com"}"""
val person: Person = gson.fromJson(jsonString, Person::class.java)
println(person) // Person(name="Bob", age=25, email="bob@example.com")
```

GSON позволяет задать имя ключа при сериализации и дополнительные имени для десериализации (в примере выше электронную почту можно указать как `e` и `email`). Также GSON производит автоматические преобразование к нужному типу, например, `0` и `false`, выданные сервером, преобразуются к булевому типу

Помимо обычного конвертера `Gson()`, можно указать дополнительные параметры в `GsonBuilder()`, например:

```kotlin
val gson = GsonBuilder()
   .setDateFormat("секунды ss, минуты mm, день dd, месяц MM, год yyyy")
   .setFieldNamingPolicy(FieldNamingPolicy.UPPER_CAMEL_CASE)
   .create()
```

Здесь указаны формат даты и политика полей имен (в данном случае свойство `firstName` сконвертируется в `FirstName` в JSON)

---

Одной из популярных библиотек для HTTP-обмена в Android является [Retrofit](https://github.com/square/retrofit). Это библиотека позволяется превратить API веб-приложений в интерфейс языка Java

Работает она так: сначала описываем сущности домены, которые приходят из API

```kotlin
data class Post(
    val userId: Int,
    val id: Int,
    val title: String,
    val body: String
)
```

Далее создаем интерфейс, аналогичный API:

```kotlin
interface JsonPlaceholderApi {
    // на GET запрос по http://host.com/posts
    // вернуть список постов
    @GET("posts")
    suspend fun getPosts(): List<Post>
}
```

Далее создает сервис и оборачивающая его функция:

```kotlin
val service = retrofit.create(JsonPlaceholderApi::class.java)

suspend fun fetchData() {
    try {
        val posts = service.getPosts()
        posts.forEach { println(it.title) }
    } catch (e: Exception) {
        println("Ошибка: ${e.message}")
    }
}
```

Также этот сервис можно настраивать под свои нужды, например, можно заказать конвертер из библиотеки GSON:

```kotlin
val service = retrofit.Builder()
    .baseUrl("http://example.com")
    .addConverterFactory(GsonConverterFactory.create())
    .build()
    .create(PokeApiService::class.java)
```

Далее этот сервис работает так:

* Создается прокси (паттерн ["Заместитель"](https://pelmesh619.github.io/itmo_conspects/oopcsharp/oopcsharp_superconspect.html#proxy)), который реализует интерфейс `JsonPlaceholderApi`
* Вызов сервиса передается прокси
* На основе аннотаций и аргументов собирается HTTP-запрос
* Запрос отправляется через библиотеку OkHttp, которая выполняет реальную передачу данных
* Полученный ответ конвертируется с помощью конвертора (например, `GsonConverterFactory.create()`) в объекты языка

Здесь в интерфейсе и функции `fetchData` есть ключевое слово `suspend`. Оно говорит о том, что метод и функции являются корутинами, то есть объектами асинхронного исполнения

До этого вместо корутин использовали интерфейс `Call<T>`:

```kotlin
interface MyApiService {
    @GET("users")
    fun getUsers(): Call<List<User>> 
}
```

Возвращенный тип представлял собой обертку над исполнением запроса, которое можно было запустить:

```kotlin
val call: Call<List<User>> = service.getUsers() // запрос создан, но не отправлен

call.enqueue(object : Callback<List<User>> {
    override fun onResponse(call: Call<List<User>>, response: Response<List<User>>) {
        if (response.isSuccessful) {
            val users = response.body()
            println("Получено пользователей: ${users?.size}")
        } else {
            println("Ошибка сервера: ${response.code()}")
        }
    }

    override fun onFailure(call: Call<List<User>>, t: Throwable) {
        println("Ошибка сети: ${t.message}")
    }
})
```

---

Также библиотека OkHttp позволяет работать с протоколом WebSocket:

```kotlin
val ws = OkHttpClient().newWebSocket(
    Request.Builder().url("ws:sample").build(), 
    object: WebSocketListener() {
        override fun onMessage(webSocket: WebSocket, text: String) {
            super.onMessage(webSocket, text)
        }

        override fun onOpen(webSocket: WebSocket, response: Response) {
            super.onOpen(webSocket, response)
        }

        override fun onClosed(webSocket: WebSocket, code: Int, reason: String) {
            super.onClosed(webSocket, code, reason)
        }

        override fun onClosing(webSocket: WebSocket, code: Int, reason: String) {
            super.onClosing(webSocket, code, reason)
        }
    }
)
ws.send("Hello")
```

Здесь в методе создания веб-сокета передается объект класса, реализующий 4 метода

---

Помимо HTTP-запросов можно отправлять сырые запросы по TCP или UDP

Так работает передача по TCP:

```kotlin
// Создаем TCP-сокет
val echoSocket = Socket(hostName, portNumber)

// Достаем из него поток для отправки текста
val out = PrintWriter(echoSocket.getOutputStream(), true)

// Перенаправляем стандартный поток ввода в наш сокет
System.setIn(echoSocket.getInputStream())
```

Так создаются UDP-сокеты:

```kotlin
// Создание сокета
val socket = DatagramSocket(1024, InetAddress.getByName("0.0.0.0"))
socket.reuseAddress = true
socket.broadcast = true

// Ждем датаграмму
val recvBuf = ByteArray(10)
val packet = DatagramPacket(recvBuf, recvBuf.size)
socket.receive(packet)
```

### UI

Android позволяет создавать интерфейсы несколькими способами:

* Через объявление в XML-файле (eXtensible Markup Language)
* Программно в коде, например, с помощью фреймворка Jetpack Compose

Объявление в XML-файле и программные можно комбинировать

Рассмотрим объявления в формате XML. Все XML-файлы хранятся в папке `/res/`, в частности:

* `/res/layout/` - набор описания интерфейса активностей и макетов
* `/res/values/` - файлы с наборами значений, такими как:

    * `/res/values/strings.xml` - локализованные строки
    * `/res/values/colors.xml` - цветовая схема приложения
    * `/res/values/styles.xml` - стили приложения
    * `/res/values/themes.xml` - темы приложения (темы отличаются от стилей тем, что тема глобальная для всего приложения)
    * `/res/values/dimens.xml` (от dimensions) - значения размеров элементов интерфейса
* анимации, иконки и прочее

В `/res/layout` как раз-таки описано то, как выглядит интерфейс приложения, а именно его элементы на соответствующих экранах, как они расположены, каких цветов и так далее

Обычно один такой файл выглядит так:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="24dp">

    <TextView
        android:id="@+id/textCount"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Count: 0"
        android:textSize="32sp"
        android:layout_marginBottom="16dp" />

    <Button
        android:id="@+id/buttonIncrement"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Increment" />

    <Space
        android:layout_width="wrap_content"
        android:layout_height="12dp" />

    <Button
        android:id="@+id/buttonReset"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Reset" />

</LinearLayout>
```

Здесь интерфейс описан как линейный макет с объектами представления

![Иерархия в интерфейсе](./images/uiandroid_ui_hierarchy.png)

#### Объект представления `View`

Класс `View` - это базовый класс, который представляет элемент интерфейса

`View` является классом-родителем для множества других элементов:

* `ImageView` - элемент с изображением
* `ProgressBar` - элемент с полосой загрузки
* `Space` - пустое пространство
* `TextView` - элемент с текстом
* `ViewGroup` - элемент, представляющий группу из других элементов. От `ViewGroup` наследуются:

    * `LinearLayout`
    * `RelativeLayout`
    * `ConstraintLayout`
    * `ScrollView`
    * и другие

В XML-файле объект представления задается тегом его класса, например:

```xml
    <TextView
        android:id="@+id/textCount"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Count: 0"
        android:textSize="32sp"
        android:layout_marginBottom="16dp" />
```

Далее идут атрибуты объекта представления, такие как:

* `android:id` - идентификатор. Объявление идентификатора указывается в формате `@+id/myview`, а используется в виде `@id/myview`
* `android:layout_width` - ширина элемента
* `android:layout_height` - высота элемента
* `android:text` - текст, который отображается в элементе
* `android:padding` - внутренний отступ
* `android:margin` - внешний отступ
* `android:orientation` - ориентация элемента
* `android:visibility` - видимость элемента
* `android:enabled` - доступность элемента
* и другие

Жизненный цикл `View` состоит из следующих этапов:

* `View` создана и прикреплена к экрану, вызывается метод `onAttachedToWindow()`
* Далее вызывается метод `onMeasure()`, который определяет желаемые размеры, например, из XML-файла или другим образом
* Далее вызывается метод `onLayout`, который вычислять позицию этой `View`, а также размеры и позицию своих дочерних представлений. Для обычной `View`, а не `ViewGroup` этот метод ничего не делает
* После этого вызывается метод `onDraw()`, который отрисовывает на экране `View`. Этот метод исполняется в основном потоке, в котором работает интерфейс, поэтому он должен быть максимально быстрый (не задействовать операции ввода/вывода), чтобы не блокировать поток
* Метод `onDetachedFromWindow()` вызывается, когда `View` отсоединяется от окна

Если `View` некорректна или неактуальна, можно воспользоваться следующими методами:

* `invalidate()` - планирует перерисовку `View` (то есть вызов `onDraw`). Используется когда изменился внешний вид, но не размер
* `requestLayout()` - запускает полный цикл `onMeasure()` и `onLayout()`, но не гарантирует вызов `onDraw()`. Используется когда изменились размеры `View`
* `forceLayout()` - инвалидирует кэшированные размеры дочерних `View` в `ViewGroup`. Используется только вместе с `requestLayout()`

![Жизненный цикл представления](./images/uiandroid_view_lifecycle.png)

---

Также можно создать свой наследник `View`. Для этого создаем класс:

```kotlin
class CircleView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null
) : View(context, attrs) {

    private val paint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.RED
    }

    fun setColor(color: Int) {
        paint.color = color
        invalidate()  // перерисовать
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        // Рисуем круг по центру View
        val cx = width / 2f
        val cy = height / 2f
        val radius = min(width, height) / 2f
        canvas.drawCircle(cx, cy, radius, paint)
    }
}
```

Далее использовать программно или в XML:

```xml
<com.example.exampleapp.CircleView
    android:layout_width="100dp"
    android:layout_height="100dp" />
```

Для таких `View` можно объявлять свои атрибуты в файле `/res/values/attrs.xml`, например:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <declare-styleable name="CircleView">
        <attr name="circleColor" format="color" />
    </declare-styleable>
</resources>
```

Далее в классе читать атрибуты:

```kotlin
class CircleView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : View(context, attrs, defStyleAttr) {

    init {
        // Читаем атрибуты
        val typedArray = context.obtainStyledAttributes(attrs, R.styleable.CircleView)
        val defaultColor = Color.RED
        val color = typedArray.getColor(R.styleable.CircleView_circleColor, defaultColor)
        typedArray.recycle()

        paint.color = color
    }

    // ...
}
```

Здесь `defStyleAttr` указывает на атрибут в теме, содержащий стиль по уполчанию для `CircleView`

Далее цвет можно указать так:

```xml
    <com.example.exampleapp.CircleView
        android:layout_width="100dp"
        android:layout_height="100dp"
        app:circleColor="@color/blue" />
```

#### Объект макета `Layout`

Так в Android-приложении весь интерфейс одного экрана живет в одной активности. Для компоновки элементов интерфейса используют объект макета `Layout`. Сам макет с его элементами описывается в XML-файле в папке `/res/layout` (или программно)

Рассмотрим основные классы, которые наследуются от `Layout`:

* `LinearLayout` располагает внутренние элементы в строку или в столбец, используется для списков
* `RelativeLayout` позволяет располагать элементы относительно друг друга
* `FrameLayout` позволяет располагать элементы в столбец в рамках одного экрана
* `GridLayout` позволяет задать сетку из элементов
* `ConstraintLayout` позволяет располагать элементы, привязывая их к границам экрана или к другим компонентам

Самый быстрый - это `FrameLayout`. Далее идут `LinearLayout`, `GridLayout` и другие

Разметка элементов регулируется атрибутами в объектах макетов и дочерних элементах

![Макеты](./images/uiandroid_layout_types.png)

Главное правило - избегать излишней вложенности. `RelativeLayout` и `LinearLayout` могут два раза пробегаться по элементам при отрисовке. Если интерфейс сложный, то лучше использовать `ConstraintLayout`

Также для удобства макеты можно вкладывать друг в друга, указывая имя XML-файла с помощью тега `<include>`. Например, если есть `res/layout/header.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:background="#2196F3"
    android:padding="16dp">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Заголовок приложения"
        android:textColor="#FFFFFF" />
</LinearLayout>
```

То можно его включить в другом макете так:

```xml
<include
    android:id="@+id/main_header"
    layout="@layout/header" />
```

А если нужно не весь `Layout`, а только его содержимое, то можно применить тег `<merge>`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<merge xmlns:android="http://schemas.android.com/apk/res/android">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Заголовок приложения"
        android:textColor="#FFFFFF" />
</merge>
```

```xml
<include layout="@layout/header" />
```

Это позволяет улучшить производительность и уменьшить вложенность иерархии

---

Программно создание макета выглядит так:

```java
public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Создаем LinearLayout
        LinearLayout layout = new LinearLayout(this);
        layout.setOrientation(LinearLayout.VERTICAL);
        layout.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));

        // Создаем кнопку
        Button button = new Button(this);
        button.setText("Нажми меня");
        button.setLayoutParams(new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));

        // Добавляем кнопку в LinearLayout
        layout.addView(button);

        // Устанавливаем LinearLayout как корневой элемент Activity
        setContentView(layout);
    }
}
```

#### Процесс надувания

Далее, когда запускается приложение и создается активность, происходит процесс надувания (inflate) - специальный сервис `LayoutInflater` превращает XML-теги в объекты языка, с которыми можно работать внутри кода

```kotlin
// Получаем экземпляр LayoutInflater
val inflater = LayoutInflater.from(context) 
// или getLayoutInflater()

// Надувание
val rootView: View = inflater.inflate(R.layout.item_view, null)

// Теперь находим дочерние представления по их идентификатору,
// используя findViewById<T>
val title = rootView.findViewById<TextView>(R.id.titleTextView)
val button = rootView.findViewById<Button>(R.id.actionButton)

// Устанавливаем текст и обработчик
title.text = "Заголовок"
button.setOnClickListener {
    // действие
}

// Добавляем rootView на какой-нибудь макет
someLinearLayout.addView(rootView)
```

Здесь `R` в `R.layout.item_view`, `R.id.titleTextView`, `R.id.actionButton` - это автоматически сгенерированный класс, создающийся на этапе компиляции и состоящий из указателей на ресурсы приложений (в данном случае мы заказали кнопку из файла или `/res/layout/item_button.xml`)

Метод `inflate` имеет такую сигнатуру:

```kotlin
inflate(@LayoutRes resource: Int, root: ViewGroup?, attachToRoot: Boolean): View
```

Здесь `resource` - указатель из `R`, `root` - родительский элемент, который будет использоваться для вычисления размеров и отступов, `attachToRoot` - надо ли сразу добавить надутый элемент в родителю

Внутри `LayoutInflater`:

* Читает XML-файл
* Определяет, какой объект нужно создать, и создает с помощью фабрики
* Применяет атрибуты, описанные в XML-файле
* Рекурсивно создает дочерние элементы, если они есть
* Привязывает их к указанному родителю, если надо

#### Объекты связки

Android SDK позволяет использовать объекты связки (binding)

Сначала появился объект Synthetic Binding - плагин `kotlin-android-extensions` позволял обращаться к `View` по идентификатору напрямую, без `findViewById`, как к свойствам

Плагин подключался в `build.gradle`:

```groovy
plugins {
    id 'kotlin-android-extensions'
}
```

В коде импортировался `kotlinx.android.synthetic.main.<layout>.*` и класс использовался:

```kotlin
import kotlinx.android.synthetic.main.activity_main.*
textView.text = "Hello, world"
```

Плагин автоматически генерировал кэш в хешмапе, избегая повторного вызова методов `findViewById`, но мог вернуть `null`, если объект представления не существует

Также была проблема с конфликтами имен, поэтому от такого решения отказались

---

Далее появился объект связки представления - View Binding

Для его использования нужно добавить флаг в `build.gradle.kts`:

```kotlin
android {
    buildFeatures {
        viewBinding = true
    }
}
```

Далее объект связки представляет свойство в объекте активности или фрагмента, которое можно надуть:

```kotlin
class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // непосредственное изменение
        binding.button.text = "Нажми"
    }
}
```

ViewBinding позволяет обращаться к внутренним элементами интерфейса, описанных в XML, не через метод `findViewById`, а через свойства объекта автоматически сгенерированного класса `___Binding`

При этом поля имеют названия указанных идентификаторов, но в camelCase (то есть `@+id/button_ok` преобразовывается в `buttonOk`), работает быстрее, чем `findViewById`, и более типобезопасно

---

Для реактивного интерфейса придумали объект связки данных Data Binding

Реактивный интерфейс - подход к разработке интерфейсов, который использует реактивное программирование для управления потоками данных и событий, позволяя автоматически обновлять интерфейс при изменении данных

Data Binding позволяет связывать компоненты интерфейса напрямую с источниками данных прямо в XML. Включается Data Binding в `build.gradle.kts`:

```kotlin
android {
    buildFeatures {
        dataBinding = true
    }
}
```

Далее в XML-файле добавляется тег `<data>`, например:

```xml
<layout xmlns:android="http://schemas.android.com/apk/res/android">
    <data>
        <variable name="viewModel" type="com.example.MyViewModel" />
    </data>
    <LinearLayout>
        <TextView android:text="@{viewModel.userName}" />
        <Button android:onClick="@{() -> viewModel.onButtonClick()}" />
        <EditText android:text="@={viewModel.userInput}" />
    </LinearLayout>
</layout>
```

В теге `<data>` объявляется переменная, значения свойств которой можно записать в объектах представления

Программно `viewModel` привязывается к объектам интерфейса так:

```kotlin
val binding: ActivityMainBinding = DataBindingUtil.setContentView(this, R.layout.activity_main)
binding.viewModel = myViewModel
binding.lifecycleOwner = this   // для наблюдения
```

Для реактивного подхода используется классы, подобные `LiveData`, за которыми можно закрепить функцию, исполняющуюся при изменении данных (паттерн ["Наблюдатель"](https://pelmesh619.github.io/itmo_conspects/oopcsharp/oopcsharp_superconspect.html#observer))

Data Binding позволяет уменьшить количество кода в активности, поддерживает двухстороннее изменение (если есть поле для ввода, то значение поменяется и в коде), но приложение медленнее компилируется, и его сложнее отлаживать

#### Фреймворк Jetpack Compose

Jetpack Compose - новый фреймворк, который позволяет декларативно задать интерфейс на языке программирования

Пример его использования:

```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CounterAppTheme {
                Surface(modifier = Modifier.fillMaxSize(), color = MaterialTheme.colorScheme.background) {
                    CounterScreen()
                }
            }
        }
    }
}

@Composable
fun CounterScreen() {
    var count by remember { mutableStateOf(0) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = "Count: $count", fontSize = 32.sp, modifier = Modifier.padding(bottom = 16.dp))
        Button(onClick = { count++ }) {
            Text("Increment")
        }
        Spacer(Modifier.height(12.dp))
        OutlinedButton(onClick = { count = 0 }) {
            Text("Reset")
        }
    }
}
```

Здесь задается столбец из элементов: текста с счетчиком, кнопки инкремента и кнопки сброса

#### Адаптивный дизайн

Далее будут приведены хорошие практики для создания дизайна, который будет хорошо работать на разных устройствах:

* У телефона или планшета на Android есть две ориентации: книжная (высота по вертикали больше ширины по горизонтали экрана) и альбомная. Интерфейс, созданный для книжной ориентации, может плохо выглядеть на альбомной ориентации, поэтому создают отдельные макеты

    Такие макеты хранятся в `/res/layout-land` (от landscape). В манифест можно указать атрибут `android:screenOrientation`, чтобы показать, какую ориентацию поддерживает приложение

* Вместо пикселей лучше использовать относительные единицы `dp` и `sp`

    `1dp` (от density-independent pixel) - это длина одного пикселя на экране с `160dpi` (dots per inch), то есть примерно 1/160 дюйма. `dp` не зависит от плотности экрана, поэтому ее лучше использовать для высоты, ширины элементов, отступов и прочих размеров элементов интерфейса

    `1sp` (от scale-independent pixel) - это длина, умноженная на масштаб шрифта, установленного в системе. Крайне важно использовать ее для размеров текста, чтобы обеспечивать доступность для всех пользователей

* Для устройств разной плотностью пикселей на экране можно задать свои макеты. Плотность экрана измеряется в `dp`; так,

    * `/res/layout-small` - макеты для экранов с шириной до `320dp`
    * `/res/layout-normal` - для экранов с шириной от `320dp` до `480dp`
    * `/res/layout-large` - для экранов с шириной от `480dp` до `720dp`
    * `/res/layout-xlarge` - для экранов с шириной от `720dp` и более

    Также, непосредственно в коде можно использовать медиа-запросы, например, свойство `getResources().getConfiguration().screenWidthDp` позволяет узнать ширину экрана
