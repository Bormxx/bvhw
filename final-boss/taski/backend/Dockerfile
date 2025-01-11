FROM python:3.10 AS builder
FROM python:3.10-alpine
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt --no-cache-dir
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
RUN python manage.py migrate
EXPOSE 8000