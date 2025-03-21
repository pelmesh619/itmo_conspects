# <a name="%D1%82%D0%B5%D1%85%D0%BD%D0%BE%D0%BB%D0%BE%D0%B3%D0%B8%D0%B8-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F-%D0%BD%D0%B0-java"></a> Технологии программирования на Java


* [Технологии программирования на Java](#%D1%82%D0%B5%D1%85%D0%BD%D0%BE%D0%BB%D0%BE%D0%B3%D0%B8%D0%B8-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F-%D0%BD%D0%B0-java)
  * [Лекция 1](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-1)
  * [Лекция 2](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-2)
  * [Лекция 3](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-3)
    * [Apache Ant + Apache Ivy](#apache-ant-%2B-apache-ivy)
    * [Apache Maven](#apache-maven)
    * [Google Gradle](#google-gradle)
  * [Лекция 4](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-4)
    * [Обнаружение мусора](#%D0%BE%D0%B1%D0%BD%D0%B0%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BC%D1%83%D1%81%D0%BE%D1%80%D0%B0)
    * [Очистка мусора](#%D0%BE%D1%87%D0%B8%D1%81%D1%82%D0%BA%D0%B0-%D0%BC%D1%83%D1%81%D0%BE%D1%80%D0%B0)
    * [Реализации сборщиков мусора](#%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8-%D1%81%D0%B1%D0%BE%D1%80%D1%89%D0%B8%D0%BA%D0%BE%D0%B2-%D0%BC%D1%83%D1%81%D0%BE%D1%80%D0%B0)



Этот курс будет про работу с языком Java (JVM, ООП на Java), с базами данных, со средствами сборки и тестирования, с микросервисами

Первый модуль будет посвящен изучению Java (дополнительно можно ознакомиться на [сайте Георгия Корнеева](https://www.kgeorgiy.info/courses/java-advanced)), второй модуль - Spring и микросервисам

## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-1"></a> Лекция 1

До этого существовали большие компьютеры, кушающие перфокарты, далее появились такие языки, как FORTRAN, BASIC и другие

Основной недостаток: ни один из представленных в те времена ЯП не мог удовлетворить одновременно всем критериям:

* простота использования

* предоставляемые возможности

* безопасность

* эффективность

* устойчивость

* расширяемость

Первый таким языком стал C - он был создан для работяг, тогда как более старые языки были созданы в академических целях

Потом появился C++, объединивший в себе ООП, однако C++ - платформо-зависимый язык

К 90-ым годам с распространением компьютеров появились разные платформы. С этим появилась концепция превращения кода в промежуточную стадию, которую можно запускать на процессорах разных архитектур. Ввели термины managed code (управляемый код) и unmanaged code (неуправляемый код). Управляемый код управляется средой выполнения - виртуальной машиной. 

В Java код переводится в байт-код, который транслируется в машинные инструкции при помощи Java Virtual Machine (JVM). При этом понимание Java-программисту устройства виртуальной машины также не нужно, как и понимание устройства компилятора C-программисту ([\*тык\*](https://habr.com/ru/post/568402))

Java Runtime Environment (JRE) - среда выполнения для Java, которая содержит библиотеки классов, загрузчик классов и т. д.

Java Development Kit (JDK) - средства, позволяющие разрабатывать на Java

JVM состоит из:

* спецификации - набором правил, диктующих, как должна быть реализована JVM. "JVM должна правильно запускать программы, написанные на Java"

* реализации - реальной программы, которая будет запускать и позволять разрабатывать программы, написанные на Java

* экземпляра - оболочки над вашим кодом, которая его исполняет и заботится о том, как она это делает

Пример кода на Java:

```java
package ru.butenko.springdatatest; // название пакета

import java.time.LocalDate;

public class Dog {
    public String name;
    private LocalDate birthdate;

    public int calculateAge() {
        return LocalDate.now().getYear() - this.birthdate.getYear();
    }
}
```

Название пакета отражается название организации (или индивидуального человека), название проекта и файловую структуру проекта

При компиляции класс из файла `.java` переводится в байт-код `.class`

Также в Java есть примитивные коллекции, например, Queue, Deque и другие ([\*тык\*](https://javarush.com/groups/posts/1937-klass-collections))

Ошибки в Java делятся на 2 типа:

* `___Error` - ошибки, связанные с JVM

* `___Excetion` - исключения, связанные с работой кода

Если метод может вызвать исключение во время работы, то оно должно быть указано в сигнатуре метода:

```java
    public void Do() throws Exception {
        ...
    }
```

Также хорошим тоном будет указывание документации для классов и методов:

```java
import java.time.LocalDate;

/**
 * Класс "Собака"🐶
 */
public class Dog {
    public String name;
    private LocalDate birthdate;

    /**
     * Метод, вычисляющий возраст собаки
     * 
     * @return int возраст собаки
     */
    public int calculateAge() {
        return LocalDate.now().getYear() - this.birthdate.getYear();
    }

    /**
     * Метод, дающий собаке новое имя
     * 
     * @param String новое имя собаки
     */
    public void setName(String newName) {
        name = newName;
    }

    /**
     * Метод, вычисляющий возраст собаки
     * 
     * @throws Exception исключение
     */
    public void DoException() throws Exception {
        throw new Exception("Yay!");
    }
}
```


## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-2"></a> Лекция 2

Сейчас версией с долгосрочной поддержкой является Java 21

Разберемся в изданиях Java:

* Java Platform Standard Edition (Java SE) - стандартная редакция Java, которая использует для разработки простых приложений

* Java Platform Enterprise Edition ([Java EE](https://en.wikipedia.org/wiki/Jakarta_EE)) - редакция для предприятий

* Java Platform Micro Edition (Java ME) - редакция для разработки ПО на микроконтроллерах, мобильные платформы и т.д.

Комитет [Java Community Process](https://ru.wikipedia.org/wiki/Java_Community_Process) определяет, как будут выглядеть будущие спецификации Java

---

Классы в Java как правило объединены в пакеты. По умолчанию, стандартная библиотека Java содержит пакеты `java.lang`, `java.io`, `java.util` и другие. Организация классов в пакеты позволяет избежать коллизии имен.

В Java все коллекции представлены в Java Collections Framework наследуются от интерфейса [`java.util.Collection`](https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html). Сам интерфейс `java.util.Collection` наследуется от интерфейса `java.util.Iterable`, позволяющий итерироваться по коллекции.

В Java в качестве динамического списка используют `ArrayList` (с произвольным доступом по индексу) и `LinkedList` (с последовательный доступом)

`Vector` в Java работает так же, как и `ArrayList`, но `Vector` потокобезопасный. Также `Vector` расширяется вдвое, а `ArrayList` в 1,5 раза

Помимо них есть:

* `Stack` - стек, реализованный на `Vector` 

* `Queue` - односторонняя очередь

* `Deque` - двухсторонняя очередь

* `Set` - множество; реализации на хеш-таблице `HashSet` и на дереве `TreeSet`

* `Map` - словарь; реализации на хеш-таблице `HashMap` и на дереве `TreeMap`

В `java.util.concurrent` существуют потокобезопасные версии коллекций

Помимо Java Collections Framework другие фреймворки, такие как Google Guava и Apache Commons Collections, реализуют свои коллекции

Чтобы обрабатывать коллекции, в Java есть Stream API. Работает он как LINQ в C#:

1. Создаем поток из коллекции: `list.stream()`

2. Применяем промежуточные методы, такие как `filter()`, `map()`, `sorted()`

3. Применяем терминальный метод, например, `count()`, `findFirst()`, `toList()`

Пример:

```java 
list
    .stream()
    .filter(x -> x.toString().length() == 3)
    .forEach(System.out::println);

list.stream().forEach(x -> System.out.println(x));
```



## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-3"></a> Лекция 3

По мере роста количества кода появилась потребность в системах сборки, которые связывают необходимые библиотеки с проектом. Впоследствии понадобилась автоматизация сборки, чтобы система сама находила зависимости, скачивала их, прогоняла тесты и деплоила на удаленный сервер

В начале единственным приличным инструментом для сборки был Make, позднее потребовались более функциональные инструменты для сборки. Сейчас можно выделить 3 популярные системы сборки для Java:

* Apache Ant и Apache Ivy
* Apache Maven
* Google Gradle

### <a name="apache-ant-%2B-apache-ivy"></a> Apache Ant + Apache Ivy

Ant вышел в 2000 и был первым среди "современных" инструментов сборки. Для описания сборки Ant использует информацию, написанную в `build.xml`:

```xml
<project>
    <target name="clean">
        <delete dir="classes"/>
    </target>

    <target name="compile" depends="clean">
        <mkdir dir="classes"/>
        <javac srcdir="src" destdir="classes"/>
    </target>

    <target name="jar" depends="compile">
        <mkdir dir="jar"/>
        <jar destfile="jar/HelloWorld.jar" basedir="classes">
            <manifest>
                <attribute name="Main-Class"
                  value="antExample.HelloWorld"/>
            </manifest>
        </jar>
    </target>

    <target name="run" depends="jar">
        <java jar="jar/HelloWorld.jar" fork.="true">
    </target>
</project>
```

Позднее для управления зависимостями появился Apache Ivy. Ivy автоматически ищет в указанном репозитории указанные зависимости и скачивает их.

Во время сборки Ant делает 4 вещи (фазы, цели):

* clean - очистка предыдущих файлов сборки
* compile - компиляция 
* jar - упаковка в jar архив
* run - запуск JVM

### <a name="apache-maven"></a> Apache Maven

Maven вышел в 2004 и стал преемником Ant и Ivy, сочетая в себе функционал этих инструментов. Maven умеет управлять зависимостям, которые загружены на репозиторий [Maven Central](https://mvnrepository.com/)

В отличии от Apache Ant, Maven требует строгой файловой структуры проекта:

```
project
 |_ src
 |   |_ main
 |   |   |_ java
 |   |   |_ resources
 |   |_ test
 |       |_ java
 |       |_ resources
 |_ target
 |_ pom.xml
```

Управлять сборкой в Maven можно с помощью `pom.xml` файла (Project Object Model). В ней

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.O"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.O.O
    http://maven.apache.org/xsd/maven-4.O.O.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>example.com</groupId>
    <artifactId>example</artifactId>

    <version>1.0-SNAPSHOT</version>

    <dependencies>
        <dependency>
            <groupId>commons-io</groupId>
            <artifactId>commons-io</artifactId>
            <version>2.6</version>
        </dependency>
    </dependencies>
</project>
```

Тег `modelVersion` указывает на версию Maven, теги `groupld`, `artifactId`, `version` указывают название и версию нашего артифакта (артифактом будем называть приложение, модуль, библиотему, jar-файл и прочее). В теге `dependencies` в том же формате указаны зависимости нашего проекта, которые будут загружаться из Maven Central

Чтобы изменить структуру проекта, в Maven придумали архетипы - шаблоны проектов. С помощью архетипов можно создать готовые шаблоны проектов для библиотек, для веб-приложений, для плагина и т.д.. Чтобы посмотреть доступные архетипы, можно выполнить команду `mvn archetype:generate`

Так же как и Ant, Maven обладает своим жизненным циклом

| Фаза | Описание                                                                         |
| -------- | ---------------------------------------------------------------------------------------- |
| validate | Проверка корректность метаинформации о проекте |
| compile  | Компиляция файлов                                                        |
| test     | Проверка тестов на скомпилированных файлах         |
| package  | Упаковка в артефакт вида jar, zip и т.д.                         |
| verify   | Проверка артефактов                                                    |
| install  | Коммит артефакта в локальный репозиторий             |
| deploy   | Деплой на продакшен или удаленный репозиторий    |

Жизненный цикл можно расширять при помощи плагинов. Плагины устанавливают при помощи изменения `pom.xml`:

```xml
<plugins>
    <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-checkstyle-plugin</artifactId>
        <version>2.6</version>
    </plugin>
</plugins>
```

### <a name="google-gradle"></a> Google Gradle

Google Gradle был выпущен в 2008 году для облегчения разработки Java-приложений на Android. Вместо громоздкого XML система сборки Gradle поддерживает два языка для описания сборки: предметно-ориентированный языки **Groovy** и **Kotlin**.

В качестве репозитория зависимостей Gradle поддерживает репозитории Ivy, Maven Central и другие.

Так как Gradle постоянно меняется и не имеет совместимость между собой, существует Gradle Wrapper: скрипт `grablew` автоматически скачивает нужную версию Gradle, которая указана в `build.gradle`. Сам `build.gradle`, информация о проекте, выглядит так:

```groovy
plugins {
    id 'application'
}

repositories {
    mavenCentral ( )
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.1'

    implementation 'com.google.guava:guava:31.1-jre'
}

application {
    mainClass = 'demo.Арр'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

Или же можно создать `build.gradle.kts`, где указать то же самое, только на Kotlin:


```kotlin
plugins {
    application
}

repositories {
    mavenCentral ( )
}

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter:5.9.1")

    implementation("com.google.guava:guava:31.1-jre")
}

application {
    mainClass.set("demo.Арр")
}

tasks.named<Test>("test") {
    useJUnitPlatform()
}
```

Как и Maven, Gradle поддерживает плагины и имеет похожий цикл сборки


## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-4"></a> Лекция 4

Сборка мусора - процесс восстановления заполненной памяти среды выполнения путем уничтожения неиспользуемых объектов

В таких языках, как C и C++, программист сам отвечает за жизненный цикл объектов. В случае, если выделенная память для созданного объекта в конце его жизненного цикла не освобождается, то возникает утечка памяти:

```cpp
void foo() {
    // выделили память для 100 символов
    char* array = new char[100];

    // выделили память еще раз, перезаписали старый указатель, 
    // те самым потеряв к старому массиву доступ 
    array = new char[100];
}
```

Чтобы облегчить жизнь программиста и направить всю его концентрацию на создание бизнес-логики, придумали автоматическое управление памятью

В Java автоматическим управлением памятью занимается среда JVM. JVM по надобности выделяет нужный участок памяти на куче, в которой хранятся переменные, созданные программистом, и занимается сборкой мусора, то есть освобождением памяти уже ненужных переменных.

Перед сборщиком мусора (Garbage Collector) стоят 2 задачи:

* Обнаружение мусора
* Очистка мусора

Мусором мы будем считать объекты, ссылки на которые были утрачены, то есть доступ к нему невозможен

### <a name="%D0%BE%D0%B1%D0%BD%D0%B0%D1%80%D1%83%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5-%D0%BC%D1%83%D1%81%D0%BE%D1%80%D0%B0"></a> Обнаружение мусора

Есть 2 способа обнаруживать мусор:

* Счетчик ссылок (Reference counting)
* Трейсинг (Tracing)

Счетчик ссылок считает количество живых ссылок на объект. Если число ссылок достигает 0, то объект удаляется (подобно `shared_ptr` в С++). Несмотря на простоту, счетчик ссылок плохо сочетается с многопоточностью и без дополнительных алгоритмов не может выявлять циклические ссылки (объекты ссылаются друг на друга => счетчики не нулевые)

Трейсинг основан на графе объектов и его обхода. Для начала вводится понятие корневой точки (GC Root). Корневой точкой мы будем считать локальные переменные, статические переменные, потоки, ссылки из Java Native Interface и т.д.. Затем строится дерево ссылок. Мусором считается тот объект, до которого нельзя попасть из корневых точек.

Компилятор знает, когда заканчивается скоуп, в котором живет переменная, поэтому при выходе из скоупа (тела функции, цикла и т.д.) корневые точки прекращают свое существование (за исключением тех, что были возвращены функцией). Пример:

```java
public House doSomething(string[] args) {
    Person person = new Person("Ivan");

    person.setHouse(new House());
    person.getHouse().setRoof(new Roof());
    person.getHouse().setDoor(new Door());

    Person person1 = new Person("Michael");
    Person person2 = new Person("John");
    person1.setFriend(person2);
    person2.setFriend(person1);

    return person;
}
```

Получаем такой лес объектов:

```
 person     
  |- house
      |- roof
      |- door

 person1
  |- person2
      |- ...

 person2
  |- person1
      |- ...
```

После `return` объект `person` остается жить, потому что он был возвращен, а `person1` и `person2` - нет. Несмотря на то, что количество ссылок на них ненулевое количество, из корневых точек в них попасть мы не можем (а таковым они перестают считаться после `return`)

### <a name="%D0%BE%D1%87%D0%B8%D1%81%D1%82%D0%BA%D0%B0-%D0%BC%D1%83%D1%81%D0%BE%D1%80%D0%B0"></a> Очистка мусора

От сборщика мусора нам нужно, что бы он:

* за предсказуемое время завершал свою работу (Latency and Responsiveness)
* не потреблял много оперативной памяти (Memory Footprint)
* не требовал большего количества вычислительных ресурсов (Throughput)

Добиться всех трех свойств нереально, поэтому то, что сейчас есть - это компромиссы между ними

Существует несколько алгоритмов очистки мусора. Один из них - копирующая сборка

Для копирующей сборки память условно делится на две части: **from-space** и **to-space**. Сначала объекты попадают в from-space. Когда она заполняется, происходит stop-the-world (остановка мира), сборщик мусора проходится по объектам, копирует нужные объекты в to-space, а ненужные высвобождаются. После этого области памяти from-space и to-space меняются местами (свапаются указатели)

Stop-the-world гарантирует, что во время очистки не выделится память для новых объектов, тем самым граф объектов будет заморожен

Другим методом является "отслеживание и очистка" (Mark and Sweep). При помощи трейсинга сборщик мусора помечает живые объекты и во время остановки мира пробегается по всем объектам и удаляет те, которые не были помечены живыми. После очистки объекты могут располагаться по всей памяти, тем самым фрагментируя ее. Дополнительно может производиться дефрагментация памяти (такой алгоритм называют Mark and Sweep Compact): сдвиг живых объектов в самое начало. Заметим, что дефрагментация - очень дорогая операция.

Еще один алгоритм основывается на так называемой "слабой гипотезе о поколениях". В процессе наблюдения заметили, что объекты либо живут очень мало, либо очень много, причем чаще всего объекты из одной группы почти никак не связаны с объектами из другой. 

Будем говорить, что быстроживущие объекты принадлежат младшему поколению (young generation), а долгоживущие - старшему поколению (old generation). Наблюдения привели к тому, что большинство объектов принадлежат младшему поколению (итераторы, локальные переменные и т.д.), тогда как если объект принадлежит старшему поколению, то не нужным он будет совсем не скоро.

Поэтому имеет смысл сделать три типа очистки: 

* minor - очистка объектов из младшего поколения
* major - очистка объектов из старшего поколения
* full - очистка всех объектов

Сразу оговоримся, что мы рассматриваем алгоритм, реализованный в HotSpot JVM. Реализация может очень сильно отличаться от виртуальной машины и выбранного сборщика мусора.

Тогда мы можем разделить нашу память на 3 части:

* Эдем (Eden) - здесь хранятся только что созданные объекты
* Пространство выживших (Survivor Space) - здесь хранятся объекты, выжившие одну очистку мусора и перешедшие сюда из Эдема. Survivor Space делится на 2 части, S0 и S1, между которыми работает копирующая сборка
* Хранилище (Tenured) - здесь хранятся объекты старшего поколения

До Java 8 память JVM выглядела так:

![picture](images/javatech_2025_02_28_1.png)

Помимо выше указанных существовала область PermGen - постоянное поколение. Там хранились метаданные о классах, и располагалась она на стеке. С Java 8 эту область решили назвать MetaSpace и перенести на кучу

Таким образом, Minor сборка мусора начинается с тех пор, как заполняется Эдем. Из Эдем выжившие объекты переходят в Пространство выживших. В Major сборке очищается хранилище

Сборщики мусора, основывающиеся на поколениях, называют Generational Garbage Collector

### <a name="%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8-%D1%81%D0%B1%D0%BE%D1%80%D1%89%D0%B8%D0%BA%D0%BE%D0%B2-%D0%BC%D1%83%D1%81%D0%BE%D1%80%D0%B0"></a> Реализации сборщиков мусора

Разберем некоторые реализации сборщиков мусора из HotSpot JVM

**Serial GC**

Простенький сборщик мусора для однопоточных приложений. Во время работы останавливает все приложение, поэтому не рекомендуется в случае, когда необходимы минимальные задержки. Включается флагом `-XX:UseSerialGC` в JVM

**Parallel GC**

Сборщик мусора по умолчанию, работает в несколько потоках, во время работы останавливает все приложение. Включается флагом `-XX:UseParallelGC`

**CMS GC**

Concurrent Mark and Sweep сборщик работает как и Parallel GC, только сводится время остановки мира к минимуму засчет большего потребления ресурсов ЦП. CMS GC не выполняет дефрагментацию. Включается флагом `-XX:UseConcMarkSweepGC`

**G1 GC**

Garbage 1st GC работает как и CMS GC, только вместо разделения памяти на поколения, память разделена на набор областей, каждая из которых может представлять младшее либо старшее поколение. Используется в Minecraft👍. Включается флагом `-XX:UseG1GC`

**Epsilon GC**

Совсем ниче не умеет, используется, когда мусора в вашем коде нет. Сдается, когда память закончилась. Включается флагом `-XX:UnlockExperimentalVMOptions -XX:UseEpsilonGC`

**Shenandoah GC**

Работает как G1 GC, только с меньшими задержками и большими затратами на ЦП. Включается флагом `-XX:UnlockExperimentalVMOptions -XX:UseShenandoahGC`

**ZGC**

Используется, когда нужны очень маленькие задержки и когда есть очень много оперативной памяти. Использовать лучше на сервере с огромном оперативкой, а не на тостере. Включается флагом `-XX:UnlockExperimentalVMOptions -XX:UseZGC`

---

В целом, выбор сборщика мусора зависит от характера разрабатываемого приложения. Однако, если приложение небольшое, то лучше прислушаться к настройкам по умолчанию👍


