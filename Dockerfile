FROM python:3.10.2-bullseye

WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app

RUN apt update && \
    apt dist-upgrade -y && \
    apt install -y --no-install-recommends \
        wait-for-it \
        default-mysql-client \
        libmariadb-dev-compat \
        libmariadb-dev \
        python3-dev

RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

# Docker specific configuration
# MySQL is on a different host now
# To expose app, it must listen to 0.0.0.0 and not localhost
# wait-for-it must only one command.
RUN sed -i 's/mysql/mysql -h BAR_mysqldb/' ./config/init.sh && \
    sed -i 's/localhost/BAR_mysqldb/' ./config/BAR_API.cfg && \
    sed -i 's/run()/run(host="0.0.0.0")/' ./app.py && \
    echo "pytest -s" >> ./config/init.sh && \
    echo "python3 app.py" >> ./config/init.sh && \
    echo "CACHE_REDIS_HOST = 'BAR_redis'" >> ./config/BAR_API.cfg
