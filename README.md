# FIWARE-based Smart City Platform – SCiLabs

This repository provides the resources you need to build your own Smart City platform. It is a contribution of the Bochum University of Applied Sciences, Professorship for Urban Energy and Mobility Systems, led by Haydar Mecit. His R&D team developed these resources to realize a collaborative R&D lab, the Smart City Labs (SCiLabs; in German “Smart City Forschungslabor”).

The platform is based on open-source technologies provided by the FIWARE Foundation. In the same open-source spirit, you are welcome to use the technologies we developed for your own purposes and for the public good.

The platform collects, stores and visualizes data from sensors installed in living labs (for example, IoT devices such as weather stations placed in public spaces of a city) using FIWARE components. Sensors send their data via LoRaWAN (The Things Network), MQTT or HTTP to so-called IoT Agents. A Scorpio NGSI-LD context broker manages the entities, QuantumLeap stores the time series in TimescaleDB, and Grafana displays them in dashboards. Besides environmental and mobility data, the dashboards can also show smart energy data from prosumer homes, such as photovoltaic generation, battery state of charge, heat pump power and household consumption.

The repository shows the platform as it runs in our Smart City lab. Most integrations are specific to particular devices: Libelium and Froggit weather stations, Bosch parking sensors, a DO300 parking barrier, Zenner and Dragino sensors, an eLichens air quality station and a 3D-printed miniature house. Without these devices, the development stack shows data from a simulated Froggit weather station. The device configurations can serve as examples for your own sensors.

We gratefully acknowledge the funding by the German Federal Ministry of Research, Technology and Space (BMFTR), funding number 13FH0I93IA, which made this work possible.

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
