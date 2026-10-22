import argparse
import requests
import json
import time
from datetime import datetime, timezone
import random
import logging


class NgsiLdEntity:
    def __init__(self, id, temperature, humidity, coordinates, timestamp):
        self.id = id
        self.type = "Device"
        self.temperature = {"type": "Property", "value": temperature}
        self.humidity = {"type": "Property", "value": humidity}
        self.location = {
            "type": "GeoProperty",
            "value": {"type": "Point", "coordinates": coordinates},
        }
        self.timestamp = {"type": "Property", "value": timestamp}


def generate_entities(device_count):
    entities = []
    for i in range(device_count):
        entity = NgsiLdEntity(
            id=f"urn:ngsi-ld:froggit-wh-4000-se:{i + 1:03}",
            temperature=20 + (random.random() * 5),
            humidity=80 + (random.random() * 5),
            coordinates=[
                51.4485 + (random.random() / 1000),
                7.2765 + (random.random() / 1000),
            ],
            timestamp=datetime.now(timezone.utc).isoformat(),
        )
        entity_dict = entity.__dict__
        entity_dict["@context"] = [
            "http://context-hoster/ngsi-ld-core-context-v1.8.jsonld"
        ]
        entities.append(entity_dict)
    return entities


def send_data_to_context_broker(url, headers, data, debug):
    try:
        print(url)
        response = requests.post(url, headers=headers, data=json.dumps(data))
        if response.status_code in [200, 201, 204, 207]:
            if debug:
                logging.info("Data successfully sent to FIWARE Context Broker.")
        else:
            logging.error(
                f"\033[91mError sending data: {response.status_code} - {response.reason}\033[0m"
            )
            logging.error(f"\033[91mResponse content: {response.text}\033[0m")
        return response
    except requests.RequestException as e:
        logging.error(f"\033[91mRequest failed: {e}\033[0m")
        return None


def retrieve_entities(base_url):
    try:
        print(base_url)
        get_url = f"{base_url}/ngsi-ld/v1/entities/?type=Device&options=sysAttrs"
        headers = {"Accept": "application/ld+json"}
        get_response = requests.get(get_url, headers=headers)

        if get_response.status_code == 200:
            logging.info("Entity retrieved successfully.")
            return get_response.json()
        else:
            logging.error(
                f"\033[91mError retrieving entity: {get_response.status_code} - {get_response.reason}\033[0m"
            )
            logging.error(f"\033[91mResponse content: {get_response.text}\033[0m")
    except requests.RequestException as e:
        logging.error(f"\033[91mRequest failed: {e}\033[0m")
    return None


def main():
    parser = argparse.ArgumentParser(
        description="Send and retrieve NGSI-LD entities to/from a FIWARE Context Broker."
    )
    parser.add_argument(
        "--base-url",
        required=True,
        help="Base URL of the FIWARE Context Broker",
    )
    parser.add_argument(
        "--device-count",
        type=int,
        default=2,
        help="Number of devices per request (default: 2)",
    )
    parser.add_argument(
        "--interval",
        type=int,
        default=5,
        help="Interval in seconds between requests (default: 5)",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug mode to print generated JSON and retrieved entities",
    )

    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO)

    context_broker_url = f"{args.base_url}/ngsi-ld/v1/entityOperations/upsert"

    headers = {"Accept": "application/ld+json", "Content-Type": "application/ld+json"}
    logging.info(
        "Sending %d entities to scorpio : %s every %ds",
        args.device_count,
        args.base_url,
        args.interval,
    )

    while True:
        entities = generate_entities(args.device_count)
        if args.debug:
            logging.info("Generated JSON:")
            logging.info(json.dumps(entities, indent=2))

        response = send_data_to_context_broker(
            context_broker_url, headers, entities, args.debug
        )

        if response and args.debug:
            entity_data = retrieve_entities(args.base_url)
            if entity_data:
                logging.info("Retrieved Entities with Context:")
                logging.info(json.dumps(entity_data, indent=2))

        time.sleep(args.interval)


if __name__ == "__main__":
    main()
