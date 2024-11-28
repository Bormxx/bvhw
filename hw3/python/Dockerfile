# установка базового образа (host OS)
FROM python:3.8

# установка рабочей директории в контейнере
WORKDIR /code

# копирование файла зависимостей в рабочую директорию
COPY ./python/requirements.txt .

# установка зависимостей
RUN pip install -r requirements.txt

# копирование содержимого локальной директории src в рабочую директорию
COPY ./python/src/* .

# команда, выполняемая при запуске контейнера
CMD [ "python", "server.py" ]
