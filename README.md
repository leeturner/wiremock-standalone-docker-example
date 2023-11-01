# Example of running Wiremock Standalone in Docker

This repo contains an example of using wiremock standalone running in docker. The example uses the `wiremock:nightly`
image and maps the directories local to this repository the directories inside the image in the following way:

* local mappings directory: `./wiremock/mappings` is mapped to docker mappings directory: `/home/wiremock/mappings`
* local files directory: `./wiremock/__files` is mapped to docker files directory: `/home/wiremock/__files`
* local extensions directory: `./wiremock/extensions` is mapped to docker extensions
  directory: `/var/wiremock/extensions`

## Starting Wiremock

The `start.sh` script is used to start the wiremock container and map the above directories. By default, the container
starts on port `8080` but this can be changed by passing in a different port number as the first argument to the
script:

```bash
./start.sh 7070
Mounting local mappings directory: /Users/l_turner/dev/wiremock-standalone-docker-example/wiremock/mappings to docker mappings directory: /home/wiremock/mappings
Mounting local files directory: /Users/l_turner/dev/wiremock-standalone-docker-example/wiremock/__files to docker files directory: /home/wiremock/__files
Mounting local extensions directory: /Users/l_turner/dev/wiremock-standalone-docker-example/wiremock/extensions to docker extensions directory: /var/wiremock/extensions

Starting Wiremock on port: 7070
2023-10-08 12:29:08.520 Verbose logging enabled
2023-10-08 12:29:09.686 Verbose logging enabled

██     ██ ██ ██████  ███████ ███    ███  ██████   ██████ ██   ██
██     ██ ██ ██   ██ ██      ████  ████ ██    ██ ██      ██  ██
██  █  ██ ██ ██████  █████   ██ ████ ██ ██    ██ ██      █████
██ ███ ██ ██ ██   ██ ██      ██  ██  ██ ██    ██ ██      ██  ██
 ███ ███  ██ ██   ██ ███████ ██      ██  ██████   ██████ ██   ██

----------------------------------------------------------------
|               Cloud: https://wiremock.io/cloud               |
|                                                              |
|               Slack: https://slack.wiremock.org              |
----------------------------------------------------------------

port:                         7070
enable-browser-proxying:      false
disable-banner:               false
no-request-journal:           false
verbose:                      true

extensions:                   response-template,webhook
```

### Docker Compose

This repository contains a docker compose file to start up the wiremock nightly container with the same directory 
mappings as the `start.sh` script.  To use the docker compose file simply run the following command in the root
directory of the repository:

```shell
docker compose up
```

## Testing Wiremock Request/Response

The `tests` folder contains a number of intellij http files that can be used to test the requests and responses from 
the wiremock mappings. The `tests` folder contains a [`README.md`](tests/README.md) file that explains how to use the intellij http files.

