CAS Deployment Overlay for COB
=======================

This is the cas overlay customizations for the City of Bloomington.  Our custom theme must be compiled into the WAR file that is built.  The Makefile is written to build a WAR file for either Docker deployment or deployment into a Tomcat server.

Deployment can be done with either Ansible (deploy the WAR to Tomcat) or Helm (deploy the Docker image to Kubernetes).

To use this overlay, you build CAS using make, then deploy the build however you like.

## Using Makefile
### Dependencies
To build a deployment you must have these dependencies installed locally:

* make
* scss
* docker
* gradle

### Configure docker repo
You must provide your choice of Docker repository via a variable declared in a make.conf file
```bash
DOCKER_REPO=https://docker.example.org/somewhere
```

### Build WAR
This will build a WAR file that can be used to deploy into Tomcat or a Docker image.  The WAR file will be in /build/libs/cas.war

```bash
make war
```

### Build Docker image
This will build a tagged docker image, using the built WAR file, and push it to the docker repo.

```bash
make dockerfile
```

## Deploying with Ansible
Deploys the WAR file to a Tomcat server.


## Deploying with Helm
Deploys the Docker image into Kubernetes.
