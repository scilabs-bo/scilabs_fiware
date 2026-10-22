from invoke import task
from subtasks.helper import run, ProjectPath

DOCKER_IMAGE = "smart-city-docs:latest"


@task
def build(c):
    """
    Build docs docker image locally.
    """
    run(c, ProjectPath.ROOT.value, f"docker build -t {DOCKER_IMAGE} docker-compose/docs")


@task
def generate(c):
    """
    Build docs with pandoc.
    """
    cmd = f'docker run --rm --volume "./:/home/user" {DOCKER_IMAGE} docs/generate.py'
    run(c, ProjectPath.ROOT.value, cmd)
