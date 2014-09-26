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
Install pypicloud with s3-backend served with nginx + uwsgi.

Pillar example
==============

.. code::

  s3_key:    <s3_key>
  s3_secret: <s3_secret>

  pypicloud:
    bucket:   <s3_bucket>
    admin:    <admin_username>
    password: <admin_password>

