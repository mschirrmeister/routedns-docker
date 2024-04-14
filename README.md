# routedns-resolver Docker

This project provides a __Dockerfile__ for  [RouteDNS](https://github.com/folbricht/routedns) project with a configuration specific to to pick the **fastest** answer from a list of **DoH**, **DoH3**, **DoT** and **DoQ** servers.

**RouteDNS** listens on port `53` to accept standard **Do53** requests via tcp or udp, which then get forwarded in **parallel** via the **doh, doh3, dot or doq** servers.

Below are a few examples on how to run the container.

## Examples

Run the container with a build-in configuration.

    docker run -it \
      --name routedns \
      -p 53:53/tcp \
      -p 53:53/udp \
      -p 443:443/tcp \
      mschirrmeister/routedns:latest

Run the container with own custom configuration.

    docker run -it -d \
      --name routedns \
      -p 53:53/tcp \
      -p 53:53/udp \
      -p 443:443/tcp \
      -v /Users/marco/MyData/git/public/routedns-docker/routedns.toml:/app/routedns.toml \
      mschirrmeister/routedns:latest

