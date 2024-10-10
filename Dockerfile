# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-22.04-v4@sha256:881989d1f776bdf467b6dc168878a094456935076c9969caaaf045fda9ea98cb

# Environment
ENV LANG=en_US.UTF-8
ENV DARK_MODE=1
ENV KEEP_APP_RUNNING=1
# renovate: datasource=github-tags depName=Windows200000/TwitchDropsMiner-updated versioning=loose
ENV TDM_VERSION_TAG=15.9.1
ENV APP_ICON_URL="https://raw.githubusercontent.com/Windows200000/TwitchDropsMiner-updated/master/appimage/pickaxe.png"

# Install Twitch Drops Miner
RUN apt-get update -y
RUN apt-get install -y wget unzip libc6 gir1.2-appindicator3-0.1 language-pack-en fonts-noto-color-emoji
RUN wget -P /tmp/ https://github.com/Windows200000/TwitchDropsMiner-updated/releases/download/v${TDM_VERSION_TAG}/Twitch.Drops.Miner.Linux.PyInstaller.zip
RUN mkdir /TwitchDropsMiner
RUN unzip -p /tmp/Twitch.Drops.Miner.Linux.PyInstaller.zip "Twitch Drops Miner/Twitch Drops Miner (by DevilXD)" >/TwitchDropsMiner/TwitchDropsMiner
RUN chmod +x /TwitchDropsMiner/TwitchDropsMiner
RUN rm -rf /tmp

# Link config folder files
RUN mkdir /TwitchDropsMiner/config
RUN ln -s /TwitchDropsMiner/config/settings.json /TwitchDropsMiner/settings.json
RUN ln -s /TwitchDropsMiner/config/cookies.jar /TwitchDropsMiner/cookies.jar

# Make sure permissions are gonna work
RUN take-ownership /TwitchDropsMiner

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Generate and install favicons
RUN install_app_icon.sh "$APP_ICON_URL"

# Set the name/version of the application.
RUN set-cont-env APP_NAME "Twitch Drops Miner"
RUN set-cont-env APP_VERSION "${TDM_VERSION_TAG}"
