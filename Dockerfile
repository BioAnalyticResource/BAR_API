FROM python:3.9.2-buster

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

RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

# Docker specific configuration
# MySQL is on a different host now
RUN sed -i 's/mysql/mysql -h BAR_mysqldb/' ./config/init.sh
RUN sed -i 's/localhost/BAR_mysqldb/' ./config/BAR_API.cfg

# To expose app, it must listen to 0.0.0.0 and not localhost
RUN sed -i 's/run()/run(host="0.0.0.0")/' ./app.py

# wait-for-it must only one command.
RUN echo "python3 app.py" >> ./config/init.sh
RUN echo "CACHE_REDIS_HOST = 'BAR_redis'" >> ./config/BAR_API.cfg
