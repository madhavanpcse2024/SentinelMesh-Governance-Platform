FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app
COPY gcp/sentinelmesh/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY gcp/sentinelmesh/main.py gcp/sentinelmesh/policy.py gcp/sentinelmesh/seed_firestore.py ./
COPY artifacts/sentinelmesh/dist/public ./static

CMD exec uvicorn main:app --host 0.0.0.0 --port ${PORT}