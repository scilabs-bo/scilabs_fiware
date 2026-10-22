---
status: "accepted"
deciders: project team
consulted:
  - project team
informed:
  - smartcity
---

# Decision for a GUI Tool for Managing Docker Containers and Stacks

## Context and Problem Statement

We need a user-friendly tool to manage Docker containers and Stacks. The goal is to simplify the management, monitoring, and deployment of containers to increase efficiency and optimize operations.

## Decision Drivers

- User-friendliness and ease of use
- Support for LDAP authentication
- Comprehensive management and monitoring features
- Good documentation and community support

## Considered Options

- Portainer
- DockGE

## Decision Outcome

Chosen option: "Portainer", because it offers comprehensive management and monitoring of all Docker stacks, regardless of how they were created. Additionally, it has a large and active community, supports LDAP integration, and provides a user-friendly interface.

### Consequences

- Good, because Portainer allows centralized management of all stacks and offers extensive monitoring and integration features.
- Bad, because there may be higher resource requirements and a steeper learning curve compared to simpler tools like DockGE.

## Pros and Cons of the Options

### Portainer

- Good, because it supports management of Docker and Kubernetes environments.
- Good, because it has LDAP support for enterprise-level authentication.
- Good, because it integrates with Git repositories for stack management.
- Neutral, because it requires some initial setup and configuration.
- Bad, because it might require more resources and training.

### DockGE

- Good, because it provides a straightforward interface for Docker Compose management.
- Good, because it has LDAP support for authentication.
- Neutral, because it is less comprehensive but simpler to use.
- Bad, because it only shows stacks created within DockGE and lacks broader management features.
- Bad, because it has a smaller community and fewer resources available.

## More Information

For further details, see the official documentation for [Portainer](https://www.portainer.io/documentation) and [DockGE](https://dockge.kuma.pet/).
