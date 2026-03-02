# Fase 1: Build dell'ambiente
FROM python:3.13 AS deps

# Installa SWI-Prolog
RUN apt-get update && apt-get install -y --no-install-recommends swi-prolog

# --- Installa le dipendenze Python ---
WORKDIR /dalia
COPY ./requirements.txt /dalia/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get install -y --no-install-recommends net-tools && apt-get clean && rm -rf /var/lib/apt/lists/*

# Fase 2: Immagine finale
FROM deps
WORKDIR /dalia
COPY ./ /dalia

CMD ["python", "main.py"]