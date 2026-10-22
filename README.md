# Smart City Labor FIWARE Platform

The FIWARE platform of the Smart City Labor (smart city lab) of [SCiLabs](https://github.com/scilabs-bo). It collects, stores and visualizes the data of the sensors in the lab with [FIWARE](https://www.fiware.org/) components. Sensors send their data via LoRaWAN (The Things Network), MQTT or HTTP to IoT Agents. A Scorpio NGSI-LD context broker manages the entities, QuantumLeap stores the time series in TimescaleDB and Grafana shows them in dashboards.

The repository shows the platform as it runs in the lab. Most integrations belong to specific devices (Libelium and Froggit weather stations, Bosch parking sensors, DO300 parking barrier, Zenner and Dragino sensors, eLichens air quality station, a 3D printed miniature house). Without these devices the development stack shows data from a simulated Froggit weather station. The configuration of the devices can serve as an example for your own sensors.

## Contents

- `docker-compose/stack`: the stack with context broker, IoT Agents (JSON, UltraLight, LoRaWAN), QuantumLeap, TimescaleDB, MongoDB, Mosquitto, Node-RED, Grafana, Prometheus, Alertmanager, Traefik, KrakenD, pgAdmin, Portainer and backup/restore services
- `docker-compose/docs`: Docker image for generating the documentation
- `docs`: documentation of the stack, the services and the supported device types
- `http`: example requests for the REST Client extension of VS Code
- `tasks.py`, `subtasks`: [invoke](https://www.pyinvoke.org/) tasks to start and stop the stack

## Getting started

1. Install Docker (see `docs/stack/README.md`). The stack starts about 25 containers, give Docker at least 8 GB of memory.
2. Copy `docker-compose/stack/.env.example` to `docker-compose/stack/.env` and replace the placeholders.
3. Start the development stack in `docker-compose/stack`:

```bash
docker compose -f docker-compose.yml -f docker-compose.development.yml up --build --remove-orphans -d
```

4. Open Grafana at `http://localhost:3000/` and open the dashboard `Wetterstationen Froggit`.

For a production setup see `docs/production-deployment/README.md`. The production stack uses `DOMAIN` from `.env` for all public routes.

## License

MIT, see [LICENSE](LICENSE).

`docker-compose/stack/quantumleap/src/sql_translator.py` is a modified copy from [QuantumLeap](https://github.com/orchestracities/ngsi-timeseries-api) and is also licensed under the MIT License (`docker-compose/stack/quantumleap/LICENSE-quantumleap`).
