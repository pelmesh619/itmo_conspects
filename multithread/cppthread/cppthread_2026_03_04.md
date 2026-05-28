## Лекция 5. Основные инструменты в Qt

Qt - это кросс-платформенный фреймворк на C++ для разработки графических интерфейсов и не только. Центральным классом является `QObject`, от которого наследуются почти все классы Qt, особенно виджеты и объекты, работающие с сигналами и слотами

`QObject` поддерживает иерархию родитель-потомок. Когда объект-родитель удаляется, он автоматически удаляет всех своих детей. Это позволяет строить деревья владения и не заботиться о ручном освобождении. Пример:

```cpp
QObject *parent = new QObject;
QObject *child = new QObject(parent); // child принадлежит parent
delete parent; // child тоже удалится
```

---

Сигналы и слоты - основной механизм коммуникации между объектами. Сигнал объявляется в классе с ключевым словом `signals`, слот - с `slots` или как обычная функция. У слота не может быть аргументов больше, чем у сигнала, но может быть меньше: лишние аргументы сигнала просто отбрасываются. Соединение выполняется через `connect`

Новый стиль `connect` использует указатели на функции. Пример, где сигнал испускается внутри метода, а слот просто печатает значение:

```cpp
class Sender : public QObject {
    Q_OBJECT
public:
    void doWork() {
        // emit подчёркивает, что испускается сигнал
        emit valueChanged(42);
    }
signals:
    void valueChanged(int newValue);
};

class Receiver : public QObject {
    Q_OBJECT
public slots:
    void onValueChanged(int val) { qDebug() << val; }
};

Sender sender;
Receiver receiver;
QObject::connect(&sender, &Sender::valueChanged,
                 &receiver, &Receiver::onValueChanged);

sender.doWork(); // внутри будет испущен сигнал, вызовется слот
```

Отсоединение выполняется методом `disconnect` с теми же указателями

Потоковая принадлежность: объект `QObject` привязан к тому потоку, в котором был создан. Сигналы и слоты могут пересекать потоки: если соединение прямое, слот выполняется в потоке отправителя; если через очередь (`QueuedConnection`), то вызов слота будет помещён в очередь событий потока-получателя. По умолчанию для межпоточных соединений автоматически выбирается `QueuedConnection`

`moveToThread` перемещает объект в другой поток. Объект должен быть без родителя, и его события будут обрабатываться в целевом потоке:

```cpp
QThread workerThread;
workerThread.start();
Receiver receiver; // без родителя
receiver.moveToThread(&workerThread);
// Теперь receiver живёт в workerThread, его слоты будут выполняться в этом потоке
```

Слово `emit` необязательно, но служит для ясности, что вызывается сигнал (обычно его пишут непосредственно перед именем сигнала)

---

Динамические свойства позволяют во время выполнения добавить к `QObject` свойство по имени и значению, используя `setProperty` и `property`. Это удобно для стилей и анимаций

```cpp
QPushButton button;
button.setProperty("urgent", true);
QVariant urgent = button.property("urgent");
```

---

События в Qt обрабатываются через виртуальный метод `event(QEvent*)`. Обычно виджеты переопределяют конкретные обработчики: `mousePressEvent`, `keyPressEvent` и так далее. Если нужно перехватить события до их доставки к целевому объекту, используется фильтр событий. Объект-фильтр переопределяет `eventFilter(QObject *watched, QEvent *event)` и устанавливается через `installEventFilter`

```cpp
class Filter : public QObject {
protected:
    bool eventFilter(QObject *obj, QEvent *event) override {
        if (event->type() == QEvent::KeyPress) {
            // обработать или подавить
            return true; // событие перехвачено
        }
        return QObject::eventFilter(obj, event);
    }
};

// использование:
Filter filter;
targetWidget.installEventFilter(&filter);
```

Преобразование типов в иерархии `QObject` выполняется с помощью `qobject_cast<Type*>(obj)`, что безопаснее `dynamic_cast`, если у класса есть макрос `Q_OBJECT`

Макрос `Q_OBJECT` обязателен в определении класса для поддержки сигналов, слотов, `tr()` и другой метаинформации

---

Фреймворк предоставляет свою реализацию потоков `QThread`, однако не рекомендуется наследоваться от `QThread` и переопределять `run()`. Предпочтительнее создать рабочие объекты и переместить их в `QThread` через `moveToThread`

---

Сборка проектов Qt обычно осуществляется с помощью CMake. Основные директивы:

```cmake
find_package(Qt6 COMPONENTS Widgets REQUIRED)
qt_add_executable(my_app main.cpp)
target_link_libraries(my_app PRIVATE Qt6::Widgets)
```

---

Для проектов с QML добавляют `Qt6::Quick` и соответствующие модули. QML - декларативный язык для описания интерфейса. Он исполняется в QML-движке. Объекты на C++ могут быть доступны из QML через регистрацию. Пример простого QML-файла:

```qml
import QtQuick
Rectangle {
    width: 200; height: 100
    color: "lightblue"
    Text {
        anchors.centerIn: parent
        text: "Hello, QML"
    }
}
```

В CMake для QML-приложения может потребоваться `qt_add_qml_module` для регистрации
