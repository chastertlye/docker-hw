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
set -a
source .env
set +a
docker compose up -d --build --quiet-build --wait; echo
curl -s "http://127.0.0.1:${PORT}/"; echo
curl -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
docker compose down; echo
docker compose up -d --build --quiet-build --wait; echo
curl -s -X POST "http://127.0.0.1:${PORT}/increment"; echo
docker compose down -v
```

Вывод корректен. Счетчик растет при POST запросах, порт и приветствие берется из .env (на гитхаб присутствует только .env.example)

```bash
[+] Building 0.0s (0/0)                                                                                                                                                                                                               
[+] up 4/4
 ✔ Image docker-hw-app       Built                                                                                                                                                                                                0.9s
 ✔ Network docker-hw_default Created                                                                                                                                                                                              0.0s
 ✔ Volume docker-hw_dataset  Created                                                                                                                                                                                              0.0s
 ✔ Container docker-hw-app-1 Healthy                                                                                                                                                                                              0.9s

{"greeting": "hello world", "count": 0, "hostname": "a6f112852f2b", "storage": "sqlite"}
{"greeting": "hello world", "count": 1, "hostname": "a6f112852f2b", "storage": "sqlite"}
[+] down 2/2
 ✔ Container docker-hw-app-1 Removed                                                                                                                                                                                             10.3s
 ✔ Network docker-hw_default Removed                                                                                                                                                                                              0.2s

[+] Building 0.0s (0/0)                                                                                                                                                                                                               
[+] up 3/3
 ✔ Image docker-hw-app       Built                                                                                                                                                                                                0.9s
 ✔ Network docker-hw_default Created                                                                                                                                                                                              0.0s
 ✔ Container docker-hw-app-1 Healthy                                                                                                                                                                                              0.9s

{"greeting": "hello world", "count": 2, "hostname": "33e503fa313a", "storage": "sqlite"}
[+] down 3/3
 ✔ Container docker-hw-app-1 Removed                                                                                                                                                                                             10.4s
 ✔ Network docker-hw_default Removed                                                                                                                                                                                              0.2s
 ✔ Volume docker-hw_dataset  Removed                                                                                                                                                                                              0.0s     
```