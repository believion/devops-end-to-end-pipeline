FROM python:3.10-slim

WORKDIR /app

# intall uv
RUN pip install uv

# copy dependency files
COPY pyproject.toml uv.lock ./

# install dependencies
RUN uv sync --no-dev

# Copy the app code
COPY app ./app

EXPOSE 5000

CMD ["uv", "run", "gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app.app:app"]