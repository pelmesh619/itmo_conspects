## Лекция 5. Инфраструктура как код. Ansible

Подход "инфраструктура как код" (Infrastructure as Code, IaC) состоит в создании, настройке и управлении инфраструктурой с помощью кода и конфигурационных файлов вместо ручной работы в интерфейсах или на серверах

Как правило, первоначальная настройка сервера заключается в трех этапах:

1. Установка нужных библиотек, пакетов, сред окружения и другого ПО
2. Настройка файловой структуры для нужного приложения
3. Добавление пользователей, групп и разрешений

При увеличении числа серверных узлов и виртуальных машин, которые на них запущены, появился подход "инфраструктура как код", который автоматизирует процесс первоначальной настройки путем описания нужных действий

В подходе "инфраструктура как код" выделяют два способа описания:

* Декларативный, то есть описание желаемого конечного состояния, из которого инструмент сам определяет шаги для его достижения. Такой подход используется в инструменте Terraform
* Императивный, то есть описание последовательности команд и действий, которые нужно выполнить для настройки системы. Такой подход используется в инструменте Ansible

Одним из популярных инструментов для автоматизации настройки является Ansible. Ansible работает со сценариями (или плейбуками, от playbook), которые написаны на языке YAML. Далее управляющий сервер (control node) под управлением Ansible подключается через утилиту SSH (от Secure SHell) и настраивает другие сервера, которые называются управляемыми (managed node). Ansible использует язык программирования Python, поэтому он должен быть установлен на управляющем и управляемых серверах

Управляемые сервера описаны в файле инвентаря `inventory.ini` таким образом:

```ini
[app]
app-vm ansible_host=192.168.100.10
app-2-vm ansible_host=192.168.100.11

[registry]
registry-vm ansible_connection=local

[all:vars]
ansible_user=ansible
ansible_python_interpreter=/usr/bin/python3
```

Сервер имеет имя и IP-адрес или DNS-имя. Если управляемый сервер является управляющим, то можно просто указать тип подключения `ansible_connection=local`. Сервера можно объединять в группы, например, по функционалу (разделение серверов на тестовые и на промышленные), по системе (в одной группе сервера на Ubuntu, а в другой - Debian) или по другому признаку

Сценарий выглядит так:

```yml
---
- name: Веб-сервер
  hosts: app
  become: true
  vars:
    app_dir: /var/www/myapp

  tasks:
    - name: Установка nginx и ufw
      ansible.builtin.apt:
        name: [nginx, ufw]
        state: present
        update_cache: true

    - name: Создание директории приложения
      ansible.builtin.file:
        path: "{{ app_dir }}"
        state: directory
        mode: "0755"

    - name: Развертывание конфига Nginx
      ansible.builtin.template:
        src: nginx-site.conf.j2
        dest: /etc/nginx/sites-available/myapp.conf
      notify: reload nginx

    - name: Включение сайта
      ansible.builtin.file:
        src: /etc/nginx/sites-available/myapp.conf
        dest: /etc/nginx/sites-enabled/myapp.conf
        state: link
      notify: reload nginx

    - name: Открытие порта 80
      community.general.ufw:
        rule: allow
        port: "80"
        proto: tcp

    - name: Открытие порта 22
      community.general.ufw:
        rule: allow
        port: "22"
        proto: tcp

    - name: Включение файрвола
      community.general.ufw:
        state: enabled
        policy: deny
        direction: incoming

  handlers:
    - name: reload nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded
```

Сам сценарий хранится в файле и состоит из списка задач

Одна задача сценария состоит из названия и имени модуля. Модуль может быть встроенным (например, `ansible.builtin.apt`), а может быть пользовательским (например, специально написанным для проекта или установленным). Для работы сценария можно задать переменные (например, пароль для пользователя базы данных)

Переменные в сценарии указываются в двойных фигурных скобках (например, `{{ app_dir }}`). Переменные можно указать через директиву `vars`:

```yml
  vars:
    app_dir: /var/www/myapp
```

Либо указать файлы с переменными через `vars_files`:

```yml
  vars_files:
    - vars/common.yml
    - vars/secrets.yml
```

Здесь в этом сценарии применяется пользовательский модуль `community.general.ufw`, который можно установить вместе с коллекцией `community.general` с помощью команды:

```bash
ansible-galaxy collection install community.general
```

Корректность синтаксиса сценария можно проверить с помощью команды:

```bash
ansible-playbook playbook.yml --syntax-check
```

---

Для запуска сценария нужно, чтобы на управляемом сервере был установлен интерпретатор Python и SSH-сервер. Также нужно сгенерировать SSH-ключи шифрования для доступа с управляющего сервера. Также пользователь, которым управляет Ansible (его имя указано в `inventory.ini`), должен иметь право на вызов команды `sudo`

Для проверки доступа к управляемым серверам можно использовать команду:

