## CloudFoundry CLI Image

The CX Server is a collection of [_Dockerfiles_](https://docs.docker.com/engine/reference/builder/) for images that can be used in _Continuous Delivery_ (CD) pipelines for SAP development projects.
The images are optimized for use with project ["Piper"](https://github.com/SAP/jenkins-library) on [Jenkins](https://jenkins.io/).
Docker containers simplify your CD tool setup, encapsulating tools and environments that are required to execute pipeline steps.

If you want to learn how to use project "Piper" please have a look at [the documentation](https://github.com/SAP/jenkins-library/blob/master/README.md).
Introductory material and a lot of SAP scenarios not covered by project "Piper" are described in our [Continuous Integration Best Practices](https://developers.sap.com/tutorials/ci-best-practices-intro.html).

This repository contains Dockerfiles that are designed to run project "Piper" pipelines.
Nevertheless, they can also be used flexibly in any custom environment and automation process.

For detailed usage information please check the README.md in the corresponding folder.

Dockerfile for an image with the CloudFoundry CLI and plugins for blue-green deployment and MTA.
This image is intended to be used in Jenkins pipelines.

## Download

This image is published to Docker Hub and can be pulled via the command

```
docker pull ppiper/cf-cli
```

## Build

To build this image locally, open a terminal in the directory of the Dockerfile an run

```
docker build -t ppiper/cf-cli .
```

## Usage

Recommended usage of this image is via [`cloudFoundryDeploy`](https://sap.github.io/jenkins-library/steps/cloudFoundryDeploy/) pipeline step.

For using the `cf` tool via this image, it can be invoked like in this command

```
docker run ppiper/cf-cli cf
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

## License

Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved.
This file is licensed under the Apache Software License, v. 2 except as noted
otherwise in the [LICENSE file](https://github.com/SAP/devops-docker-images/blob/master/LICENSE).

Please note that Docker images can contain other software which may be licensed under different licenses. This License file is also included in the Docker image. For any usage of built Docker images please make sure to check the licenses of the artifacts contained in the images.
