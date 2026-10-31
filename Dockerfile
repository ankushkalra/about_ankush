FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_CREATE=false

WORKDIR /app

#Install poetry
RUN pip install --no-cache-dir poetry==2.2.1

COPY pyproject.toml poetry.lock ./
RUN poetry install --only main --no-root

COPY src/ ./src

ENV PYTHONPATH=/app/src

CMD ["uvicorn", "about_ankush.main:app", "--host", "0.0.0.0", "--port", "8000"]


