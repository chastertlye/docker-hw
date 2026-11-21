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
curl http://127.0.0.1:8080/
curl -X POST http://127.0.0.1:8080/increment
curl -X POST http://127.0.0.1:8080/increment
curl http://127.0.0.1:8080/
docker logs score4 > logs.txt 2>&1
docker stop score4
```

Вывод команд корректен. Счетчик растет при POST запросах

```bash
{"greeting": "hello world", "count": 0, "hostname": "8a9f0cd9d265", "storage": "sqlite"}
{"greeting": "hello world", "count": 1, "hostname": "8a9f0cd9d265", "storage": "sqlite"}
{"greeting":"hello world", "count": 2, "hostname": "8a9f0cd9d265", "storage": "sqlite"}
{"greeting": "hello world", "count": 2, "hostname": "8a9f0cd9d265", "storage": "sqlite"}
```
Файл с логами находится в главном каталоге. Его содержимое:
```log
2026-11-21 17:03:46,664 listening port=8000 storage=sqlite
2026-11-21 17:03:50,424 http 172.17.0.1 "GET / HTTP/1.1" 200 -
2026-11-21 17:03:50,442 http 172.17.0.1 "POST /increment HTTP/1.1" 200 -
2026-11-21 17:03:50,461 http 172.17.0.1 "POST /increment HTTP/1.1" 200 -
2026-11-21 17:03:50,467 http 172.17.0.1 "GET / HTTP/1.1" 200 -
```
