FROM python:3.8-slim

# Section 2- Python Interpreter Flags
ENV PYTHONUNBUFFERED 1  
ENV PYTHONDONTWRITEBYTECODE 1

# Section 3- Compiler and OS libraries
RUN apt-get update \  
  && apt-get install -y --no-install-recommends build-essential libpq-dev \  
  && rm -rf /var/lib/apt/lists/*

# Section 4- Project libraries and User Creation
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt \  
    && rm -rf /tmp/requirements.txt \  
    && useradd -U app_user \  
    && install -d -m 0755 -o app_user -g app_user /static

# Section 5- Code and User Setup
WORKDIR /code

USER app_user:app_user

COPY --chown=app_user:app_user . .

RUN chmod +x docker/*.sh

ENTRYPOINT ["./docker/entrypoint.sh"]
