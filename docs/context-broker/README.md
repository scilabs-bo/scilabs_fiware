---
status: "accepted"
deciders: project team
consulted:
  - project team
informed:
  - smartcity
---

# Context broker

## Context and Problem Statement

The FIWARE Context Broker is a core component that enables the management and integration of context information in real-time. It allows applications to gather, update, and retrieve context data, facilitating interoperability and data exchange between IoT devices, services, and systems.

Currently there are several alternative implementations of context brokers for the ngsi-ld specification with different feature sets.
ngsi-ld specifies temporal operations, that could make mintaka obsolete.

If we decide to switch to a different context broker we can switch back without to much struggle in the future.

## Decision Drivers

- must be open source
- must support the [`ngsi-ld`](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.02.02_60/gs_CIM009v010202p.pdf) standard
- must be actively maintained
- must not depend on outdated software
- must bring an option for a heath check
- may support the latest Context ICM Spec [1.8.1](https://www.etsi.org/deliver/etsi_gs/CIM/001_099/009/01.08.01_60/gs_cim009v010801p.pdf)
- may support [keycloak](https://www.keycloak.org/) or another authentication solution
- may support [temporal operations](https://ngsi-ld-tutorials.readthedocs.io/en/latest/short-term-history.html)
- may have a good documentation
- may support [subscriptions](https://fiware-tutorials.readthedocs.io/en/latest/subscriptions.html)
- may not fail [ngsi-ld testsuite tests](https://forge.etsi.org/rep/cim/ngsi-ld-test-suite)

## Considered Options

- [Cassiopeia](https://github.com/geonet-mrn/cassiopeia-ngsi-ld-broker)
- [Scorpio](https://github.com/ScorpioBroker/ScorpioBroker)
- [Stellio](https://github.com/stellio-hub/stellio-context-broker)
- [Orion-LD](https://github.com/FIWARE/context.Orion-LD)

## Decision Outcome

Chosen option: "Scorpio", because it supports the most ngsi-ld features. Besides that it defines a all in one image that is easy to include in the current docker compose file.

### Confirmation

{Describe how the implementation of/compliance with the ADR is confirmed. E.g., by a review or an ArchUnit test.
Although we classify this element as optional, it is included in most ADRs.}

<!-- This is an optional element. Feel free to remove. -->

## Pros and Cons of the Options

### Cassiopeia

- Good, because it s released under MIT license

- Bad, because it not active maintained
- Bad, because it is outdated

### Scorpio

- Good, because a lot more active contributors
- Good, because has a all in one Image that only requires a `postgis`/`postgre` service
- Good, used software dependencies are up to date except `postgre`
- Good, only supports `ngsi-ld` as specified in [1.8.1](https://github.com/ScorpioBroker/ScorpioBroker/releases/tag/5.0.2-windows-sqs.exe)
- Good, licensed under `BSD-3` license
- Good, because supports `temporal operations`
- Good, because the Docker image has environment variables for most user and database credentials
- Good, because it supports subscriptions
- Neutral, Grafana can access the data written to the database but the first data dictate the columns types (for example first temp value is 12°C then a column for temp is created with the type bigInt, then the next value comes in with 12.3°C - now scorpio can't store the value and writes null)

- Neutral, because [documentation](https://scorpio.readthedocs.io/en/latest/onepageTutorial.html) has a tutorial but contains lots of dead links
- Neutral, because it is java based
- Neutral, because it does supports authentication via [oauth2](https://github.com/ScorpioBroker/ScorpioBroker/issues/285) but this might not work with the aaio docker image.

- Bad, because there are more docker images online then there is documentation
- Bad, because provided docker compose files depend on a deprecated docker version with docker-compose (Provided Docker Compose contains version information, docs list `docker-compose` instead of `docker compose`, aaio service does not specify heath check and does not come with curl or wget)
- Bad, because official support for [PostgreSQL version 10](https://scorpio.readthedocs.io/en/latest/onepageTutorial.html#setting-up-postgresql) - current version is 16, but works with version 16
- Bad, provided scorpio images do not contain a health check, also there is no curl nor wget in the provided image

### Stellio

- Good, because it supports `temporal operations`
- Good, because is is released under the `apache-2.0` license
- Good, because is active maintained
- Good, because it has `Keycloak` support
- Good, because it supports `subscriptions`
- Good, because official support for postgreSQL 16

- Bad, [documentation](https://stellio.readthedocs.io/en/latest/API_walkthrough.html) not that great
- Bad, it consists out of three services with an additions `postgre` and `kafka`
- Neutral, Grafana can't access the data written to the database since a blob is used, but that prevents the null values described in scorpio and orion-ld
- Bad, supports less [ngsi-ld v1.8.1](https://docs.google.com/spreadsheets/d/e/2PACX-1vRxOjsDf3lqhwuypJ---pZN2OlqFRl0jyoTV0ewQ1WFnpe7xQary3uxRjunbgJkwQ/pub?output=xlsx) features then scorpio.

### Orion-LD

- Good, because is is released under the `AGPL-3.0 license` license
- Good, because it supports `subscriptions`

- Neutral, Grafana can access the data written to the database but the first data dictate the columns types (for example first temp value is 12°C then a column for temp is created with the type bigInt, then the next value comes in with 12.3°C - now scorpio can't store the value and writes null)

- Bad, because it does not support `keycloak`
- Bad, because is maintained but by few persons and there are lots of long term open issues
- Bad, because it depends on outdated software
- Bad, because it supports both `ngsi-ld`(mostly v1.7.1) and `ngsi-v2`(version 2.0)
- Bad, because it does not support `temporal operations`
- Bad, [documentation](https://fiware-orion.readthedocs.io/en/2.3.0/user/walkthrough_apiv2/index.html) not that great, the current version ([4.1.0](https://fiware-orion.readthedocs.io/en/4.1.0/user/walkthrough_apiv2/index.html)) is currently broken
- Bad, is still on an old version of the [ngsi-ld specification](https://docs.google.com/spreadsheets/d/e/2PACX-1vRxOjsDf3lqhwuypJ---pZN2OlqFRl0jyoTV0ewQ1WFnpe7xQary3uxRjunbgJkwQ/pub?output=xlsx)

## More Information

{You might want to provide additional evidence/confidence for the decision outcome here and/or
document the team agreement on the decision and/or
define when/how this decision the decision should be realized and if/when it should be re-visited.
Links to other decisions and resources might appear here as well.}
