# ─────────────────────────────────────────
# Stage 1: builder
# ─────────────────────────────────────────
FROM python:3.8-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /install

# Copiamos lo necesario para que funcione -e .
COPY requirements.txt .
COPY setup.py .
COPY pyproject.toml* ./
COPY README.md* ./
COPY src ./src
COPY app.py .
COPY config ./config
COPY templates ./templates
COPY main.py .

RUN pip install --prefix=/dependencies --no-cache-dir -r requirements.txt


# ─────────────────────────────────────────
# Stage 2: runtime
# ─────────────────────────────────────────
FROM python:3.8-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    awscli \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /dependencies /usr/local
COPY . /app

EXPOSE 8080

CMD ["python", "app.py"]