+++
title = "Building your first Docker image"
date = "2015-01-06T14:08:43+01:00"
categories = ["development"]
tags = ["hugo", "docker", "cms", "virtualization"]
draft = true
+++

Docker images are the way to distribute preconfigured, rebuildable containers.

This can for example be used to:

- persist the runtime  configuration for a project in the SCM system of your choice and
- exchange configurations between team members
- get new team members up and running in minutes instead of days
- aleviate the burden of keeping a running dev environment up to date as long as the software is in production - even if the backlog is empty
- ...and many more

To create a docker image you basically have two options:

1. start a container, customize the environment to your liking and finally package the container as a reusable image
1. build an image by means of a Dockerfile

If you plan on reusing and distributing your image it is always recommended to use a Dockerfile to describe the resulting environment. If an image is just packaged from an existing container, there is no easy way for the future user to know what functionality is provided by the image.
