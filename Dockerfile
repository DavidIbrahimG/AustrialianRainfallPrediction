FROM python:3.9-slim

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir -r requirements.txt gunicorn

CMD ["gunicorn", "--bind", "0.0.0.0:5001", "--workers", "2", "application:app"]