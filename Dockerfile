# ─────────────────────────────────────────
# Stage 1: builder — instala dependencias
# ─────────────────────────────────────────
FROM python:3.8-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /install

# Copiar SOLO requirements primero → esta capa se cachea
# mientras requirements.txt no cambie
COPY requirements.txt .

RUN pip install --prefix=/dependencies --no-cache-dir -r requirements.txt


# ─────────────────────────────────────────
# Stage 2: runtime — imagen final limpia
# ─────────────────────────────────────────
FROM python:3.8-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    awscli \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Traer solo los paquetes instalados del stage anterior
COPY --from=builder /dependencies /usr/local

# Copiar el código fuente al final → cambios en código
# no invalidan la capa de dependencias
COPY . /app

CMD ["python3", "app.py"]