========
Buildbot
========

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``pypicloud``
-------------
Install pypicloud with s3-storage served with nginx + uwsgi.

Pillar example
==============

.. code::

  s3_key:    <s3_key>
  s3_secret: <s3_secret>

  pypicloud:
    bucket:   <s3 bucket as storage, required>
    admin:    <admin username, required>
    password: <admin password, required>
    session_encrypt_key:  <beaker session encrypt key, required>
    session_validate_key: <beaker session validate key, required>
    uwsgi_port: <uwsgi port, optional, default: 6543>
    nginx_port: <nginx port, optional, default: 3031>
    nginx_location: <nginx location default: />

see pillar_example.sls
