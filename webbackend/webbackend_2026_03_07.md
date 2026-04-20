## Лекция 5. Бэкенд для фронтенда

Простейшая архитектура веб-приложения часто выглядит так: есть сервер, который отдает готовые HTML-страницы, и есть дополнительные сервисы, например база данных, очередь сообщений, внешние API и файловое хранилище

Такой подход работает, но со временем у него появляются ограничения:

* Один и тот же сервер одновременно отвечает и за бизнес-логику, и за представление данных
* Потребности веб-клиента, мобильного клиента и других интерфейсов начинают смешиваться
* Сервер часто превращается в промежуточный слой, который просто собирает данные из других сервисов
* Фронтенду бывает неудобно получать данные в нужной форме

Но можно внести ряд улучшений:

1. Заменить JSON на GraphQL. Таким образом, мы убираем лишнюю логику, отвечающую за представление данных, а клиенты могут выбирать, какие именно данные им нужны
2. Вынести рендеринг HTML-документов на отдельный сервер, который будет обращаться за данными к бэкенд-серверу
3. Разбить бэкенд на множество микросервисов

В итоге получаем, что в каждом сервисе нет зависимости от языка и от фреймворка, а бэкенд-разработчик не взаимодействует с сервисами, которые ему не требуются

Так появляется архитектурный паттерн "бэкенд для фронтенда" - в нем для каждого уникального фронтенда есть свой бэкенд. Этот бэкенд будет заниматься:

* аутентификацией и авторизацией
* валидацией входных данных
* агрегацией данных из нескольких сервисов
* преобразованием ответа в удобный для клиента формат
* кэшированием
* логированием и трассировкой запросов

Серверный фреймворк Nest для Node.js отлично подходит для этой задачи. Его архитектура включает:

* модули
* контроллеры и сервисы
* контейнер внедрения зависимостей
* промежуточное ПО (middleware), пайпы, охраняющие декораторы (guard), интерцепторы и фильтры
* интеграция с OpenAPI (то есть возможность сгенерировать готовую документацию для Swagger), WebSocket, GraphQL, микросервисами
* удобная структура для тестирования

Также Nest концептуально похож на Angular:

* используется модульность
* активно применяются декораторы
* есть внедрение зависимостей

### Базовые элементы Nest

Архитектура Nest строится вокруг модулей. Модуль объединяет связанные части приложения:

* контроллеры
* сервисы
* другие провайдеры

Контроллер принимает HTTP-запрос и возвращает ответ. В нем не стоит хранить сложную бизнес-логику: обычно он лишь принимает параметры, вызывает сервис и возвращает результат.

```ts
import { Controller, Get, Param, ParseIntPipe } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.usersService.findOne(id);
  }
}
```

Здесь:

* `@Controller('users')` задает базовый путь
* `@Get(':id')` связывает метод с `GET /users/:id`
* `ParseIntPipe` преобразует параметр строки в число и выбросит ошибку, если преобразование невозможно

---

Сервис обычно содержит прикладную или бизнес-логику:

```ts
import { Injectable, NotFoundException } from '@nestjs/common';

@Injectable()
export class UsersService {
  private readonly users = [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' },
  ];

  findOne(id: number) {
    const user = this.users.find((item) => item.id === id);

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    return user;
  }
}
```

`@Injectable()` означает, что класс можно зарегистрировать в контейнере зависимостей и внедрять в другие классы

---

Модуль описывает, какие контроллеры и провайдеры относятся к одной области приложения.

```ts
import { Module } from '@nestjs/common';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

@Module({
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
```

---

Запуск HTTP-приложения обычно происходит в `main.ts`:

```ts
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  await app.listen(3000);
}

bootstrap();
```

Глобальный `ValidationPipe` здесь:

* удаляет лишние поля (`whitelist`)
* преобразует типы на основе DTO (`transform`)

---

Одна из ключевых идей Nest - внедрение зависимостей. Если сервису нужен другой сервис, его можно не создать вручную, а получить от контейнера:

```ts
constructor(private readonly usersService: UsersService) {}
```

Плюсы такого подхода:

* код слабее связан
* классы проще тестировать
* зависимости удобно подменять

В Nest зависимости обычно называются провайдерами

---

Для описания входных данных обычно используют DTO (Data Transfer Object)

```ts
import { IsEmail, IsString, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(2)
  name: string;
}
```

Использование в контроллере:

```ts
import { Body, Controller, Post } from '@nestjs/common';

@Controller('users')
export class UsersController {
  @Post()
  create(@Body() dto: CreateUserDto) {
    return dto;
  }
}
```

