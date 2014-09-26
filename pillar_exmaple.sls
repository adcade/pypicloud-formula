s3_key:    [your_s3_key]    # required
s3_secret: [your_s3_secret] # required

pypicloud:
  s3_bucket:       [your_s3_bucket] # required
  admin:           [admin username] # required
  password:        [admin password] # required
  uwsgi_port:      3031 # optional
  nginx_port:      6543 # optional
  nginx_location:  /    # optional
  session_encrypt_key:  [beaker encrypt key]  #required
  session_validate_key: [beaker validate key] #required
