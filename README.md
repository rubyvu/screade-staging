# README

## Webpacker

### Run server with webpacker in watch mode:

- Run rails server with default 3000 port:
```
  foreman start -f Procfile
```

- If need run local server with custom port:
```
  foreman start -f Procfile -p 3010
```

### Run server with use Hot Reloading (HMR):

- Run rails server with webpacker in dev mode with default 3000 port:
```
  foreman start -f Procfile.dev
```

- If need run local server with custom port:
```
  foreman start -f Procfile.dev -p 3010
```

## AWS

### How to run a Rails console?

```
cd /var/app/current && export $(cat /opt/elasticbeanstalk/deployment/env | xargs) && bundle exec rails c
```
