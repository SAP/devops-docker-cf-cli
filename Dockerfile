FROM buildpack-deps:stretch-curl

ENV VERSION 0.1

# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# ps needs to be available to be able to be used in docker.inside, see https://issues.jenkins-ci.org/browse/JENKINS-40101
RUN apt-get update && \
    apt-get install -y --no-install-recommends procps && \
    rm -rf /var/lib/apt/lists/*

# add group & user
ARG USER_HOME=/home/piper
ARG CFCLI_VERSION

RUN addgroup -gid 1000 piper && \
    useradd piper --uid 1000 --gid 1000 --shell /bin/bash --home-dir "${USER_HOME}" --create-home && \
    LATEST_CFCLI=$(curl -s https://api.github.com/repos/cloudfoundry/cli/releases/latest | grep tag_name | grep -v beta | cut -d \" -f 4 | tr -d v) && \
    curl --location --silent "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=${CFCLI_VERSION:-$LATEST_CFCLI}&source=github" | tar -zx -C /usr/local/bin && \
    cf --version

USER piper
WORKDIR ${USER_HOME}

ARG MTA_PLUGIN_VERSION
ARG CSPUSH_PLUGIN_VERSION

RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org && \
    cf install-plugin blue-green-deploy -f -r CF-Community && \
    LATEST_MTA=$(curl -s https://api.github.com/repos/cloudfoundry/multiapps-cli-plugin/releases/latest | grep tag_name | cut -d \" -f 4 | tr -d v) && \
    cf install-plugin https://github.com/cloudfoundry/multiapps-cli-plugin/releases/download/v${MTA_PLUGIN_VERSION:-$LATEST_MTA}/multiapps-plugin.linux64 -f && \
    LATEST_CSPUSH=$(curl -s https://api.github.com/repos/dawu415/CF-CLI-Create-Service-Push-Plugin/releases/latest | grep tag_name | cut -d \" -f 4) && \
    cf install-plugin https://github.com/dawu415/CF-CLI-Create-Service-Push-Plugin/releases/download/${CSPUSH_PLUGIN_VERSION:-$LATEST_CSPUSH}/CreateServicePushPlugin.linux64 -f && \
    cf install-plugin -r CF-Community "html5-plugin" -f && \
    cf plugins

# allow anybody to read/write/exec at HOME
RUN chmod -R o+rwx "${USER_HOME}"
ENV HOME=${USER_HOME}
