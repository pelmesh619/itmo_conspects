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
  * [Лекция 5](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-5)
    * [Java Database Connectivity](#java-database-connectivity)
    * [Java Persistence API](#java-persistence-api)
  * [Лекция 6](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-6)
    * [Spring IoC](#spring-ioc)
  * [Лекция 7](#%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-7)
    * [Spring MVC](#spring-mvc)
  * [X. Программа экзамена 2024/2025](#x.-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B0-%D1%8D%D0%BA%D0%B7%D0%B0%D0%BC%D0%B5%D0%BD%D0%B0-2024%2F2025)



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


## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-5"></a> Лекция 5

Архитектура большинства приложений состоит из трех уровней:

* клиентский
* промежуточный
* уровень доступа к данным

Для уровня доступа к данным существуют такие инструменты:

* Java Database Connectivity API (JDBC API) - низкоуровневое API для доступа к хранилищу данных. Типичное использование JDBC — написание SQL запросов к конкретной базе данных.
* Java Persistence API - интерфейс для доступа к данным и преобразования этих данных в объекты языка программирования Java и наоборот. Гораздо более высокоуровневое API по сравнению с JDBC.
* Java Transaction API - интерфейс для определения и управления транзакциями, включая распределенные транзакции, а также транзакции, затрагивающие множество хранилищ данных.

### <a name="java-database-connectivity"></a> Java Database Connectivity

JDBC представляет собой общий интерфейс для доступа к базе данных. Для подключения используется менеджер драйверов:

```java
Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/db_name",
    "user", "password");
```

`DriverManager` сам выберет нужный драйвер для указанной базы данных (в данном случае `mysql`)

![JDBC](images/jdbc_structure.png)

Чтобы сам класс нужного драйвера появился в проекте, используем менеджер зависимостей:

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.29</version>
</dependency>

```

```kotlin
dependencies {
    implementation('mysql:mysql-connector-java:8.0.29')
}
```

<!-- kotlin supremacy -->

Используя JDBC, с базой данных можно работать при помощи сырых SQL-запросов: 

```java
try (Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/db_name", "user", "password");
     Statement stmt = conn.createStatement()) {
    
    // SELECT-запрос
    ResultSet rs = stmt.executeQuery("SELECT * FROM users");

    // Выводим идентификаторы и имена пользователей
    while (rs.next()) {
        System.out.println(rs.getInt("id"));
        System.out.println(rs.getString("name"));
    }

    // INSERT-запрос
    int rows = stmt.executeUpdate("INSERT INTO users (name) VALUES ('John')");
    System.out.println("Добавлено строк: " + rows);
} catch (SQLException e) {
    e.printStackTrace();
}
```

Все SQL-запросы можно разделить на два типа:

* Получение данных - инструкции SELECT и другие
* Изменение данных - инструкции INSERT, UPDATE, DELETE и другие

Для первых запросов используется метод `executeQuery()`, который возвращает `ResultSet`, содержащий данные

Для вторых запросов используется метод `executeUpdate()`, возвращающий количество измененных строк

При помощи JDBC можно создать выполнимую процедуру внутри базы данных:

```java
CallableStatement callableStatement =
    connection.prepareCall("{call calculateStatistics(?, ?)}",
        ResultSet.TYPE_FORWARD_ONLY,
        ResultSet.CONCUR_READ_ONLY,
        ResultSet.CLOSE_CURSORS_OVER_COMMIT
    );
```

Такие функции выполняются на сервере базе данных, то есть выигрывают в производительности, так как работают в одном пространстве памяти

При желании альтернативно можно создать подключение через определенный драйвер для базы данных, объявив DataSource:

```java
OracleDataSource Ods = new OracleDataSource();

ods.setUser("stud");
ods.setPassword("stud");
ods.setDriverType("thin");
ods.setDatabaseName("stud");
ods.setServerName("localhost");
ods.setPortNumber(1521);

Connection conn = ods.getConnection();
```

Методы и их количество могут отличаться от драйвера к драйверу

Здесь `thin` - тип драйвера. Всего существуют 4 типа:

* Первый тип (Type-1) или JDBC-ODBC bridge driver
* Второй тип (Type-2) или Native-API driver
* Третий тип (Type-3) или Network Protocol driver
* Четвертый тип (Type-4) или Thin driver

Если нужно обратиться к одному типу базы данных, предпочтительным типом драйвера является Type-4.  
Если Java-приложение обращается к нескольким типам баз данных одновременно, Type-3 является предпочтительным драйвером.  
Драйверы Type-2 полезны в ситуациях, когда драйвер Type-3 или Type-4 еще недоступен для вашей базы данных.  
Драйвер Type-1 обычно используется только при разработки и тестирования.

Зачастую пользоваться JDBC неудобно, так как все запросы становятся хардкодом, а Java-разработчики могут не знать SQL. Поэтому появился JPA

### <a name="java-persistence-api"></a> Java Persistence API

Java Persistence API - спецификация, описывающая систему управления сохранением Java объектов в таблицы реляционных баз данных в удобном виде. Сама Java не содержит реализации JPA, однако есть существует много реализаций данной спецификации от разных компаний. 

Заметим, что JPA - это не единственный способ сохранения Java-объектов в базы данных (Object-Relational-Model-систем), но один из самых популярных.

Hibernate - одна из самых популярных открытых реализаций JPA версии 2.1. Далее будем рассматривать ее,
как реализацию JPA

Чтобы объявить персистентную сущность, объявим ее аннотацией `@Entity`

```java
@Entity
// явно указываем, из какой таблицы принадлежит сущность
@Table(name = "users")
public class User {
    // говорим, что id - это первичный ключ, который будет генерироваться сам
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // указываем, что имя столбца отличается от имени атрибута
    @Column(name = "user_name")
    private String name;

    // связь многие-к-одному
    @ManyToOne
    @JoinColumn(name = "countries")
    private Country country;
    
    // геттеры, сеттеры, другие методы
}
```

По умолчанию, Hibernate будет искать сущести в базе данных по их именам атрибутов (то есть переводя camelCase полей классов в snake_case атрибутов базы данных)

Далее сущности указываются в так называемой единице персистентности (persistence unit) в файле `resources/META-INF/persistence.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="2.2"
             xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence
     http://xmlns.jcp.org/xml/ns/persistence/persistence_2_2.xsd">

    <!-- Здесь myunit - название группы сущностей -->
    <persistence-unit name="myunit">
        <description>
            Описание
        </description>

        <!-- Здесь перечисляются сущности -->
        <class>org.example.models.User</class>

        <properties>
            <!-- Данные для подключения -->
            <!-- Здесь в качестве примера СУБД PostgreSQL и база данных с именем cats, находящаяся на localhost -->
            <property name="hibernate.connection.driver_class" value="org.postgresql.Driver" />
            <property name="hibernate.connection.url" value="jdbc:postgresql://localhost:5432/cast" />
            <property name="hibernate.connection.username" value="${POSTGRES_USERNAME}" />
            <property name="hibernate.connection.password" value="${POSTGRES_PASSWORD}" />

            <!-- Настройка миграции -->
            <property name="hibernate.hbm2ddl.auto" value="X" />
            <!-- Вместо X подставить нужное значение:
                validate - проверяет, что схема базы данных соответствует объектной модели, но не делает никаких изменений
                update - обновляет схему с сохранением данных
                create - создает схему, удаляя предыдущие данные
                create-drop - создает схему, удаляя предыдущие данные, а также удаляет схему к концу сессии
            -->
        </properties>
    </persistence-unit>
</persistence>
```

А чтобы работать с ними, используют `EntityManager`:

```java
// Создаем EntityManager
EntityManagerFactory emf = Persistence.createEntityManagerFactory("myunit");
EntityManager em = emf.createEntityManager();

// Поиск по идентификатор
User user = em.find(User.class, 1L);
System.out.println(user.getName());

// JPQL-запрос
TypedQuery<User> query = em.createQuery(
    "SELECT u FROM User u WHERE u.name LIKE 'A%'", User.class);
List<User> users = query.getResultList();

// Закрываем сессию
em.close();
```

Сущности, включенные в JPA, имеют свое состояние:

* Новый объект - объект, созданный с помощью `new`, но еще не имеет сгенерированный ключей и не хранится в базе данных
* Удаленный объект - объект, который будет удален из базы данных после совершения транзакции
* Управляемый объект - объект, который управляется JPA
* Отсоединенный объект - объект, который существует в базе данных, но который не управляется JPA

![Состояния объекта в JPA](images/jpa_object_states.png)



## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-6"></a> Лекция 6

Spring Framework (или коротко Spring) — универсальный фреймворк с открытым исходным кодом для Java-платформы.

Spring является собой свободной альтернативной Java EE (или Jakarta EE), предоставляющая функционал для enterprise-разработки. Spring имеет множество расширений (MVC, Data и т.д.) и активной поддерживается сообществом

<!-- раньше Spring был для Java EE, но теперь для воы=щаоектишоишащрощкриащшркщпрщ -->

### <a name="spring-ioc"></a> Spring IoC

Центральной частью Spring является контейнер Inversion of Control (инверсия управления). Он нужен для: 

* управления жизненным циклом объектов
* связывания их между собой

По сути, то же самое, что и Dependency Injection в C#

Сами объекты, находящиеся в контейнере (еще называемом контекстом), называются **бинами** (bean)

Чтобы установить Spring, воспользуемся магическими строчками:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.3.30</version>
    </dependency>
</dependencies>
```

```kotlin
dependencies {
    implementation('org.springframework:spring-context:5.3.30')
}
```

Зависимый объект может передаваться зависящему:

* напрямую через вызов метода контейнера
* через внедрение зависимостей (как аргумент конструктора, сеттера или свойства)

Чтобы Spring понял, какие классы должны стать бинами и участвовать в инверсии управления, их нужно

* указать в xml-конфиге `context.xml`
* аннотировать нужные сущности и указать пакет, в котором они находятся
* аннотировать нужные сущности и указать класс, который задает конфигурацию

Рассмотрим способ, включающий в себя xml-конфиг. Создадим две сущности - `UserRepository` и `UserService`:

```java
public class UserRepository {
    public String getData() {
        return "Данные из репозитория";
    }
}
```

```java
public class UserService {
    private final UserRepository userRepository;

    private String endpoint;

    public void setEndpoint(String endpoint) { this.endpoint = endpoint; }
    public String getEndpoint() { return this.endpoint; }
    
    // Конструктор для инъекции зависимости
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    public void processData() {
        System.out.println("Обработка данных: " + userRepository.getData());
    }
}
```

Далее заполняем наш `context.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- Определяем бин для UserRepository -->
    <bean id="userRepository" class="UserRepository"/>
    
    <!-- Создаем бин UserService с инъекцией зависимости через конструктор -->
    <bean id="userService" class="org.example.models.UserService">
        <constructor-arg ref="userRepository"/>

        <!-- Можно указать свойство -->
        <property name="endpoint" value="google.com"/>
    </bean>
</beans>
```

Теперь в `Main.java` достаем контекст из конфига и используем его:

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        // Загрузка контекста Spring из xml-файла
        ApplicationContext context = new ClassPathXmlApplicationContext("context.xml");
        
        // Получаем бин UserService из контейнера
        UserService userService = context.getBean("userService", UserService.class);
        
        // Используем сервис
        userService.processData();
    }
}
```

Здесь мы вручную создали только `ClassPathXmlApplicationContext` - все остальные объекты создал Spring

Вместо xml-конфига, можно создать конфиг-класс, в котором вручную прокинуть зависимости:

```java
@Configuration
public class AppConfig {
    // Указываем, что это бин
    @Bean
    public UserRepository userRepository() {
        return new UserRepository();
    }

    @Bean
    public UserService userService() {
        return new UserService(userRepository());
    }
}
```

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        
        UserService userService = context.getBean("userService", UserService.class);
        
        userService.processData();
    }
}
```

Это все надо делать ручками, поэтому перешли к сканированию пакета и аннотациям. Есть две аннотации, которые способствуют этому:

* `@Component` - так помечаем класс, который будет участвовать во внедрении зависимости
* `@Autowired` - так помечаем метод (в том числе конструктор), которому будут передаваться зависимости из контейнера (также возможно приватное поле, которому будет передано зависимость)

В нашем примере это:

```java
@Component
public class UserRepository {
    public String getData() {
        return "Данные из репозитория";
    }
}
```

```java
@Component
public class UserService {
    private final UserRepository userRepository;
    
    // Указываем, куда надо засунуть зависимость
    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    public void processData() {
        System.out.println("Обработка данных: " + userRepository.getData());
    }
}
```

Далее аннотированные классы можно показать Spring либо с указанием пакета, в котором они находятся:

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        // Загрузка контекста Spring из сканирования пакета
        ApplicationContext context = new AnnotationConfigApplicationContext("org.example.models");
        
        UserService userService = context.getBean("userService", UserService.class);
        
        userService.processData();
    }
}
```

либо через отдельный класс конфига (так называемого JavaConfig), в котором указать пакет:

```java
@Configuration
@ComponentScan("org.example.models")  // Указываем пакет для сканирования
public class AppConfig {
}
```

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        
        UserService userService = context.getBean("userService", UserService.class);
        
        userService.processData();
    }
}
```

Вместо `@Component` можно использовать `@Service`, `@Repository`, `@Controller`, чтобы повысить читаемость

Если класс имеет несколько конструкторов, то можно добавить аннотацию `@Primary` для указания главного конструктора, которому будут передаваться зависимости

Чтобы задать скоуп (жизненный цикл) компонента, можно использовать аннотации:

```java
@Scope("prototype") 
@Scope("singleton") 
// или 
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
// ну и там еще есть request, session, application, websocket
```

или в xml-конфиге:

```xml
    <bean id="userService" class="org.example.models.UserService" scope="singleton"/>   
```

---

Как это работает?

Сначала Spring достает все нужные ему сущности. 

* Если это происходит через xml-файл, то используется объект класса `XmlBeanDefinitionReader`. 
* Если это происходит через сканирование пакетов, то объект класса `AnnotationBeanDefinitionReader` ищет все `@Configuration`, в которых могут быть дополнительные конфиги. Далее `ClassPathBeanDefinitionScanner` сканирует пакет на наличие `@Component`-классов

Теперь все считанные классы и интерфейсы запаковываются в объекты `BeanDefinition`, которые описывают будущие бины

По умолчанию, все `BeanDefinition` остаются не изменными, однако если в бинах случайно затесалась реализация `BeanFactoryPostProcessor`, то он используется для изменения описания бинов до их непосредственного создания. Пример такого `BeanFactoryPostProcessor`:

```java
public class CustomBeanFactoryPostProcessor implements BeanFactoryPostProcessor {

    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        // Модифицируем существующий бин
        BeanDefinition dbConfigDef = beanFactory.getBeanDefinition("dbConfig");
        dbConfigDef.getPropertyValues().add("url", "jdbc:postgresql://default-host:5432/db");
        
        // Создаем новый бин
        GenericBeanDefinition newBeanDef = new GenericBeanDefinition();
        newBeanDef.setBeanClassName("java.lang.String");
        newBeanDef.getConstructorArgumentValues().addGenericArgumentValue("ЛОЛ!");
        
        ((DefaultListableBeanFactory)beanFactory).registerBeanDefinition("myBean", newBeanDef);
    }
}
```

Все эти описания бинов хранятся в мапе. После этого они создаются при помощи `BeanFactory`

Если объект создается суперсложно, то его создание можно делегировать объекту класса, реализующего `FactoryBean`, например:

```java
import org.springframework.beans.factory.FactoryBean;

// Создаем строки
public class StringFactoryBean implements FactoryBean<String> {
    private String prefix;
    private int counter = 0;

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    @Override
    public String getObject() {
        return prefix + "-" + (counter++);
    }

    @Override
    public Class<?> getObjectType() {
        return String.class;
    }

    @Override
    public boolean isSingleton() {
        return false;
    }
}
```

Теперь можно получить объекты или фабрику:

```java
String str = context.getBean("customStringFactory", String.class);
        
StringFactoryBean factory = context.getBean("&customStringFactory", StringFactoryBean.class);
```

ПОСЛЕ ЭТОГО, в ход вступают реализации `BeanPostProcessor`, которые могут дополнительно произвордить действия над созданными бинами перед и/или после инициализации (например, положить в прокси). Под инициализацией понимаются методы бинов, аннотированные `@PostConstruct` или указанные в xml как `init-method`: `<bean id="userService" class="com.example.models.UserService" init-method="init"/>`

```java
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Component;

@Component
public class CustomBeanPostProcessor implements BeanPostProcessor {
    
    // Вызывается ПЕРЕД инициализацией бина
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("Преинициализация: " + beanName);
        return bean;
    }

    // Вызывается ПОСЛЕ инициализации бина
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("Постинициализация: " + beanName);
        
        // Добавляем прокси для важного сервиса
        if (bean instanceof ImportantService) {
            return makeProxy(bean);
        }
        return bean;
    }

    private Object makeProxy(Object bean) {
        System.out.println("Создаю прокси...");
        return bean;
    }
}
```

Теперь готовые бины кладутся в контекст

Когда контекст закрывается, у всех бинов вызывается метод, помеченный `@PreDestroy` или `destroy-method="..."` в xml

![Spring Beans](images/spring_beans.png)


## <a name="%D0%BB%D0%B5%D0%BA%D1%86%D0%B8%D1%8F-7"></a> Лекция 7

### <a name="spring-mvc"></a> Spring MVC

Spring MVC – модуль, который обеспечивает архитектуру паттерна Model - View - Controller (Модель - Отображение (или Вид) - Контроллер) при помощи слабо связанных готовых компонентов. Паттерн MVC разделяет аспекты приложения (логику ввода, бизнес-логику и логику UI), обеспечивая при этом свободную связь между ними.

* **Model** (Модель) инкапсулирует (объединяет) данные приложения, в целом они будут состоять из POJO (Plain Old Java Object - "Старый добрый Java-объект", или бинов).
* **View** (Отображение, Вид) отвечает за отображение данных Модели, - как правило, генерируя HTML, которые мы видим в своём браузере.
* **Controller** (Контроллер) обрабатывает запрос пользователя, создаёт соответствующую Модель и передаёт её для отображения в Вид.


Spring MVC построен вокруг сервлета (объекта, который принимает запросы) `DispatcherServlet`, который распределяет запросы по контроллерам, а также предоставляет другие широкие возможности при разработке веб приложений. 

`DispatcherServlet` уже интегрирован в Spring IoC, поэтому имеет доступ к встроенным в контекст бинам

`DispatcherServlet`, исходя из полученного HTTP-запроса, вызывает нужный контроллер, отмеченный аннотацией `@Controller`. Чтобы установить нужное действие по определенному эндпоинт, воспользуемся аннотацией `@RequestMapping`. В ней можно обозначить эндпоинт (и не только просто строка, а параметризированную ([\*тык\*](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-requestmapping.html#mvc-ann-requestmapping-uri-templates))), а также метод запроса

```java
@Controller
@RequestMapping("/hello")
public class HelloControtter {
    @RequestMapping(method = RequestMethod.GET)
    public String printHetto(ModelMap model) {
        model.addAttribute("message", "Hello Spring MVC Framework!");
        return "hello";
    }
}
```

Здесь вместо `@RequestMapping(method = RequestMethod.GET)` можно указать `@GetMapping`. Также есть другие специальные аннотации для типов запросов: `@PostMapping`, `@PutMapping`, `@DeleteMapping`, `@PatchMapping`

Еще пример:

```java
@Controller
public class HelloController {
    // Обработка GET-запроса на /hello
    @GetMapping("/hello")
    public String helloForm() {
        return "hello-form"; // Вернет содержимое файла hello-form.html
    }

    // Обработка POST-запроса на /hello
    @PostMapping("/hello")
    public String sayHello(
        @RequestParam("name") String name, 
        Model model
    ) {
        // Здесь мы достаем имя из тела запроса и передаем его модели, 
        // контейнером, который передается слою с отображением
        model.addAttribute("name", name.toUpperCase());
        return "hello-response"; // Шаблон ответа
    }
}
```

Готовые реализации интерфейса `HandlerMapping` могут в ответ на запрос дать нужный метод. По умолчанию есть:

* `RequestMappingHandlerMapping` ищет методы по аннотациям `@RequestMapping` и другим

* `BeanNameUrlHandlerMapping` использует параметры в аннотации `@Bean` ([\*тык\*](https://www.baeldung.com/spring-handler-mappings)):

    ```java
    @Configuration
    public class BeanNameUrlHandlerMappingConfig {
        @Bean
        BeanNameUrlHandlerMapping beanNameUrlHandlerMapping() {
            return new BeanNameUrlHandlerMapping();
        }

        @Bean("/beanNameUrl")
        public WelcomeController welcome() {
            return new WelcomeController();
        }
    }
    ```

    Или в xml-конфиге:

    ```xml
    <bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping" />
    <bean name="/beanNameUrl" class="org.example.WelcomeController" />
    ```

Можно еще указать через `SimpleUrlHandlerMapping` - он использует явно добавленные методы:

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public SimpleUrlHandlerMapping urlHandlerMapping() {
        SimpleUrlHandlerMapping mapping = new SimpleUrlHandlerMapping();

        // Создаем мапу
        Map<String, Object> urlMap = new HashMap<>();
        urlMap.put("/manual", manualHandler());

        // Указываем, в какой мапе смотреть эндпоинты
        mapping.setUrlMap(urlMap);

        // Указываем порядок обработки
        mapping.setOrder(1);

        return mapping;
    }

    // Обработчик контроллера
    @Bean
    public HttpRequestHandler manualHandler() {
        return (request, response) -> {
            response.getWriter().write("Handled manually!");
        };
    }
}
```

Контроллер чаще всего пишем мы сами, поэтому у него нет привязки к интерфейсу из библиотеки Spring. Поэтому существует `HandlerAdapter`. Выглядит он так:

```java
public interface HandlerAdapter {
    boolean supports(Object handler);
    
    ModelAndView handle(
        HttpServletRequest request,
        HttpServletResponse response, 
        Object handler) throws Exception;
    
    long getLastModified(HttpServletRequest request, Object handler);
}
```

Перед непосредственной обработкой запроса вызывается `supports`, который возвращает, доступен ли обработчик `handler` к работе. Далее вызывается `handle`, который его обрабатывает и возвращает отображение

Помимо этого Spring MVC кладет в контейнер с бинами:

* `HandlerExceptionResolver` решает, что нужно выдавать, если контроллер бросил исключение (например, показывать дефолтную 404 страницу)

* `ViewResolver` преобразовывает имена представления, возвращенное контроллером, в фактическое представление (ну еще рендеринг делает)

* `LocaleResolver` и `LocaleContextResolver` определяют локаль и часовой пояс

* `ThemeResolver` достает из куков, сессии, параметров запроса тему, а затем по ней судит, какие давать стили CSS, картинки и прочее

* `MultipartResolver` обрабатывает составные запросы (с `Content-Type: multipart/form-data`), сохраняет файлы в память/временную папку и передает их контроллеру вместе с другими текстовыми полями

* `FlashMapManager` хранит данные одного запроса для использования в другом (например, между редиректами)

---

Разберем, как работает DispatcherServlet:

1. При получении HTTP-запроса `DispatcherServlet` должен определить при помощи доступных ему `HandlerMapping` какому обработчику (методу контроллера) переправить запрос в виде `HttpServletRequest`.

2. После определения контроллера внутри `HandlerMapping` список `HandlerExecutionChain` (по сути цепочка обязанностей) из реализаций `HandlerInterceptor` возвращается вместе с именем контроллера. Интерцепторы используются для пред- и постобработки запроса, а также после отсылки отображения клиенту

3. Для обработчика создается обертка в виде `HandlerAdapter`, реализации которых были найдены в контексте. По умолчанию, это:

    * `HttpRequestHandlerAdapter` для классов, реализующих `HttpRequestHandler`

    * `SimpleControllerHandlerAdapter` для классов, реализующих интерфейс `Controller` 

    * `RequestMappingHandlerAdapter` для классов/методов, аннотированных `@RequestMapping`

4. Цепочка `HandlerExecutionChain` вызывается, исполняя методы `preHandle` у интерцепторов. Если какой-либо интерцептор вернет `false`, то запрос не дойдет до самого контроллера. Тогда считается, что запрос обработан интерцептором

5. Когда все интерцепторы сказали `true`, вызывается `handle` у `HandlerAdapter`

6. Контроллер принимает запрос, обрабатывает его и:

    * сохраняет атрибуты отображения в `Model` (например, через `model.addAttribute`) и возращает имя отображения. 
    * либо возвращает `ModelAndView` с именем отображения и атрибутами
    
    Если контроллер хочет имплементировать REST API, то он сохранит все нужное в `Model` и вернет `null`. Чтобы определить REST-методы, можно воспользоваться аннотациями `@ResponseBody` для методов или `@RestController` для классов

7. Теперь у интерцепторов цепочки `HandlerExecutionChain` вызываются `postHandle` для постобработки

8. При помощи интерфейса `ViewResolver` `DispatcherServlet` определяет, какое отображение нужно использовать на основании полученного от контроллера имени

9. После того, как отображение создано, `DispatcherServlet` отправляет данные `Model` в виде атрибутов в отображение в метод `render()`, далее отображение в конечном итоге сохраняется в `HttpServletResponse`, а ответ далее идет отображаться в браузере

10. В конце вызываются `afterCompletion` у интерцепторов цепочки (например, для логгирования)

![a](images/spring_dispatcherservlet.jpg)

Если на каком-то этапе произошла ошибка, то реализации `HandlerExceptionResolver` возвращают какую-нибудь страничку с "что-то пошло не так". По умолчанию в контексте есть:

* `ExceptionHandlerExceptionResolver` обрабатывает исключения, передавая их аннотированным `@ExceptionHandler` методам:

    ```java
    @ExceptionHandler(UserNotFoundException.class)  
    public ResponseEntity<String> handleUserNotFound(UserNotFoundException ex) {  
        return ResponseEntity  
                .status(HttpStatus.NOT_FOUND)  
                .body(ex.getMessage());  
    }  
    ```

* `ResponseStatusExceptionResolver` может отлавливать аннотированные `@ResponseStatus` исключения:

    ```java
    @ResponseStatus(code = HttpStatus.NOT_FOUND, reason = "This user is not found")  
    public class UserNotFoundException extends RuntimeException {}  
    ```

    Здесь сообщение жестко зафиксировано, такое не получиться со стандартными исключениями, а также не вернуть какой-нибудь JSON

    Также альтернативно можно кидать такие исключения в метода обработчика:

    ```java
    throw new ResponseStatusException(  
        HttpStatus.NOT_FOUND,  
        "User " + id + " not found!"  
    );  
    ```

* `DefaultHandlerExceptionResolver` работает для стандартных Spring-исключений, возвращая подходящие для них HTTP коды статусов. Например, если вызвать GET для `/user?id=abc` при имеющемся обработчике

    ```java
    @GetMapping("/user")  
    public User getUser(@RequestParam int id) { ... } 
    ``` 

    `DispatcherServlet` выбросит ошибку `TypeMismatchException`, а `DefaultHandlerExceptionResolver` вернет 

    ```
    HTTP 400 Bad Request  
    Body: "Failed to convert value of type 'java.lang.String' to required type 'int'"  
    ```

Если HTTP-запрос пришел с заголовком `Accept: <MIME_type>/<MIME_subtype>`, то `HttpMessageConverter` будет искать доступные POJO доменной модели, пока не найдет соответствие с указанным в запросе типом. Далее `HttpMessageConverter` конвертирует тела входящих запросов в POJO, а в конце обработки запроса POJO в тела HTTP-ответов. По умолчанию, Spring Boot определяет набор дефолтных `HttpMessageConverter`

![a](../images/catmeme.jpg)


## <a name="x.-%D0%BF%D1%80%D0%BE%D0%B3%D1%80%D0%B0%D0%BC%D0%BC%D0%B0-%D1%8D%D0%BA%D0%B7%D0%B0%D0%BC%D0%B5%D0%BD%D0%B0-2024%2F2025"></a> X. Программа экзамена 2024/2025

1. Что такое виртуальная среда исполнения управляемого кода? Каковы отличия от неуправляемых языков?

2. Что такое спецификация языка? Отличия между основными изданиями Java. Приведите примеры набора API различных изданий.

3. Иеррархия интерфейсов для работы с коллекциями. Особенности Stream API.

4. Системы сборок, предназначение, ключевые особенности. Понятие модульности и конвенций иеррархии пакетов.

5. Автоматическое управление памятью. Алгоритмы отчистки.

6. Сборка мусора на поколениях. Устройство кучи. Принцип работы.  

7. Технологии Java EE для работы с данными. Популярные имплементации спецификации JPA.

8. Особенности реализации CDI в Spring. Внедрение зависимостей. Инверсия контроля.

9. Что такое «сервлет»? Отличия сервера приложений и контейнеров сервлетов.

10. Жизненный цикл запроса в рамках DispatcherServlet в Spring.

11. Основные задачи решаемые с помощью Spring Boot. С помощью каких инструментов достигается результат?

12. Инструменты и типовые решения для аутентификации и авторизации запросов.   

13. Парадигма аспектно-ориентированного программирования. Отличия от ООП.

14. Межсервесное взаимодействие. Микросервисная архитектура.

15. Какие ключевые задачи решают брокеры сообщений? Перечислите известные вам модели обмена сообщениями и протоколы.

16. Ключевые отличия Apache Kafka от RabbitMQ. Паттерн Outbox.

