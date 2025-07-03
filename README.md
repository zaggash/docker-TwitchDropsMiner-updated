Based on this image: https://github.com/jlesage/docker-baseimage-gui


### docker-compose example
```
services:
  twitch-drops-miner:
    container_name: twitch-drops-miner
    image: ghcr.io/zaggash/twitchdropsminer-updated:15.12.0@sha256:446cbda7c83ecebe52230f68ba3e8d14e2f06893244db4c9f261c911a2854dc2
    volumes:
      - "/my/local/folder/twitchdropsminer:/config"
    environment:
      TZ: Europe/paris
      SECURE_CONNECTION: 1
      WEB_AUTHENTICATION: 1
      WEB_AUTHENTICATION_USERNAME: myUser
      WEB_AUTHENTICATION_PASSWORD: myPassword
    ports:
      - 5800:5800
    restart: always
```

You can set the needed Env Variable with their description here https://github.com/jlesage/docker-baseimage-gui#environment-variables
With the config above, you can reach the application with https on port 5800
