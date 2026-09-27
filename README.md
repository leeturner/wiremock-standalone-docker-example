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

## Server-Sent Events example: live train departure board

This repo also demonstrates the new Server-Sent Events (SSE) support added in WireMock 4.0.0-beta.39
([wiremock/wiremock#3594](https://github.com/wiremock/wiremock/pull/3594)), using it to drive a fake live
train departure board.

SSE message mappings are a distinct concept from regular stub mappings and are loaded from their own directory:

* local message mappings directory: `./wiremock/message-mappings` is mapped to docker message mappings
  directory: `/home/wiremock/message-mappings`

How it's wired up:

* `wiremock/mappings/train-board.json` opens an SSE channel at `GET /trains/events`, serves the board's web
  page at `GET /train-board`, and defines a `GET /trains/tick` endpoint that cycles through 5 states using a
  WireMock [Scenario](https://wiremock.org/docs/stateful-behaviour/) each time it's called.
* `wiremock/message-mappings/train-board-messages.json` defines one message mapping per tick, each triggered
  by the stub ID of that tick's `/trains/tick` variant, which pushes a fresh set of departures down the open
  SSE channel.
* `wiremock/__files/train-board/index.html` is a single static page that uses the
  [Datastar](https://data-star.dev) library to open the SSE connection (`data-init`) and to poll
  `/trains/tick` every 2 seconds (`data-on-interval`), so the board updates live without any bespoke
  JavaScript.

As of this beta, WireMock's SSE actions only fire in response to a trigger (an incoming HTTP request/stub, or
another message) — there's no built-in "send every N seconds" scheduler. The 2-second cadence here comes
from the browser polling `/trains/tick`, not from WireMock itself.

Start the stack with `docker compose up`, then open **http://localhost:8080/train-board** in a browser.

