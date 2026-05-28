## Лекция 4. Общение по протоколам HTTP и WebSocket в Boost

Boost.Beast - это надстройка над Boost.Asio, предоставляющая готовую реализацию HTTP и WebSocket. Классы для работы с HTTP находятся в пространстве имён `boost::beast::http`, а для веб-сокетов - в `boost::beast::ws`. Это позволяет быстро создавать сетевые приложения, работающие по этим протоколам, не изобретая разбор заголовков и рукопожатий вручную

* HTTP в `boost::beast::http` умеет формировать запросы и ответы, парсить их, обрабатывать поля заголовков. Можно использовать синхронный и асинхронный ввод-вывод
* WebSocket в `boost::beast::ws` даёт класс `stream`, который после выполнения обновления протокола позволяет отправлять и принимать текстовые и бинарные кадры в режиме полного дуплекса

Пример простого HTTP-клиента, который отправляет GET-запрос и выводит тело ответа:

```cpp
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <iostream>
#include <string>

namespace beast = boost::beast;
namespace http = beast::http;
namespace net = boost::asio;
using tcp = net::ip::tcp;

int main() {
    net::io_context io;
    tcp::resolver resolver(io);
    beast::tcp_stream stream(io);
    auto const results = resolver.resolve("example.com", "80");
    stream.connect(results);

    http::request<http::string_body> req{http::verb::get, "/", 11};
    req.set(http::field::host, "example.com");
    req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);
    http::write(stream, req);

    beast::flat_buffer buffer;
    http::response<http::dynamic_body> res;
    http::read(stream, buffer, res);
    std::cout << res << std::endl;

    beast::error_code ec;
    stream.socket().shutdown(tcp::socket::shutdown_both, ec);
    return 0;
}
```

Пример WebSocket-клиента, который подключается к серверу, отправляет сообщение и читает ответ:

```cpp
#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <iostream>

namespace beast = boost::beast;
namespace ws = beast::websocket;
namespace net = boost::asio;
using tcp = net::ip::tcp;

int main() {
    net::io_context io;
    tcp::resolver resolver(io);
    ws::stream<tcp::socket> ws(io);
    auto const results = resolver.resolve("echo.websocket.org", "80");
    net::connect(ws.next_layer(), results);
    ws.handshake("echo.websocket.org", "/");
    ws.write(net::buffer(std::string("Hello, WebSocket!")));
    beast::flat_buffer buffer;
    ws.read(buffer);
    std::cout << beast::make_printable(buffer.data()) << std::endl;
    ws.close(ws::close_code::normal);
    return 0;
}
```

Для кастомных протоколов, где сообщения не оформлены как HTTP или WebSocket, часто используют разделители (например, конец строки `\n` или специальная последовательность байт). Здесь помогает свободная функция `boost::asio::read_until`. Она читает данные из потока до тех пор, пока во входном буфере не встретится заданный разделитель. Это удобно для текстовых протоколов или бинарных фреймов с известной сигнатурой конца. После завершения операции можно обработать полученные данные

Пример сервера, читающего из сокета строки, разделённые символом перевода строки:

```cpp
#include <boost/asio.hpp>
#include <iostream>

using namespace boost::asio;
using ip::tcp;

int main() {
    io_context io;
    tcp::acceptor acceptor(io, tcp::endpoint(tcp::v4(), 12345));
    tcp::socket socket(io);
    acceptor.accept(socket);

    streambuf buf;
    // читаем до '\n' включительно
    read_until(socket, buf, '\n');
    std::istream is(&buf);
    std::string line;
    std::getline(is, line);
    std::cout << "Received: " << line << std::endl;
    return 0;
}
```

### Таймеры в Boost

Кроме сетевых операций, Boost.Asio предоставляет таймеры для отсроченных действий. Есть два основных типа:

* `boost::asio::steady_timer` - таймер на основе монотонных часов, которые не подвержены ручному переводу системного времени. Рекомендуется для измерения временных интервалов
* `boost::asio::system_timer` - таймер на основе системного времени. Его показания могут скакать при переводе часов или переходе на летнее/зимнее время

У обоих классов схожий набор методов:

* `wait` - синхронно блокирует выполнение до истечения заданного времени
* `async_wait` - асинхронное ожидание; принимает обработчик, который будет вызван, когда таймер сработает
* `expires_from_now` - устанавливает таймер на срабатывание через указанную длительность относительно текущего момента
* `expires_at` - задаёт абсолютное время срабатывания (например, конкретную временную точку)
* `cancel` - отменяет все ожидающие асинхронные операции таймера; обработчики `async_wait` будут вызваны с кодом ошибки `operation_aborted`

Пример использования `steady_timer` с синхронным ожиданием:

```cpp
#include <boost/asio.hpp>
#include <iostream>

using namespace boost::asio;

int main() {
    io_context io;
    steady_timer timer(io, chrono::seconds(3));
    std::cout << "Waiting 3 seconds...\n";
    timer.wait();  // блокировка на 3 секунды
    std::cout << "Done.\n";
    return 0;
}
```

Пример асинхронного таймера с `async_wait`:

```cpp
#include <boost/asio.hpp>
#include <iostream>

using namespace boost::asio;

int main() {
    io_context io;
    steady_timer timer(io, chrono::seconds(2));
    timer.async_wait([](boost::system::error_code ec) {
        if (!ec)
            std::cout << "Timer expired!\n";
        else
            std::cout << "Timer cancelled.\n";
    });
    std::cout << "Starting async wait...\n";
    io.run();  // цикл обработки событий
    return 0;
}
```

Установка таймера через `expires_from_now` и его последующая отмена:

```cpp
#include <boost/asio.hpp>
#include <iostream>

using namespace boost::asio;

int main() {
    io_context io;
    steady_timer timer(io);
    timer.expires_from_now(chrono::seconds(5));
    timer.async_wait([](boost::system::error_code ec) {
        if (ec == error::operation_aborted)
            std::cout << "Cancelled.\n";
    });
    // через какое-то время решаем отменить
    timer.cancel();
    io.run();
    return 0;
}
```

Использование `expires_at` для задания абсолютного времени срабатывания:

```cpp
#include <boost/asio.hpp>
#include <iostream>

using namespace boost::asio;

int main() {
    io_context io;
    system_timer timer(io);
    // сработает через 1 час от текущего системного времени
    timer.expires_at(chrono::system_clock::now() + chrono::hours(1));
    timer.wait();
    std::cout << "One hour passed (or system time changed).\n";
    return 0;
}
```
