+++
title = "Fixing Tomcat startup performance on cloud servers"
date = "2016-01-21T00:20:45+01:00"
categories = ["development"]
tags = ["tomcat", "web", "docker", "cloud", "performance"]
draft = true
+++

Apache Tomcat is well known to be a lightweight and _fast_ web container. This makes it a perfect fit for running your Java based web applications. Doing just that and playing around with [Docker Tutum](https://www.tutum.co/) and [Digitalocean](https://www.digitalocean.com) I discovered that starting up a Docker Container, which would take <25s locally took over 2 minutes when being deployed on a Digitalocean server.

Digging through the logs, the following line cought my attention:

	INFO: Creation of SecureRandom instance for session ID generation using [SHA1PRNG] took [199,620] milliseconds.


Searching the web I found the solution on the allmighty [StackOverflow](https://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source) and the [Tomcat Wiki](https://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source). The explanation given there is as follows:

> Tomcat 7+ heavily relies on SecureRandom class to provide random values for its session ids and in other places. Depending on your JRE it can cause delays during startup if entropy source that is used to initialize SecureRandom is short of entropy.

This makes perfectly sense as the servers, which are provided by Digitalocean (and probably all other cloud providers) would all be virtualized and spun up from the same templates. The lack of any external peripherals which produce unpredictable inputs (like keyboard, mouse, soundchips, etc) may lead to a low source of entropy. Using a blocking entropy source will guarantee a sufficient level of entropy but - as the name suggests - will block in case of low entropy until a sufficient level is reached.

The default (blocking) entropy source used by Java under Linux is ```/dev/random```. This can be swapped out for the non-blocking version ```/dev/urandom``` by setting the Java system property ```java.security.egd```:

	-Djava.security.egd=file:/dev/./urandom

For Tomcat the right place to put this setting would be the CATALINA_OPTS property in the file *apache-tomcat/bin/setenv.sh*. If not already existing, you can create an appropriate file with the folowing command:

	echo "CATALINA_OPTS=-Djava.security.egd=file:/dev/./urandom" > apache-tomcat/bin/setenv.sh && \
	chmod a+x apache-tomcat/bin/setenv.sh

For all you Docker geeks out there I provided a Docker base image, which has the setting preconfigured under [fbrx/tomcat](https://hub.docker.com/r/fbrx/tomcat/).

## /dev/random vs /dev/urandom

In Tomcat the SecureRandom instance is used for session id generation. If you are running in a highly sensitive environment this might be of concern to you. Otherwise this is probably no problem. Anyways always use good judement and think about the consequences.

```man 4 random``` provides further detail on he difference:

>  /dev/random should be suitable for uses that need very high quality randomness such as one-time pad or key generation. When the entropy pool is empty, reads from /dev/random will block until additional environmental noise is gathered.

> A read from the /dev/urandom device will not block waiting for more entropy. As a result, if there is not sufficient entropy in the entropy pool, the returned values are theoretically vulnerable to a cryptographic attack on the algorithms used by the driver. Knowledge of how to do this is not available in the current unclassified literature, but it is theoretically possible that such an attack may exist. If this is a concern in your application, use /dev/random instead.


## Sources and further reading

* http://stackoverflow.com/questions/28201794/slow-startup-on-tomcat-7-0-57-because-of-securerandom
* https://hub.docker.com/r/fbrx/tomcat/
* http://security.stackexchange.com/questions/89/feeding-dev-random-entropy-pool
* https://wiki.apache.org/tomcat/HowTo/FasterStartUp#Entropy_Source
* http://linux.die.net/man/4/random