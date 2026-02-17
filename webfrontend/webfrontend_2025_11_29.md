## Лекция 8. ООП в JavaScript

Классы в JavaScript появились в стандарте ECMAScript в 2015 году

В JavaScript наследование реализовано через прототипную модель, а классы являются синтаксическим сахаром над прототипами. Прототипное наследование - это механизм, где объекты могут заимствовать свойства и методы у других объектов через цепочку прототипов

Чтобы создать класс в JavaScript, есть несколько способов:

* Выражение класса:

    ```js
    var Rectangle = class {
        constructor(height, width) {
            this.height = height;
            this.width = width;
        }
    };
    // или 
    class Rectangle2 {
        constructor(height, width) {
            this.height = height;
            this.width = width;
        }
    };
    ```

    Как можно заметить, класс может быть анонимным. Обратиться к объекту внутри методов можно с помощью слова `this`

    Объект класса создается с помощью ключевого слова `new`: `const rect = new Rectangle(5, 4)`

* Функция-конструктор:

    ```js
    function Human(firstName, lastName) {
        this.firstName = firstName
        this.lastName = lastName

        this.getFullName = function () {
            return firstName + ' ' + lastName
        }
    }

    const chris = new Human("Terry", "Crews")
    ```

* Фабричная функция - функция, возвращающая объект:

    ```js
    function Human(firstName, lastName) {
        return {
            firstName,
            lastName
        }
    }

    const chris = Human("Terry", "Crews")
    ```

Классы в JavaScript также поддерживают наследование:

```js
class Person {
    constructor(firstName, lastName) {
        this.firstName = firstName
        this.lastName = lastName
    }

    getFullName() {
        return this.firstName + ' ' + this.lastName
    }
}

class User extends Person {
    constructor(firstName, lastName, email) {
        // обязательно нужно вызвать super, конструктор класса-родителя
        super(firstName, lastName)
        this.email = email
    }

    getEmail() {
        return this.email
    }
}
```

Каждый объект в JavaScript имеет скрытую ссылку на другой объект - прототип. Новый объект создаётся со ссылкой на прототип, а не копирует его свойства

Когда происходит обращение к свойству, интерпретатор ищет его в самом объекте, если не находит - идёт в прототип, если и там его нет, то ищет в прототипе прототипа и так далее

Такая структура образует цепочку прототипов (prototype chain)

Например, массивы `Array` наследуются от `Array.prototype`, который включает методы:

* акцессоры - они не изменяют исходный массив

    `Array.prototype.includes(e)` - возвращает `true`, если массив содержит элемент `e`
    `Array.prototype.slice(i, j)` - возвращает новый массив, который является срезом исходного

* мутаторы - изменяют исходный массив

    `Array.prototype.push(e)` - помещает элемент e в конец массива
    `Array.prototype.pop()` - удаляет последний элемент массива
    `Array.prototype.splice(start, deleteCount)` - извлекает срез массива от индекса `start` длиной `deleteCount` без сохранения исходного

* и итераторы - они применяют функцию, переданную в качестве аргумента, на каждом элементе массива для создания нового

    `Array.prototype.map(f)` - применяет функцию `f` на каждом элементе массива и создаёт новый массив с результатом вызова указанной функции
    `Array.prototype.filter(f)` - создаёт новый массив со всеми элементами, прошедшими проверку, задаваемую в функции `f`
    `Array.prototype.forEach(f)` - применяет функцию `f` на каждом элементе массива

Чтобы расширить такой массив, можно добавить новое поле в его прототип:

```js
Array.prototype.partition = function(pred) {
    let passed = []
    let failed = []
    for (let i = 0; i < this.length; i++) {
        if (pred(this[i])) {
            passed.push(this[i])
        } else {
            failed.push(this[i])
        }
    }

    return [passed, failed]
}
```

И тогда его можно будет вызвать из массива:

```js
[1, 2, 3, 4, 5].partition(a => a < 4) // [[1, 2, 3], [4, 5]]
```

Расширять встроенные прототипы (например, `Array.prototype`) в реальных проектах не рекомендуется, так как это может привести к конфликтам

---

Ранее приватных полей в JavaScript не было. Вместо них, как в Python, можно обозначить нижним подчеркиванием спереди:

```js
class User {
    constructor(firstName, lastName, email) {
        this._firstName = firstName
        this._lastName = lastName
        this._email = email
    }
}
```

Однако в новых версиях со стандарта ES2022 появилась возможность определять приватные поля:

```js
class ClassWithPrivate {
    #privateField;
    #privateFieldWithInitializer = 42;

    #privateMethod() {
        // …
    }
}
```

Приватные поля должны иметь уникальное имя внутри класса, а также конструктор нельзя сделать приватным

Также в качестве инкапсуляции может выступать замыкание функции:

```js
function outside() {
    const food = "Hamburger"

    return function inside() {
        console.log(food)
    }
}
```

С замыканием нужно быть осторожным, потому что значение `this` меняется от того, в каком контексте слово было использовано. Значение `this` определяется:

* способом вызова функции
* стрелочная функция не имеет собственного `this`
* `new` создаёт новый контекст
* `call`/`apply`/`bind` явно задают `this`

---

JavaScript позволяет расширять функциональность методов родителей:

```js
class Developer extends Human {
    sayHello() {
        // Вызываем родительский метод
        super.sayHello()

        // Создаем новый метод
        console.log(`I'm a developer`)
    }
}

const chris = new Developer('Walter', 'White')
chris.sayHello()
```

Вместо наследования можно применить функциональную композицию:

```js
function Developer (firstName, lastName) {
    const human = Human(firstName, lastName)

    return Object.assign({}, human, {
        sayHello() {
            // Вызываем родительский метод
            human.sayHello()

            // Создаем новый метод
            console.log(`I'm a developer`)
        }
    })
}

const chris = new Developer('Walter', 'White')
chris.sayHello()
```
