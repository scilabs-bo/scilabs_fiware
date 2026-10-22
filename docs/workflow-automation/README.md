---
status: "accepted"
deciders: project team
consulted: project team
informed:
---

# Missing solution for Transformation from HTTP Get to Http Put for the froggit weather station

## Context and Problem Statement

The froggit weather stations send data via a http GET but the IOT Agent JSON expects a POST. Besides the different methods we also have to transform data from get parameters to a mixture of URL parameters and Body parameters.
At a future point in time we would also add the emission stations that should send data that require a custom logic to.

## Decision Drivers

- Free open source solution
- up to date releases / well maintained
- easy to modify without language knowledge
- stable and configurable
- if a login is required we need a ldap support
- configurable and easy to update

## Considered Options

- hardcoded logic in [NestJs](https://nestjs.com/) | [ExpressJS](https://expressjs.com/de/) | [Flask](https://flask.palletsprojects.com/)
- [n8n](https://n8n.io/)
- [Node-Red](https://nodered.org/)

## Decision Outcome

Chosen option: Node-Red, because it is the only option that checks all the boxes and allows us to easily modify the solution or add new flows for different sensors.

### Confirmation

## Pros and Cons of the Options

### Node-Red

- Good, because it is open source
- Good, because is supports variables
- Good, because is well documented
- Good, because is well maintained
- Good, because flows are easy to modify
- Good, because is easy to get started with
- Good, because stable
- Good, because there is ldap support
- Good, because there are a lot of examples
- Neutral, because layout is a little out of date

### n8n

- Good, because flows are easy to modify
- Good, because layout is up to date
- Good, because it is very well maintained
- Good, because it is well documented
- Good, because there are lots of examples
- Good, because is easy to get started with
- Neutral, because there is a community edition
- Bad, because variables are a enterprise feature
- Bad, because ldap is a enterprise feature

### Hardcoded with NestJS|Express|Flask

- Good, because we can actually see, what it is doing in code
- Neutral, because it comes with dependencies we have to update
- Bad, because it requires coding skills
- Bad, because it requires knowledge of the framework
- Bad, because development time will get increased
