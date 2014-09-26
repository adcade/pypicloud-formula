{% set s3_key = salt['pillar.get']("s3_key") %}
{% set s3_secret = salt['pillar.get']("s3_secret") %}
{% set s3_bucket = salt['pillar.get']("pypicloud:s3_bucket") %}
{% set admin = salt['pillar.get']("pypicloud:admin") %}
{% set password = salt['pillar.get']("pypicloud:password") %}
{% set uwsgi_port = salt['pillar.get']("pypicloud:uwsgi_port", 3031) %}
{% set encrypt_key = salt['pillar.get']("pypicloud:session_encrypt_key") %}
{% set validate_key = salt['pillar.get']("pypicloud:session_validate_key") %}

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
        admin: {{ admin }}
        password: {{ password }}
        encrypt_key: {{ encrypt_key }}
        validate_key: {{ validate_key }}
        uwsgi_port: {{ uwsgi_port }}
        virtualenv_path: /opt/pypicloud/.venv
        log_file: /var/log/pypicloud.log
        s3_key: {{ s3_key }}
        s3_secret: {{ s3_secret }}
        s3_bucket: {{ s3_bucket }}

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
