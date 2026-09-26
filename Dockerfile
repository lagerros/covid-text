FROM python:3.12-slim AS production
ENV PYTHONUNBUFFERED=1

WORKDIR /usr/app

# Poetry lives in its own venv so its dependencies never mix with the app's.
RUN python -m venv /opt/poetry && \
    /opt/poetry/bin/pip install --no-cache-dir poetry && \
    ln -s /opt/poetry/bin/poetry /usr/local/bin/poetry

COPY pyproject.toml poetry.lock ./

# TODO: split into multiple Dockerfiles and add proper entrypoints
COPY ./src ./src/

RUN poetry config virtualenvs.create false && \
    poetry install --only main

FROM production AS development
RUN poetry install
