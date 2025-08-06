FROM buildpack-deps:bookworm-curl

LABEL org.opencontainers.image.source=https://github.com/SAP/devops-docker-cf-cli
LABEL org.opencontainers.image.description="An image for the cf cli"
LABEL org.opencontainers.image.licenses=Apache-2.0

ENV VERSION=0.1

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ps needs to be available to be able to be used in docker.inside, see https://issues.jenkins-ci.org/browse/JENKINS-40101
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      jq \
      procps && \
    rm -rf /var/lib/apt/lists/*

# add group & user
ARG USER_HOME=/home/piper
RUN addgroup -gid 1000 piper && \
    useradd piper --uid 1000 --gid 1000 --shell /bin/bash --home-dir "${USER_HOME}" --create-home
    
ARG INSTALL_DIR=/usr/local/bin
RUN curl --location --silent "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=v8&source=github" | tar -zx -C "${INSTALL_DIR}" && \
    cf --version

RUN curl https://cli.btp.cloud.sap/btpcli-install.sh | bash -s -- -o "${INSTALL_DIR}" -v latest && \
    btp --version

USER piper
WORKDIR ${USER_HOME}

ARG MTA_PLUGIN_VERSION=3.5.0
ARG MTA_PLUGIN_URL=https://github.com/cloudfoundry/multiapps-cli-plugin/releases/download/v${MTA_PLUGIN_VERSION}/multiapps-plugin.linux64
ENV MULTIAPPS_DISABLE_UPLOAD_PROGRESS_BAR=true
ARG CSPUSH_PLUGIN_VERSION=1.3.2
ARG CSPUSH_PLUGIN_URL=https://github.com/dawu415/CF-CLI-Create-Service-Push-Plugin/releases/download/${CSPUSH_PLUGIN_VERSION}/CreateServicePushPlugin.linux64

RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org && \
    cf install-plugin ${MTA_PLUGIN_URL} -f && \
    cf install-plugin ${CSPUSH_PLUGIN_URL} -f && \
    cf install-plugin -r CF-Community "html5-plugin" -f && \
    cf plugins

# allow anybody to read/write/exec at HOME
RUN chmod -R o+rwx "${USER_HOME}"
ENV HOME=${USER_HOME}
