## Лекция 3. Общение по протоколам TCP и UDP в Boost

Boost.Asio - это библиотека для сетевого и низкоуровневого ввода-вывода, которая позволяет писать и синхронные, и асинхронные программы. Главная идея в том, что все операции (чтение, запись, подключения) можно делать без ожидания завершения, а когда операция завершится - вызывается функция-обработчик. Это позволяет обслуживать тысячи соединений в одном или нескольких потоках

Раньше для имитации постоянного соединения с сервером использовали Long polling. Клиент отправлял HTTP-запрос, сервер не отвечал сразу, а держал соединение открытым до появления новых данных, затем отвечал, и клиент тут же делал новый запрос. Это создавало много накладных расходов: постоянные переподключения, HTTP-заголовки, задержки

Позже появились WebSocket - протокол полного дуплекса (full duplex) поверх TCP. После установки соединения и сервер, и клиент могут отправлять данные в любой момент без дополнительных запросов. Это позволяет делать настоящие приложения: чаты, игры, биржевые котировки. В Boost для работы с WebSocket обычно используют Boost.Beast, который построен на основе Boost.Asio

Пространство имён `boost::asio::ip` содержит классы для работы с адресами и конечными точками (endpoint). Внутри него есть:

* `boost::asio::ip::tcp` - для TCP-соединений: классы `socket`, `acceptor` (для приёма входящих соединений), `resolver` (разрешение имён). TCP гарантирует доставку и порядок данных, но медленнее, чем UDP
* `boost::asio::ip::udp` - для UDP-дейтаграмм: классы `socket`, `endpoint`, `resolver`. UDP не устанавливает соединение, доставка и порядок не гарантируются, зато низкая задержка

Пример простого TCP-клиента, который подключается к серверу и отправляет сообщение:

```cpp
#include <boost/asio.hpp>
#include <iostream>

using namespace boost::asio;
using ip::tcp;

int main() {
    io_context io;
    tcp::socket socket(io);
    tcp::resolver resolver(io);

    // подключаемся к localhost на порт 12345
    connect(socket, resolver.resolve("127.0.0.1", "12345"));
    std::string message = "Hello, Boost!\n";
    write(socket, buffer(message));

    // читаем ответ
    char reply[1024];
    size_t len = socket.read_some(buffer(reply));
    std::cout << "Server replied: ";
    std::cout.write(reply, len);
    std::cout << std::endl;
    return 0;
}
```

Для защищённых соединений используется `boost::asio::ssl`. Это обёртка над OpenSSL (или другой библиотекой), которая позволяет делать рукопожатие TLS/SSL и шифрованный обмен. Контекст `ssl::context` хранит сертификаты и настройки. Поток `ssl::stream` оборачивает TCP-сокет и предоставляет методы `handshake`, `async_handshake`, `write`, `read` для защищённой передачи

Пример простого синхронного SSL-сервера, принимающего одно соединение и читающего данные:

```cpp
#include <boost/asio.hpp>
#include <boost/asio/ssl.hpp>
#include <iostream>

using namespace boost::asio;
using ip::tcp;

int main() {
    io_context io;
    ssl::context ctx(ssl::context::sslv23);
    ctx.set_options(ssl::context::default_workarounds);
    ctx.use_certificate_chain_file("server.crt");
    ctx.use_private_key_file("server.key", ssl::context::pem);

    tcp::acceptor acceptor(io, tcp::endpoint(tcp::v4(), 12345));
    tcp::socket socket(io);
    acceptor.accept(socket);  // ждём подключения

    ssl::stream<tcp::socket> stream(std::move(socket), ctx);
    stream.handshake(ssl::stream_base::server);  // SSL-рукопожатие

    char data[256];
    size_t len = stream.read_some(buffer(data));
    std::cout << "Received: ";
    std::cout.write(data, len);
    std::cout << std::endl;

    stream.shutdown();
    return 0;
}
```

Теперь перейдём к асинхронному серверу. В нём вместо блокирующих операций используются функции, начинающиеся с `async_`, и `io_context.run()` запускает цикл обработки событий. Каждая операция принимает обработчик, который будет вызван после завершения. Это позволяет обрабатывать множество соединений одновременно в одном потоке

Пример асинхронного TCP-сервера, который принимает соединения, читает сообщение и отправляет ответ:

```cpp
#include <boost/asio.hpp>
#include <iostream>
#include <memory>

using namespace boost::asio;
using ip::tcp;

// Класс сессии: владеет сокетом, читает данные, отправляет ответ
class Session : public std::enable_shared_from_this<Session> {
public:
    explicit Session(tcp::socket socket) : socket_(std::move(socket)) {}

    void start() {
        do_read();
    }

private:
    tcp::socket socket_;
    char data_[1024];

    void do_read() {
        auto self(shared_from_this());
        socket_.async_read_some(buffer(data_),
            [this, self](boost::system::error_code ec, size_t length) {
                if (!ec) {
                    // обрабатываем полученные данные и шлём ответ
                    std::string message(data_, length);
                    std::cout << "Received: " << message;
                    std::string reply = "Echo: " + message;
                    async_write(socket_, buffer(reply),
                        [this, self](boost::system::error_code, size_t) {
                            // после ответа закрываем соединение
                            socket_.close();
                        });
                }
            });
    }
};

// Класс сервера: слушает порт и принимает новые соединения
class Server {
public:
    Server(io_context& io, short port)
        : acceptor_(io, tcp::endpoint(tcp::v4(), port)) {
        do_accept();
    }

private:
    tcp::acceptor acceptor_;

    void do_accept() {
        acceptor_.async_accept(
            [this](boost::system::error_code ec, tcp::socket socket) {
                if (!ec) {
                    std::make_shared<Session>(std::move(socket))->start();
                }
                do_accept();  // продолжаем принимать
            });
    }
};

int main() {
    io_context io;
    Server server(io, 12345);
    std::cout << "Async server listening on port 12345\n";
    io.run();  // запуск цикла обработки асинхронных операций
    return 0;
}
```

В этом коде нет блокировок: `acceptor_.async_accept` сразу возвращает управление, и когда приходит новое подключение - вызывается лямбда. Сессия создаётся через `shared_ptr`, чтобы объект жил, пока идёт асинхронная операция. Внутри `do_read` тоже асинхронное чтение, и после чтения асинхронно отправляется ответ. `io_context::run()` крутит цикл событий до тех пор, пока есть незавершённые операции

Такой асинхронный подход лежит в основе масштабируемых сетевых приложений на Boost.Asio, включая WebSocket-серверы через Boost.Beast
