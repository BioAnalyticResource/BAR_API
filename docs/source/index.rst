.. BAR API documentation master file, created by
   sphinx-quickstart on Fri Nov 26 19:30:59 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to BAR API's documentation!
===================================

This is the documentation for the BAR API.

Run on your own computer with Docker
------------------------------------
1. Install `Docker`_
2. Install `Docker Compose`_
3. Install `Git`_
4. Clone this repository and change directory to ``BAR_API``
5. Build docker images

   ``docker-compose build``

6. Run docker containers (-d is detached)

   ``docker-compose up -d``

7. Load ``http://localhost:5000/`` in a web browser. Enjoy :)

.. _Docker: https://docs.docker.com/get-docker/
.. _Docker Compose: https://docs.docker.com/compose/install/
.. _Git: https://git-scm.com/downloads

Run on your own computer without Docker
---------------------------------------

1. Install `MySQL`_ or `Maria DB`_
2. Install `Redis`_
3. Install `Python`_  or `Pypy`_. Note: Python 2 is not supported.
4. Install [Git](https://git-scm.com/downloads)
5. (Optional) On Debian based systems, you may also need to install ``libmysqlclient-dev`` and ``python3-dev``. On FreeBSD, you may need to install ``py38-sqlite3``. We will update this step as we come across more OS dependencies.
6. Clone this repository and change directory to ``BAR_API``
7. Set up a virtual environment

   ``python3 -m venv venv``

8. Activate the virtual environment. Bash/Zsh:

   ``source venv/bin/activate``

csh/tcsh:

   ``source venv/bin/activate.csh``

9. Install requirements

   ``pip install --upgrade pip setuptools wheel``
   ``pip install -r requirements.txt``

10. Copy ``config/BAR_API.cgi`` to your preferred directory, for example:

   ``cp config/BAR_API.cgi ~/.config/``

Add, update, and modify passwords and environment variables as needed.

11. Copy ``./config/init.sh`` to BAR_API directory:

   ``cp config/init.sh .``

Change passwords in ``./init.sh`` and run this script to load the databases:

   ``./init.sh``

Then delete ``./init.sh``

12. Edit ``./api/__init__.py`` and update the location of your BAR_API.cfg file if you have changed it.

13. Run ``pytest``. Tests should pass if the system is set up correctly.

14. Run ``python app.py`` to start.

15. Load ``http://localhost:5000/`` in a web browser. Enjoy :)

.. _MySQL: https://www.mysql.com/products/community/
.. _Maria DB: https://mariadb.com/downloads/
.. _Redis: https://redis.io/download
.. _Python: https://www.python.org/downloads/
.. _Pypy: https://www.pypy.org/download.html