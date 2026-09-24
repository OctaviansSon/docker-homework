# ---- Base image ----
# Slim variant keeps the image small compared to the full python image
FROM python:3.12-slim AS base

# Prevents Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# ---- Dependency layer ----
# Copy only the requirements file first so Docker can cache this layer
# and skip reinstalling dependencies when only app code changes
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Application layer ----
COPY app/ .

# Create a non-root user and switch to it (basic security practice)
RUN useradd --create-home appuser
USER appuser

# Configurable environment variables (defaults; can be overridden at `docker run`)
ENV APP_ENV=production \
    APP_MESSAGE="Hello from inside a Docker container!" \
    PORT=5000

EXPOSE 5000

# Basic container-level health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

# Use gunicorn for a production-grade WSGI server instead of Flask's dev server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
