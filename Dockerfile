FROM python:3.13-slim
COPY app/ app/
RUN pip install -r /app/requirements.txt
CMD ["python", "app/app.py"]
