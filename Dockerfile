# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-22.04-v4@sha256:726ec1faaebd35668a33af8e0508cdb61bff5cdf604fd99c45f3a7c9a636e621

# Environment
ENV LANG=en_US.UTF-8
ENV DARK_MODE=1
ENV KEEP_APP_RUNNING=1
# renovate: datasource=github-tags depName=Windows200000/TwitchDropsMiner-updated versioning=loose
ENV TDM_VERSION_TAG=15.12.0
ENV APP_ICON_URL="https://raw.githubusercontent.com/Windows200000/TwitchDropsMiner-updated/master/appimage/pickaxe.png"

# Install Twitch Drops Miner
RUN \
  echo "*** Install system packages ***" && \
  apt-get update -y && \
  apt-get install -y --no-install-recommends \
    wget \
    unzip \
    libc6 \
    ca-certificates \
    gir1.2-appindicator3-0.1 \
    language-pack-en \
    fonts-noto-color-emoji && \

  echo "*** Fixing jlesage/baseimage-gui issue with imagemagick ***" && \
  echo "*** Should be fixed in >4.7.0 ***" && \
  wget https://raw.githubusercontent.com/jlesage/docker-baseimage-gui/refs/heads/master/helpers/install_app_icon.sh \
    -O /opt/base/bin/install_app_icon.sh && \

  echo "*** Install Application ***" && \
  set-cont-env APP_NAME "Twitch Drops Miner" && \
  set-cont-env APP_VERSION "${TDM_VERSION_TAG}" && \
  install_app_icon.sh "$APP_ICON_URL" && \
  wget -P /tmp/ https://github.com/Windows200000/TwitchDropsMiner-updated/releases/download/v${TDM_VERSION_TAG}/Twitch.Drops.Miner.Linux.PyInstaller.zip && \
  mkdir /app && \
  unzip -p /tmp/Twitch.Drops.Miner.Linux.PyInstaller.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" > /app/TwitchDropsMiner && \
  chmod +x /app/TwitchDropsMiner && \
  echo "*** Link folders and files ***" && \
  mkdir /config && \
  ln -s /config/settings.json /app/settings.json && \
  ln -s /config/cookies.jar /app/cookies.jar && \
  take-ownership /config && \
  take-ownership /app && \
  echo "*** cleanup ***" && \
  apt-get -y autoremove && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache

# Add local entrypoint
COPY --chmod=555 startapp.sh /startapp.sh

VOLUME /config
EXPOSE 5800
