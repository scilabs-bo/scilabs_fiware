# Development

There are a few requirements and guidelines that have to be followed to getting started with development for this project.
To make the initial setup as easy as possible we use a workspace definition containing recommended extensions and their settings.

## Requirements

**[Invoke](https://docs.pyinvoke.org/en/latest/)**

Invoke is used to manage all available commands for development. You can list available commands with: `inv -l`.

### Linux

```shell
sudo apt install python3 python3-pip python3-invoke -y
```

Once all requirements are installed we need to reopen the terminal.
> Install [shell tab completion](https://docs.pyinvoke.org/en/latest/invoke.html#shell-tab-completion)

### Windows

- Download & install Python https://www.python.org/downloads/
  - Enable "Add python.exe to PATH" during setup
- Execute in shell: `python -m pip install invoke`

## docker-compose

Start (the first start will download all docker images and can take a few minutes):

The grafana dashboard will be available at http://localhost:3000/.

```shell
inv dev.start
```

Stop:

```shell
inv dev.stop
```

Show logs:

```shell
inv dev.logs
```

Remove docker containers and volumes:

```shell
inv dev.remove
```

## Documentation

All work steps and decisions must be documented with a corresponding justification.
Documentation is stored in this repository under `/docs/{theme}` as a Markdown file.
For submission, the documentation must be available as [docx](https://support.microsoft.com/de-de/office/wissenswertes-zu-dateiformaten-56dc3b55-7681-402e-a727-c59fa0884b30) files. For this purpose, a new job is to be set up on the pipeline, which converts all markdown files when changes are made in the `/docs` folder and makes them available as artifacts.
A particular challenge is the use of [Mermaid](https://github.com/mermaid-js/mermaid) for charts.

### Technology decisions

We added a template for the documentation of technology decisions under: `/docs-template/adr`