Валидация в Nest обычно строится так:

* декораторы из `class-validator` описывают правила
* `ValidationPipe` запускает проверку и преобразование

Пайпы в Nest - это специальные классы, которые могут:

* валидировать данные
* преобразовывать данные
* отклонять некорректный запрос до входа в метод контроллера

Примеры встроенных pipe: `ValidationPipe`, `ParseIntPipe`, `ParseBoolPipe`, `ParseUUIDPipe`

### Продвинутые элементы Nest

Охраняющие декораторы (или гуарды, от guard) проверяют, можно ли вообще выполнять обработчик запроса

Типичный пример - это проверка JWT (JSON Web Token) для авторизации и ролей пользователя

```ts
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';

@Injectable()
export class AuthGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    return Boolean(request.headers.authorization);
  }
}
```

Использование:

```ts
@UseGuards(AuthGuard)
@Get('profile')
getProfile() {
  return { ok: true };
}
```

---

Интерцептор оборачивает вызов обработчика. Он может:

* логировать время выполнения
* менять формат ответа
* добавлять кэширование
* работать с потоками данных через `Observable`

```ts
import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { map, Observable } from 'rxjs';

@Injectable()
export class ResponseInterceptor implements NestInterceptor {
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<unknown> {
    return next.handle().pipe(
      map((data) => ({
        data,
        timestamp: new Date().toISOString(),
      })),
    );
  }
}
```

---

Фильтры перехватывают исключения и преобразуют их в HTTP-ответ:

```ts
import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
} from '@nestjs/common';

@Catch(HttpException)
export class HttpErrorFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const response = host.switchToHttp().getResponse();
    const status = exception.getStatus();

    response.status(status).json({
      statusCode: status,
      message: exception.message,
    });
  }
}
```

Это полезно, например, для создания шаблонных страниц с ошибками, такими как HTTP 404

---

Промежуточное ПО (Middleware) выполняется раньше, чем гуарды и контроллер. Он удобен для:

* логирования
* добавления данных в объект запроса
* общих сквозных действий

```ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { NextFunction, Request, Response } from 'express';

@Injectable()
export class LoggerMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    console.log(`${req.method} ${req.originalUrl}`);
    next();
  }
}
```

---

Nest хорошо интегрируется с ORM и драйверами баз данных. Часто используют библиотеки:

* TypeORM
* Prisma
* Sequelize
* Mongoose для MongoDB

Для этого реализуют репозиторий - абстракцию доступа к данным. Репозиторий скрывает детали хранения и предоставляет понятный интерфейс для предметной области. Например:

```ts
interface UsersRepository {
  findById(id: number): Promise<User | null>;
  save(user: User): Promise<void>;
}
```

При работе с базой данных часто различают два подхода:

* Сначала код (Code first) - сначала описываются сущности и модели в коде, затем по ним создается схема БД
* Сначала база данных (Database first) - сначала существует схема базы данных, а код и модели подстраиваются под нее

Nest поддерживает оба подхода через выбранный инструмент доступа к данным

---

Кэширование в бэкенде для фронтенда особенно полезно, если один и тот же клиент часто запрашивает одинаковые агрегированные данные. В Nest кэширование можно подключать через менеджер кэширования, а в качестве внешнего хранилища часто используют Redis

Redis полезен, когда нужно:

* хранить кэш между несколькими экземплярами приложения
* быстро читать часто используемые данные
* задавать время жизни для автоматического истечения кэша

---

Для документирования HTTP API в Nest часто используют Swagger-модуль, который строит OpenAPI-описание

Пример настройки:

```ts
import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('Users API')
    .setDescription('Документация сервиса пользователей')
    .setVersion('1.0')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(3000);
}

bootstrap();
```

Для описания DTO используют декораторы:

```ts
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ example: 'user@example.com' })
  email: string;
}
```

---

В Nest можно создавать свои декораторы, чтобы повторно использовать типичную логику. Например, чтобы получать текущего пользователя из запроса:

```ts
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);
```

Использование:

```ts
@Get('me')
getMe(@CurrentUser() user: User) {
  return user;
}
```

---

На практике Nest часто используется как API-слой для фронтенда. Он может:

* отдавать REST API
* отдавать GraphQL API
* агрегировать ответы нескольких внутренних сервисов
* выполнять серверную валидацию
* обеспечивать авторизацию

Для фронтенда это удобно, потому что:

* клиент получает данные в ожидаемом формате
* чувствительная логика не уходит в браузер
* меняется внутреннее устройство сервисов, но контракт BFF можно сохранить стабильным
