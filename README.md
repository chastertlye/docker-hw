## 4 балла

### Сборка

```bash
docker build -t docker-hw .
```

### Запуск

```bash
docker run --rm -d --name score4 -p 8080:8000 -e GREETING='hello world' docker-hw
```

### Проверка работоспособности

```bash
curl -s http://127.0.0.1:8080/;echo
curl -s -X POST http://127.0.0.1:8080/increment;echo
curl -s -X POST http://127.0.0.1:8080/increment;echo
curl -s http://127.0.0.1:8080/;echo
docker logs score4 > logs.txt 2>&1
docker stop score4
```

Вывод команд корректен. Счетчик растет при POST запросах

```bash
{"greeting": "hello world", "count": 0, "hostname": "69a2acabadc1", "storage": "sqlite"}
{"greeting": "hello world", "count": 1, "hostname": "69a2acabadc1", "storage": "sqlite"}
{"greeting": "hello world", "count": 2, "hostname": "69a2acabadc1", "storage": "sqlite"}
{"greeting": "hello world", "count": 2, "hostname": "69a2acabadc1", "storage": "sqlite"}
```
Файл с логами находится в главном каталоге. Его содержимое:
```log
2026-11-21 19:21:39,690 listening port=8000 storage=sqlite
2026-11-21 19:21:43,722 http 172.17.0.1 "GET / HTTP/1.1" 200 -
2026-11-21 19:21:43,740 http 172.17.0.1 "POST /increment HTTP/1.1" 200 -
2026-11-21 19:21:43,757 http 172.17.0.1 "POST /increment HTTP/1.1" 200 -
2026-11-21 19:21:43,763 http 172.17.0.1 "GET / HTTP/1.1" 200 -
```

## 6 баллов

### Проверка работоспособности

```bash
cp .env.example .env
set -a
source .env
set +a
docker compose -f compose.score6.yaml up -d --build --quiet-build --wait; echo
curl -s "http://127.0.0.1:${PORT}/"; echo
curl -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
docker compose -f compose.score6.yaml down; echo
docker compose -f compose.score6.yaml up -d --build --quiet-build --wait; echo
curl -s "http://127.0.0.1:${PORT}"; echo
docker compose -f compose.score6.yaml down -v
```

Вывод корректен. Счетчик растет при POST запросах, порт и приветствие берется из .env (на гитхаб присутствует только .env.example). После остановки и повторного запуска контейнера значение счетчика сохраняется.

```bash
[+] Building 0.0s (0/0)                                                                                                                                                                        
[+] up 4/4
 ✔ Image docker-hw-app       Built                                                                                                                                                         1.0s
 ✔ Network docker-hw_default Created                                                                                                                                                       0.0s
 ✔ Volume docker-hw_dataset  Created                                                                                                                                                       0.0s
 ✔ Container docker-hw-app-1 Healthy                                                                                                                                                       0.9s

{"greeting": "hello world", "count": 0, "hostname": "89efb3a13a81", "storage": "sqlite"}
{"greeting": "hello world", "count": 1, "hostname": "89efb3a13a81", "storage": "sqlite"}
[+] down 2/2
 ✔ Container docker-hw-app-1 Removed                                                                                                                                                      10.4s
 ✔ Network docker-hw_default Removed                                                                                                                                                       0.2s

[+] Building 0.0s (0/0)                                                                                                                                                                        
[+] up 3/3
 ✔ Image docker-hw-app       Built                                                                                                                                                         0.8s
 ✔ Network docker-hw_default Created                                                                                                                                                       0.0s
 ✔ Container docker-hw-app-1 Healthy                                                                                                                                                       0.9s

{"greeting": "hello world", "count": 1, "hostname": "d4b3c125989a", "storage": "sqlite"}
[+] down 3/3
 ✔ Container docker-hw-app-1 Removed                                                                                                                                                      10.4s
 ✔ Network docker-hw_default Removed                                                                                                                                                       0.2s
 ✔ Volume docker-hw_dataset  Removed                                                                                                                                                       0.0s   
```

## 8 баллов

### Проверка работоспособности

