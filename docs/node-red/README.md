# Credentials in Node-RED

Node-RED stores the credentials of its nodes (MQTT brokers, e-mail input) in `flows_cred.json`. In this project the file holds no secrets. Every credential field only references an environment variable, for example `${MOSQUITTO_PASSWORD}`. Node-RED replaces these references with the values from the container environment when it loads the flows.

## Configuration Details

- `credentialSecret` in `settings.js` is set to `false`, so `flows_cred.json` is stored as plain JSON. This is fine as long as the file only contains `${...}` references.
- The values come from the `.env` file of the stack and are passed to the container in `docker-compose.yml` (service `nodered`).
- The login for the Node-RED editor is read from `NODE_RED_ADMIN_USER` and `NODE_RED_ADMIN_PASSWORD_HASH`. Create the bcrypt hash with `docker run --rm -it --entrypoint npx nodered/node-red:4.0.5-22 node-red admin hash-pw`.

## Example `flows_cred.json`

```json
{
  "d743de38700fe770": {
    "user": "${MOSQUITTO_USERNAME}",
    "password": "${MOSQUITTO_PASSWORD}"
  }
}
```

## Updating Credentials

1. Change the value in the `.env` file of the stack.
2. Restart the Node-RED container:

```bash
docker compose up -d --no-deps nodered
```

If a new node needs credentials, add a new environment variable to `.env.example`, `.env` and the `nodered` service in `docker-compose.yml`. Then enter `${VARIABLE_NAME}` in the credential field of the node in the editor and export the flows. Do not enter real credentials in the editor: with `credentialSecret: false` they would end up in plain text in `flows_cred.json`.
