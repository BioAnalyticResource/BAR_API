# BAR API

**master**: [![Build Status](https://github.com/BioAnalyticResource/BAR_API/workflows/BAR-API/badge.svg?branch=master)](https://github.com/BioAnalyticResource/BAR_API/actions?query=branch%3Amaster) [![codecov](https://codecov.io/gh/BioAnalyticResource/BAR_API/branch/master/graph/badge.svg?token=QSYUWTRYEV)](https://codecov.io/gh/BioAnalyticResource/BAR_API) **dev**: [![Build Status](https://github.com/BioAnalyticResource/BAR_API/workflows/BAR-API/badge.svg?branch=dev)](https://github.com/BioAnalyticResource/BAR_API/actions?query=branch%3Adev) [![codecov](https://codecov.io/gh/BioAnalyticResource/BAR_API/branch/dev/graph/badge.svg?token=QSYUWTRYEV)](https://codecov.io/gh/BioAnalyticResource/BAR_API)

[![Website Status](https://img.shields.io/website?url=http%3A%2F%2Fbar.utoronto.ca%2Fapi%2F)](http://bar.utoronto.ca/api/) ![GitHub repo size](https://img.shields.io/github/repo-size/BioAnalyticResource/BAR_API) [![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black) [![Documentation Status](https://readthedocs.org/projects/bar-api/badge/?version=latest)](https://bar-api.readthedocs.io/en/latest/?badge=latest)

This is the official repository for the Bio-Analytic Resource API. The API documentation can be found [here](https://bar-api.readthedocs.io/en/latest/).

## Local eFP sqlite mirrors

The `/efp_proxy/expression/{database}/{gene_id}` endpoint first tries to query a live SQLAlchemy bind (as configured in `config/BAR_API.cfg`). When you do not have access to those remote MySQL instances, you can still exercise the API by generating local SQLite mirrors from the shipped MySQL dumps:

```bash
# Build every mirror (takes a few minutes)
python scripts/build_sqlite_mirrors.py

# Or only the datasets you care about
python scripts/build_sqlite_mirrors.py klepikova sample_data

# Use --force to overwrite existing *.db files
python scripts/build_sqlite_mirrors.py klepikova --force
```

The script transforms the dumps in `config/databases/*.sql` into companion `*.db` files in the same directory. The eFP proxy will automatically fall back to those mirrors whenever the corresponding MySQL bind is unavailable, while production deployments continue to use the remote databases as soon as they are reachable.
