Developer Guide
===============

Basic Requirements
------------------
Developers need to learn Python 3 programming language (tutorial: `Python3`_ ) and GitHub.

Core Dependencies
-----------------

**Flask**: The BAR API uses Python Flask (tutorial: `Flask`_). We use a class based approach to organize code.

**Flask-restx**: Flask RestX is used to create endpoints and generate swagger fontend (tutorial: `Flask-restx`_ ).

**Flask-Caching**: This module is used to cache queries (tutorial: `Flask-Caching`_). We used Redis as a key-value store.

**Flask-Limiter**: This module is used to rate-limit the usage of API end points. This will prevent server from overloading (tutorial: `Flask-Limiter`_ )

**Marshmallow**: This module is only used to validate JSON schema for POST requests (tutorial: `Marshmallow`_).

**MarkupSafe**: This is used to validate GET request inputs (tutorial: `MarkupSafe`_).

**Flask-SQLAlchemy**: This is used to provide database connectivity and queries (tutorial: `Flask-SQLAlchemy`_). This is based on Python SQLAlchemy (tutorial: `SQLAlchemy`_)

**Flake8**: This is used to see if there are no style errors in code. Just run ``flake8`` command.

**Pytest**: This module (tutorial: `Pytest`_) along with Flask testing framework (tutorial: `Flask-Testing`_) is used to unit test API endpoints.

**Coverage**: This module show the test code coverage, that is what parts of code are tested by unit tests (tutorial: `Coverage`_)

**Black**: This module is used to format and clean up code. Just run ``black .`` command.

Online CI/CD Pipeline
---------------------

**GitHub Actions**: This runs automated testing on GitHub (tutorial: `GitHub-Actions`_).

**LGTM**: This is for code quality testing.

**Codecov**: This report code coverage.

**Read the Docs**: This hosts documentation (tutorial: `readthedocs`_).

.. _Python3: https://docs.python.org/3/tutorial/index.html
.. _Flask: https://flask.palletsprojects.com/en/2.0.x/quickstart/
.. _Flask-Caching: https://flask-caching.readthedocs.io/en/latest/index.html
.. _Flask-Limiter: https://flask-limiter.readthedocs.io/en/master/#using-flask-pluggable-views
.. _Flask-restx: https://flask-restx.readthedocs.io/en/latest/
.. _Marshmallow: https://marshmallow.readthedocs.io/en/stable/quickstart.html
.. _MarkupSafe: https://pypi.org/project/MarkupSafe/
.. _Flask-SQLAlchemy: https://flask-sqlalchemy.palletsprojects.com/en/2.x/
.. _SQLAlchemy: https://docs.sqlalchemy.org/en/14/
.. _Pytest: https://docs.pytest.org/en/latest/getting-started.html
.. _Flask-Testing: https://flask.palletsprojects.com/en/2.0.x/testing/
.. _Coverage: https://coverage.readthedocs.io/en/6.2/
.. _GitHub-Actions: https://docs.github.com/en/actions/quickstart
.. _readthedocs: https://docs.readthedocs.io/en/stable/tutorial/
