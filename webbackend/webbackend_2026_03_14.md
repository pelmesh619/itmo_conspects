## Лекция 6. GraphQL и Prisma

### Prisma

Prisma - объектно-реляционное отображение (Object Relational Mapping, ORM) с открытым исходным кодом для экосистемы Node.js и TypeScript

Prisma состоит из следующих компонентов:

* Prisma Client - автогенерируемый клиент базы данных
* Prisma Migrate - декларативное моделирование данных и миграций с возможностью пользовательского редактирования
* Prisma Studio - пользовательский интерфейс для просмотра и редактирования данных

Prisma упрощает работу с базой данных, а именно моделированием данных, миграцией и написанием запросов

Моделирование данных указывается в файле с расширением `.prisma`:

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id Int @id @default(autoincrement()) @id @default(autoincrement())
  email String @unique
  name String?
  createdAt DateTime? @default(now()) @map("created_at")
  posts Post[]
@@map("users")
}

model Post {
  id Int @id @default(autoincrement()) @id @default(autoincrement())
  title String
  content String?
  user User @relation(fields: [authorId], references: [id])
  authorId Int? @map("author_id")
  published Boolean? @default(false)
  createdAt DateTime? @default(now()) @map("created_at")
@@map("posts")
}
```

Каждая из этих моделей описывает таблицу в соответствующей базе данных и служит основой для сгенерированного доступа к данным с интерфейсом, который предоставляет Prisma Client

Далее Prisma Migrate преобразует эту схему в SQL-запросы, необходимые для создания и изменения таблиц в базе данных. Чтобы сделать миграцию на базе данных, нужно применить команду `npx prisma migrate`

Например, схема выше превратится в такие запросы на диалекте PostgreSQL:

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  content TEXT,
  author_id INTEGER REFERENCES users(id),
  published BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);
```

Основным преимуществом работы с Prisma Client является то, что он позволяет разработчикам мыслить объектами и поэтому предлагает привычный и естественный способ рассуждать о своих данных. Prisma Client помогает сформировать запросы к базе данных, которые всегда возвращают простые объекты JavaScript

Помимо этого, если использовать TypeScript, результаты запросов получаются типизированными, что повышает типобезопасность

Отдельное приложение Prisma Studio позволяет управлять базой данных из интерфейса

### GraphQL

GraphQL - это язык запросов данных, который позволяет клиенту явно указать, какие данные ему нужны, облегчает агрегацию данных и использует систему типов для описания данных

GraphQL был создан в Facebook в 2012 году и был публично выпущен в 2015. Его основная цель - решить проблемы и ограничения, связанные с интерфейсами в стиле REST

Допустим, что есть авторская статья и список людей, которые лайкнули ее. До появления GraphQL, чтобы получить этот список, нужно было:

* либо сделать эндпоинт, который вместе со статьей выдавал список лайков - тогда при большом числе лайков приложение может работать медленно
* либо сделать два разных эндпоинта, один из которых выдает информацию о статье без списка лайков, а второй - статью со списком лайков (или отдельно сам список)

Такие проблемы, когда сервис возвращает больше данных, чем клиенту нужно (избыточность или overfetching), и когда клиенту нужно несколько запросов, чтобы получить нужные данные (недостаточность или underfetching), присуще REST API

GraphQL способен по схеме запроса, переданной лишь по одному эндпоинту, понимать, какие данных из каких источников нужно взять, и возвращать их

GraphQL API обычно построен из трех компонентов:

* Запросы

    Запросы позволяют клиенту указать, какие данные ему нужны. Такой запрос передает в теле HTTP-запроса, например:

    ```gql
    query {
      post(id: 1) {
        title
        author {
          name
        }
      }
    }
    ```

    Запросы поддерживают вложенность, массивы, фильтрацию

    ```gql
    query {
      posts(onlyPublished: true) {
        id
        title
        author {
          id
          name
        }
      }
    }
    ```

    А также можно сделать параметры фильтрации динамическими:

    ```gql
    query GetPost($postId: Int!) {
      post(id: $postId) {
        id
        title
        content
      }
    }
    ```

* Распознаватели

    Распознаватели (Resolver) дают понять, откуда брать запрашиваемые запросом данные

    ```ts
    import { Args, Int, Query, Resolver } from '@nestjs/graphql';
    import { PrismaService } from '../prisma/prisma.service';

    @Resolver()
    export class PostsResolver {
        constructor(private readonly prisma: PrismaService) {}

        @Query(() => Post, { nullable: true })
        post(@Args('id', { type: () => Int }) id: number) {
            return this.prisma.post.findUnique({
                where: { id },
                include: {
                    author: true,
                },
            });
        }
    }
    ```
    

* Схема

    Схема описывает, какие типы данных вообще существуют в API, какие поля у них есть и какие запросы доступны клиенту. Пример схемы:

    ```graphql
        type User {
        id: Int!
        email: String!
        name: String
    }

    type Post {
        id: Int!
        title: String!
        content: String
        published: Boolean!
        author: User!
    }

    type Query {
        post(id: Int!): Post
        posts(onlyPublished: Boolean): [Post!]!
    }
    ```

Кроме чтения данных, GraphQL поддерживает изменение данных через мутации. Пример мутации для создания поста:

```gql
mutation {
  createPost(
    title: "Новый пост"
    content: "Текст поста"
    authorId: 1
  ) {
    id
    title
    published
  }
}
```

На практике GraphQL часто используют вместе с Prisma:

* GraphQL отвечает за удобный контракт API для клиента
* Prisma отвечает за удобный и типобезопасный доступ к базе данных
