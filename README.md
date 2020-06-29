# BAR API

**master**: [![Build Status](https://travis-ci.com/BioAnalyticResource/BAR_API.svg?branch=master)](https://travis-ci.com/BioAnalyticResource/BAR_API) [![Coverage Status](https://coveralls.io/repos/github/BioAnalyticResource/BAR_API/badge.svg?branch=master)](https://coveralls.io/github/BioAnalyticResource/BAR_API?branch=master) **dev**: [![Build Status](https://travis-ci.com/BioAnalyticResource/BAR_API.svg?branch=dev)](https://travis-ci.com/BioAnalyticResource/BAR_API) [![Coverage Status](https://coveralls.io/repos/github/BioAnalyticResource/BAR_API/badge.svg?branch=dev)](https://coveralls.io/github/BioAnalyticResource/BAR_API?branch=dev)

[![Website](http://bar.utoronto.ca/api/apidocs)](https://img.shields.io/website?url=http%3A%2F%2Fbar.utoronto.ca%2Fapi%2Fapidocs) ![GitHub repo size](https://img.shields.io/github/repo-size/BioAnalyticResource/BAR_API)

This is the official repository for the Bio-Analytic Resource API. The API is live [here](http://bar.utoronto.ca/api/apidocs).

## Status

Apart from Travis CI and testing on the live BAR, we frequently test the API on systems that are not BAR for cross-platform compatibility. The most recent test is on the following systems:

* OpenBSD 6.7-CURRENT (Maria DB 10.4.12v1, Python 3.8.3 and Redis 6.0.5)
* FreeBSD 12.1-RELEASE-p6 (MySQL 8.0.20, Python 3.8.3 and Redis 5.0.9)

## Run on your own computer

1. Install [MySQL](https://www.mysql.com/products/community/) or [Maria DB](https://mariadb.com/downloads/).
2. (Optional) Install [Redis](https://redis.io/download).
3. Install [Python](https://www.python.org/downloads/) or [Pypy](https://www.pypy.org/download.html). Note: Python 2 is not supported.
4. Install [Git](https://git-scm.com/downloads)
5. (Optional) On Debian based systems, you may also need to install ```libmysqlclient-dev```. On FreeBSD, you may need to install ```py38-sqlite3```. We will update this step as we come across more OS dependencies. 
6. Clone this repository and change directory to ```BAR_API```
7. Set up a virtual environment
```
python3 -m venv venv
```
8. Activate the virtual environment. Bash/Zsh:
```
source venv/bin/activate
```
csh/tcsh:
```
source venv/bin/activate.csh
```
9. Install requirements
```
pip3 install --upgrade pip
pip3 install --upgrade setuptools
pip3 install -r requirements.txt
```
10. Set up databases and configuration. Note: Change passwords in ```./config/init.sh``` and ```./config/BAR_API.cfg```
```
./config/init.sh
```
11. Edit ```./api/base.sh``` and update line 38 and add the location of your BAR_API.cfg file.
12. Run ```pytest```. Tests should pass if the system is set up correctly.
13. Run ```python3 app.py``` to start.
14. Load ```http://localhost:5000/apidocs``` in a web browser. Enjoy :)
