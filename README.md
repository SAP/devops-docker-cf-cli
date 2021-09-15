# Cloud Foundry Command Line Interface (CLI)

[![REUSE status](https://api.reuse.software/badge/github.com/SAP/devops-docker-cf-cli)](https://api.reuse.software/info/github.com/SAP/devops-docker-cf-cli)

This [_Dockerfile_](https://docs.docker.com/engine/reference/builder/) can be used in _Continuous Delivery_ (CD) pipelines for SAP development projects.
The image is optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/).
Docker containers simplify your CD tool setup, encapsulating tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md).
Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](https://developers.sap.com/tutorials/ci-best-practices-intro.html).

## About this repository

Dockerfile for an image with the Cloud Foundry CLI and plugins for blue-green deployment and Multi-Target Applications (MTA).

## Download

This image is published to [Docker Hub](https://hub.docker.com/r/ppiper/cf-cli) and can be pulled via the command

```
docker pull ppiper/cf-cli
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile and run

```
docker build -t ppiper/cf-cli .
```

## Usage

Recommended usage of this image is via [`cloudFoundryDeploy`](https://sap.github.io/jenkins-library/steps/cloudFoundryDeploy/) pipeline step.

For using the `cf` tool via this image, it can be invoked like in this command

```
docker run ppiper/cf-cli cf --help
```

## Testing

### Running as a Service

See `.travis.yml` file for configuration.

Configure the following variables (secrets)

* `CX_INFRA_IT_CF_USERNAME` (user name for deployment to SAP Cloud Platform)
* `CX_INFRA_IT_CF_PASSWORD` (password for deployment to SAP Cloud Platform)

### Running locally

Docker is required, and at least 4 GB of memory assigned to Docker.

```bash
export CX_INFRA_IT_CF_USERNAME="myusername"
export CX_INFRA_IT_CF_PASSWORD="mypassword"
./runTests.sh
```

## Licensing

Copyright 2017-2021 SAP SE or an SAP affiliate company and devops-docker-cf-cli contributors. Please see our [LICENSE](LICENSE) for copyright and license information. Detailed information including third-party components and their licensing/copyright information is available [via the REUSE tool](https://api.reuse.software/info/github.com/SAP/devops-docker-cf-cli).