```bash
ansible all -i inventory.ini -m ping
```

Перед применением сценария на реальных серверах можно сделать пробный запуск, который покажет, что изменится. Для этого используются два флага:

* `--check` или `-C` - режим проверки, в котором Ansible проходит по задачам и сообщает, какие из них изменили бы систему, но без прямого применения изменений
* `--diff` или `-D` показывают, как именно изменятся файлы

Флаги можно использовать по отдельности, но чаще их указывают вместе:

```bash
ansible-playbook -i inventory.ini playbook.yml --check --diff
```

Далее сценарий можно запустить так:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

Аргументом `-i` указан файл инвентаря

Большинство задач в Ansible являются идемпотентными, то есть повторное применение не изменит систему

---

В проекте файлы, относящиеся к Ansible, хранят в папке `ansible` в корне проекта. Сама структура каталога выглядит так:

```text
ansible/
├── ansible.cfg                # настройки проекта
├── inventory/
│   ├── hosts.ini              # список серверов и групп
│   ├── group_vars/
│   │   ├── all.yml            # переменные для всех хостов
│   │   ├── app.yml            # переменные для группы app
│   │   └── registry.yml       # переменные для группы registry
│   └── host_vars/
│       └── app-vm.yml         # переменные для конкретного хоста
├── playbooks/
│   ├── site.yml               # главный плейбук, который подключает остальные
│   ├── app.yml                # плейбук для группы app
│   └── registry.yml           # плейбук для группы registry
├── roles/
│   └── nginx/
│       ├── tasks/
│       │   └── main.yml       # задачи роли (точка входа)
│       ├── handlers/
│       │   └── main.yml       # обработчики
│       ├── templates/
│       │   └── nginx-site.conf.j2   # шаблоны Jinja2
│       ├── files/             # статичные файлы
│       ├── vars/
│       │   └── main.yml       # переменные с высоким приоритетом
│       ├── defaults/
│       │   └── main.yml       # значения по умолчанию
│       └── meta/
│           └── main.yml       # зависимости и информация о роли
├── collections/
│   └── requirements.yml       # нужные модули
```

*   `ansible.cfg` содержит конфигурацию для Ansible и может выглядеть так:

    ```ini
    [defaults]
    inventory = inventory/hosts.ini
    roles_path = roles
    ```

    Здесь указан файл инвентаря, что позволяет не указывать его в командах

* В каталогах `inventory/group_vars` хранятся файлы с переменными для конкретной группы, а в `inventory/host_vars` переменные для конкретного хоста
*   `playbooks/site.yml` является основным сценарием и импортирует другие сценарии:

    ```yml
    ---
    - import_playbook: app.yml
    - import_playbook: registry.yml
    ```

*   `collections/requirements.yml` хранит нужные модули, например:

    ```yml
    ---
    collections:
    - name: community.general
    ```

    Далее их можно установить с помощью команды:

    ```bash
    ansible-galaxy collection install -r collections/requirements.yml
    ```

*   `roles` описывает роли - структуры каталогов, которые объединяют задачи, переменные и модули. Тогда сценарий упрощается до такого:

    ```yml
    ---
    - name: Настройка веб-сервера
    hosts: app
    become: true
    roles:
      - nginx # имя роли
    ```

---

Также Ansible предоставляет инструмент Ansible Vault для управления и шифрования паролей и другой конфиденциальной информации. Основные команды

*   Создание нового зашифрованного файла. Открывает текстовый редактор после запроса пароля:

    ```bash
    ansible-vault create secrets.yml
    ```

*   Шифрование существующего файла:

    ```bash
    ansible-vault encrypt vars.yml
    ```

*   Редактирование зашифрованного файла. Для редактирования Ansible Vault расшифровывает содержимое во временный файл, открывает редактор и заново шифрует при сохранении:

    ```bash
    ansible-vault edit secrets.yml
    ```

*   Просмотр содержимого без редактирования:

    ```bash
    ansible-vault view secrets.yml
    ```

*   Смена пароля, для этого Ansible Vault перешифровывает файл с новым ключом:

    ```bash
    ansible-vault rekey secrets.yml
    ```

*   Полная расшифровка файла:

    ```bash
    ansible-vault decrypt secrets.yml
    ```

Чтобы Ansible смог расшифровать данные во время выполнения сценария, необходимо передать пароль одним из способов:

1.  Интерактивный ввод пароля:

    ```bash
    ansible-playbook playbook.yml --ask-vault-pass
    ```

2.  Использование файла с паролем:

    ```bash
    ansible-playbook playbook.yml --vault-password-file ~/.vault_pass.txt
    ```

3.  Использование нескольких паролей, что позволяет разделять доступ (например, разные пароли для разных сред):

    ```bash
    ansible-playbook playbook.yml --vault-id dev@prompt --vault-id prod@~/.prod_pass.txt
    ```