```bash
cp .env.example .env
set -a
source .env
set +a
docker compose up -d --build --quiet-build --wait; echo
curl -s "http://127.0.0.1:${PORT}/"; echo
curl -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
curl -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
docker compose down; echo
docker compose up -d --build --quiet-build --wait; echo
curl -s "http://127.0.0.1:${PORT}"; echo
docker compose stop redis; echo
curl -i -s "http://127.0.0.1:${PORT}/healthz"; echo
curl -i -s "http://127.0.0.1:${PORT}/readyz"; echo
curl -i -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
docker compose start redis --wait; echo
curl -s "http://127.0.0.1:${PORT}/"; echo
curl -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
docker compose down -v
```

Приложение работает корректно. Используется база redis. После остановки и повторного запуска контейнера значение счетчика сохраняется. Используем --wait, чтобы дождаться когда сервисы будут Healthy. Healthcheck app происходит через GET /healthz, а Healthcheck redis - через redis-cli ping. После отдельной остановки базы redis, приложение продолжает работать. GET /healthz вернуло 200, а GET /readyz и POST /increment вернули 503. После повторного запуска базы приложение возвращает сохраненное значение счетчика и увеличивает при POST /increment.

```curl
[+] Building 0.0s (0/0)                                                                                                                                                           
[+] up 5/5
 ✔ Image docker-hw-app         Built                                                                                                                                          1.0s
 ✔ Network docker-hw_default   Created                                                                                                                                        0.0s
 ✔ Volume docker-hw_dataset    Created                                                                                                                                        0.0s
 ✔ Container docker-hw-redis-1 Healthy                                                                                                                                        4.0s
 ✔ Container docker-hw-app-1   Healthy                                                                                                                                        4.0s

{"greeting": "hello world", "count": 0, "hostname": "49de212a8cb0", "storage": "redis"}
{"greeting": "hello world", "count": 1, "hostname": "49de212a8cb0", "storage": "redis"}
{"greeting": "hello world", "count": 2, "hostname": "49de212a8cb0", "storage": "redis"}
[+] down 3/3
 ✔ Container docker-hw-redis-1 Removed                                                                                                                                        0.4s
 ✔ Container docker-hw-app-1   Removed                                                                                                                                       10.4s
 ✔ Network docker-hw_default   Removed                                                                                                                                        0.3s

[+] Building 0.0s (0/0)                                                                                                                                                           
[+] up 4/4
 ✔ Image docker-hw-app         Built                                                                                                                                          0.9s
 ✔ Network docker-hw_default   Created                                                                                                                                        0.0s
 ✔ Container docker-hw-redis-1 Healthy                                                                                                                                        4.0s
 ✔ Container docker-hw-app-1   Healthy                                                                                                                                        4.0s

{"greeting": "hello world", "count": 2, "hostname": "a6e708e5a80e", "storage": "redis"}
[+] stop 1/1
 ✔ Container docker-hw-redis-1 Stopped                                                                                                                                        0.3s

HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.18
Date: Sun, 22 Nov 2026 12:22:08 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 19
Cache-Control: no-store

{"status": "alive"}
HTTP/1.0 503 Service Unavailable
Server: BaseHTTP/0.6 Python/3.13.18
Date: Sun, 22 Nov 2026 12:22:12 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 32
Cache-Control: no-store

{"error": "storage_unavailable"}
HTTP/1.0 503 Service Unavailable
Server: BaseHTTP/0.6 Python/3.13.18
Date: Sun, 22 Nov 2026 12:22:16 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 32
Cache-Control: no-store

{"error": "storage_unavailable"}
[+] start 1/1
 ✔ Container docker-hw-redis-1 Healthy                                                                                                                                        3.7s

{"greeting": "hello world", "count": 2, "hostname": "a6e708e5a80e", "storage": "redis"}
{"greeting": "hello world", "count": 3, "hostname": "a6e708e5a80e", "storage": "redis"}
[+] down 4/4
 ✔ Container docker-hw-app-1   Removed                                                                                                                                       10.4s
 ✔ Container docker-hw-redis-1 Removed                                                                                                                                        0.4s
 ✔ Network docker-hw_default   Removed                                                                                                                                        0.2s
 ✔ Volume docker-hw_dataset    Removed                                                                                                                                        0.0s
 ```