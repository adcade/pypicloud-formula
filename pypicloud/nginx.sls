{% set port = salt['pillar.get']("pypicloud:nginx_port", 6543) %}
{% set location = salt['pillar.get']("pypicloud:nginx_location", "/") %}
{% set uwsgi_port = salt['pillar.get']("pypicloud:uwsgi_port", 3031) %}


include:
  - nginx

/etc/nginx/sites-available/pypicloud.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://pypicloud/files/nginx-pypicloud.jinja
    - context:
        port: {{ port }}
        location: "/"
        uwsgi_port: {{ uwsgi_port }}

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
