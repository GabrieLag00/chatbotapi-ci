# Imagen base
FROM python:3.11-slim

# Crear directorio de trabajo
WORKDIR /app

# Copiar requirements e instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el archivo .env
COPY .env .env

# Copiar el resto del código
COPY . .

# Exponer el puerto
EXPOSE 8000

# Comando de arranque
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]