fuel-devops-sqlite.venv
=======================

By default the fuel-devops uses Postgres DB.
It can be changed with env variables, but after setup.
The fuel-devops setup requeres the Psycopg2 library.
So, have to install the libpq-dev to resolve the dependency.


RTFM
----

* https://github.com/openstack/fuel-devops
* https://docs.fuel-infra.org/fuel-dev/devops.html
* Look the DATABASES section in https://github.com/openstack/fuel-devops/blob/master/devops/settings.py


Setup the fuel-devops virtualenv
--------------------------------

    $ sudo apt-get install python-pip virtualenvwrapper
    $ mkvirtualenv fuel-devops
    $ pip install git+https://github.com/openstack/fuel-devops.git@<version> --upgrade

Switch to sqlite db
-------------------

* Check the virtualenv
* Run `fuel-devops-sqlite.venv/setup.sh`
* Copy `fuel-devops-sqlite.venv/postactivate` to `virtualenv/bin/` directory
* Re-activate the virtualenv
