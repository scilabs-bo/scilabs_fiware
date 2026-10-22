from invoke import Collection

from subtasks import docker_compose_stack, docs

ns = Collection()
ns.add_collection(docs, "docs")
ns.add_collection(docker_compose_stack, "dev")
