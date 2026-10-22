from invoke import task
from subtasks.helper import run, ProjectPath


@task
def start(c):
    """
    Start docker containers.
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml -f docker-compose.development.yml up --pull always --build --remove-orphans -d",
        False,
    )


@task
def startProduction(c):
    """
    Start docker containers without datamock.
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml up --pull always --build --remove-orphans -d",
        False,
    )


@task
def stop(c):
    """
    Stop docker containers.
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml -f docker-compose.development.yml down --remove-orphans",
        False,
    )


@task
def stopProduction(c):
    """
    Start docker containers.
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml down --remove-orphans",
        False,
    )


@task
def remove(c):
    """
    Remove docker containers and volumes.
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml -f docker-compose.development.yml down --remove-orphans -v",
        False,
    )


@task
def removeProduction(c):
    """
    Remove docker containers and volumes.
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml down -v",
        False,
    )


@task
def logs(c, service=""):
    """
    Show logs (use -s / --service to specify logs of service).
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml -f docker-compose.development.yml logs -f {service}",
        False,
    )


@task
def logsProduction(c, service=""):
    """
    Show logs (use -s / --service to specify logs of service).
    """
    run(
        c,
        ProjectPath.DOCKER_COMPOSE_STACK.value,
        f"docker compose -f docker-compose.yml logs -f {service}",
        False,
    )
