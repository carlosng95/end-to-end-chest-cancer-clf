# ─────────────────────────────────────────
# Stage 1: builder — instala dependencias
# ─────────────────────────────────────────
FROM python:3.8-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /install

# Copiamos primero requirements para aprovechar cache si no cambian deps
COPY requirements.txt .

# Copiamos también los archivos del proyecto porque requirements tiene -e .
COPY setup.py .
COPY pyproject.toml* ./
COPY README.md* ./
COPY cnnClassifier ./cnnClassifier
COPY app.py .
COPY config ./config
COPY templates ./templates
COPY main.py .

RUN pip install --prefix=/dependencies --no-cache-dir -r requirements.txt


# ─────────────────────────────────────────
# Stage 2: runtime — imagen final limpia
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

# Traer dependencias instaladas desde builder
COPY --from=builder /dependencies /usr/local

# Copiar el proyecto completo para ejecución
COPY . /app

EXPOSE 8080

CMD ["python", "app.py"]