#!/bin/bash
# This hook is run after a new virtualenv is activated.


export DEVOPS_DB_ENGINE="django.db.backends.sqlite3"
export DEVOPS_DB_NAME="${HOME}/.devops/fuel_devops.sqlite"

django-admin.py syncdb --settings=devops.settings
django-admin.py migrate devops --settings=devops.settings
