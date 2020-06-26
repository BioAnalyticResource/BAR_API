# BAR API

This is the official repository for the Bio-Analytic Resource. The API is live [here](http://bar.utoronto.ca/api/apidocs).

## Status
Apart from Travis CI and testing on live BAR, we frequently test the API on systems that are not BAR for cross platform compatibility. The most recent test is on the following systems:

* OpenBSD 6.7-CURRENT (running Maria DB 10.4.12v1, Python 3.8.3 and Redis 6.0.5)
* FreeBSD 

## Run on your own computer

1. Install [MySQL](https://www.mysql.com/products/community/) or [Maria DB](https://mariadb.com/downloads/). For Debian based systems, you may also need to install ```libmysqlclient-dev```.
2. (Optional) Install [Redis](https://redis.io/download).
3. Install [Python](https://www.python.org/downloads/) or [Pypy](https://www.pypy.org/download.html). Note: Python 2 is not supported.

