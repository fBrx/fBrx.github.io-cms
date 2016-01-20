+++
title = "Building your first Docker image"
date = "2016-01-20T19:09:27+01:00"
categories = ["development"]
tags = ["docker", "virtualization"]
draft = false
+++

Docker images are the way to distribute preconfigured, rebuildable containers.

This can for example be used to:

- persist the runtime configuration for a project in the SCM system of your choice and
- exchange configurations between team members
- get new team members up and running in minutes instead of days
- aleviate the burden of keeping a running dev environment up to date as long as the software is in production - even if the backlog is empty
- ...and many more

To create a docker image you basically have two options:

1. start a container, customize the environment to your liking and finally package the container as a reusable image
1. build an image by means of a Dockerfile

If you plan on reusing and distributing your image it is always recommended to use a Dockerfile to describe the resulting environment. If an image is just packaged from an existing container, there is no easy way for the future user to know what functionality is provided by the image.

# Creating a Dockerfile

The Dockerfile is the Docker-way of specifiing the characteristics of an image, which can then be used to create a running container. You can think of the Dockerfile as a recipe to automatically build your image.

The Dockerfile is made up of different commands. There is a comprehensive [Dockerfile reference](https://docs.docker.com/engine/reference/builder/) provided.

## The base image

The base image specifies the starting point of your container description. Usually you will not start with an empty container, but extend or customize an existing container (e.g. ubuntu or tomcat). You specifiy the base image with the ```FROM <image>[:<tag>]``` directive. The definition of the base image must be the first non-comment instruction in the Dockerfile.

## Commands

All of the available commands are documented extensively in the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/) and will not be covered in detail here.

## ENTRYPOINT and CMD

The ```ENTRYPOINT``` and ```CMD``` directives can be used to create executable containers and specify the command (and arguments) to be run on startup.

The ```ENTRYPOINT``` defines the default command (optionally including arguments) which is executed when an image is run via the ```docker run <image>``` command.
The ```CMD``` dirctive is used to specify default arguments to the executable defined in the entrypoint. If any command line arguments are supplied to the ```docker run <image>``` command, they wil replace the values specified in the Dockerfile. This can thus be used to provide a sensible default configuration to easily create and run a container based on your image without loosing the flexibility of customizing the startup command parameters (and minimizing he need to create a seperate Dockerfile just to adjust the command parameters).

*Note:* There are different possibilities and combinations for using the two directives, but the scenario described above worked out the best for me.

# Creating the image

To create the image, you must buils it. This basically means that the instructions in the Dockerfile have to be executed, recorded and persisted in the resulting image with the name of your choice. The image gets build with the ```docker build``` command:

```
docker build -t <namespace>/<image>:<tag> <base dir>
```

This will execute the Dockerfile and store the resulting image in the local repository. The option after the ```-t``` flag specifies the desired name of your resulting image in the (local) repository. Even though this setting is optional, I would always recommend setting it, since otherwise you will not be able to easily reference your newly built image. 
The image names consist of a namespace and a tag name. You can group different images under a namespace. If you use the [Docker Hub](https://hub.docker.com) your account name will be the namespace for your images.
The tag can be used to provide different versions of an image. If not specified the tag 'latest' will be implied.

You can check, that your image was built successfully and stored in the local repository by running the ```docker images``` command:

```
$ docker images
REPOSITORY     TAG        IMAGE ID         CREATED           VIRTUAL SIZE
fbrx/test      latest     756a1405cd9e     7 minutes ago     237.7 MB
<none>         <none>     ee6e804e0180     8 minutes ago     237.7 MB
```