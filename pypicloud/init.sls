{% set s3_key = salt['pillar.get']('s3_key') %}
{% set s3_secret = salt['pillar.get']('s3_secret') %}
{% set pypi_bucket = salt['pillar.get']('pypicloud:bucket') %}
{% set pypi_admin = salt['pillar.get']('pypicloud:admin') %}
{% set pypi_password = salt['pillar.get']('pypicloud:password') %}

pypicloud:
  user.present:
    - shell: /bin/bash
    - home: /opt/pypicloud
    - createhome: true

/opt/pypicloud/.bash_profile:
  file.managed:
    - user: pypicloud
    - group: pypicloud
    - mode: 644
    - template: jinja
    - source: salt://pypicloud/files/bash_profile
    - require:
      - user: pypicloud

/opt/pypicloud/.venv:
  virtualenv.managed:
    - user: pypicloud
    - requirements: salt://pypicloud/files/requirements.txt
    - require:
      - user: pypicloud

/opt/pypicloud/server.ini:
  file.managed:
    - user: pypicloud
    - group: pypicloud
    - mode: 644
    - template: jinja
    - source: salt://pypicloud/files/server.ini.jinja
    - require:
      - user: pypicloud
    - context:
        admin: {{ pypi_admin }}
        password: {{ pypi_password }}
        virtualenv_path: /opt/pypicloud/.venv
        log_file: /var/log/pypicloud.log
        s3_key: {{ s3_key }}
        s3_secret: {{ s3_secret }}
        pypi_bucket: {{ pypi_bucket }}

include:
  - nginx

/etc/init/pypicloud.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://pypicloud/files/upstart-pypicloud.jinja
    - context:
        log_file: /var/log/pypicloud.log
        user: pypicloud
        virtualenv_path: /opt/pypicloud/.venv
        conf_file: /opt/pypicloud/server.ini

uwsgi-pypicloud-service:
  service:
    - running
    - name: pypicloud
    - require:
      - file: /etc/init/pypicloud.conf

/etc/nginx/sites-available/pypicloud.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://pypicloud/files/nginx-pypicloud.jinja
    - context:
        port: 6543
        location: "/"

/etc/nginx/sites-enabled/pypicloud.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/pypicloud.conf
    - require:
      - file: /etc/nginx/sites-available/pypicloud.conf

nginx -s reload:
  cmd.run:
    - user: root
    - require:
      - file: /etc/nginx/sites-enabled/pypicloud.conf
      - service: uwsgi-pypicloud-service
