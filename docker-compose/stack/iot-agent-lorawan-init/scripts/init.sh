#!/bin/sh
IOTA_HOST="http://iot-agent-lorawan:4062"
CBROKER_URL="http://context-broker:9090"
FIWARE_SERVICE=smartcity
FIWARE_SERVICE_PATH=/

echo "Checking environment variables:"
echo "Weather User: $LORA_WEATHER_APPLICATION_USER"
echo "Weather Pass: ${LORA_WEATHER_APPLICATION_PASSWORD:0:5}..." # Zeigt nur erste 5 Zeichen
echo "Parking Lot User: $LORA_PARKING_LOT_APPLICATION_USER"
echo "Parking Lot Pass: ${LORA_PARKING_LOT_APPLICATION_PASSWORD:0:5}..."
echo "Parking Barrier User: $LORA_PARKING_BARRIER_APPLICATION_USER"
echo "Parking Barrier Pass: ${LORA_PARKING_BARRIER_APPLICATION_PASSWORD:0:5}..."
echo ""

echo -e "Cleaning Devices"

## dont fail on error since service might not exist
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/$LORA_WEATHER_DEV_EUI" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/$LORA_PARKING_LOT_DEV_EUI" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
    
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/$LORA_PARKING_BARRIER_DEV_EUI" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/fuellstand-wastebox" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/dragino-wqs-lb-water-1" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

echo -e "\nCreating devices."

# We decided to use devices instead of services, according to the documentation there can only be one:
# config group or device and since we wan t to use location on all devices we go with this solution
# https://github.com/Atos-Research-and-Innovation/IoTagent-LoRaWAN/blob/master/docs/users_manual.md

curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/devices" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH" \
  -d '{
    "devices": [
      {
        "device_id": "'"$LORA_WEATHER_DEV_EUI"'",
        "entity_name": "urn:ngsi-ld:libelium-weather:W001",
        "entity_type": "libelium-weather",
        "timezone": "Europe/Berlin",
        "explicitAttrs": true,
         "attributes": [
          {"object_id": "correctedWindDirection", "name": "correctedWindDirection", "type": "Number"},
          {"object_id": "event", "name": "event", "type": "String"},
          {"object_id": "humidity", "name": "humidity", "type": "Number"},
          {"object_id": "luminosity", "name": "luminosity", "type": "Number"},
          {"object_id": "precipitationIntensity", "name": "precipitationIntensity", "type": "Number"},
          {"object_id": "pressure", "name": "pressure", "type": "Number"},
          {"object_id": "temperature", "name": "temperature", "type": "Number"},
          {"object_id": "windDirection", "name": "windDirection", "type": "Number"},
          {"object_id": "windSpeed", "name": "windSpeed", "type": "Number"}
        ],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.513765,13.422059]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "W001"
          },
          {
              "name": "inactive",
              "type": "Property",
              "value": "false"
          }
        ],
        "internal_attributes": {
            "lorawan": {
                "application_server": {
                    "host": "eu1.cloud.thethings.network",
                    "protocol": "mqtts",
                    "port": 8883,
                    "username": "'"$LORA_WEATHER_APPLICATION_USER"'",
                    "password": "'"$LORA_WEATHER_APPLICATION_PASSWORD"'",
                    "provider": "TTN"
                },
                "app_eui": "'"$LORA_WEATHER_APP_EUI"'",
                "dev_eui": "'"$LORA_WEATHER_DEV_EUI"'",
                "application_id": "'"$LORA_WEATHER_APPLICATION_USER"'",
                "application_key": "'"$LORA_WEATHER_APP_KEY"'",
                "data_model": "application_server"
            }
        }
      },
      {
        "device_id": "'"$LORA_PARKING_LOT_DEV_EUI"'",
        "entity_name": "urn:ngsi-ld:bosch-parking-lot:P001",
        "entity_type": "bosch-parking-lot",
        "timezone": "Europe/Berlin",
        "explicitAttrs": true,
         "attributes": [
          {"object_id": "type", "name": "messageType", "type": "String"},
          {"object_id": "occupied", "name": "occupied", "type": "Boolean"},
          {"object_id": "debugCodes", "name": "debugCodes", "type": "String"},
          {"object_id": "firmwareVersion", "name": "firmwareVersion", "type": "String"},
          {"object_id": "resetCause", "name": "resetCause", "type": "String"}
        ],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.494235,13.398529]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "P001"
          },
          {
              "name": "inactive",
              "type": "Property",
              "value": "false"
          }
        ],
        "internal_attributes": {
            "lorawan": {
                "application_server": {
                    "host": "eu1.cloud.thethings.network",
                    "protocol": "mqtts",
                    "port": 8883,
                    "username": "'$LORA_PARKING_LOT_APPLICATION_USER'",
                    "password": "'$LORA_PARKING_LOT_APPLICATION_PASSWORD'",
                    "provider": "TTN"
                },
                "app_eui": "'"$LORA_PARKING_LOT_APP_EUI"'",
                "dev_eui": "'"$LORA_PARKING_LOT_DEV_EUI"'",
                "application_id": "'"$LORA_PARKING_LOT_APPLICATION_USER"'",
                "application_key": "'"$LORA_PARKING_LOT_APP_KEY"'",
                "data_model": "application_server"
            }
        }
      },
       {
        "device_id": "'"$LORA_PARKING_BARRIER_DEV_EUI"'",
        "entity_name": "urn:ngsi-ld:do300-parking-barrier:PB001",
        "entity_type": "do300-parking-barrier",
        "timezone": "Europe/Berlin",
        "explicitAttrs": true,
         "attributes": [
          {"object_id": "locked", "name": "locked", "type": "Boolean"},
          {"object_id": "online", "name": "online", "type": "Boolean"},
          {"object_id": "occupied", "name": "occupied", "type": "Boolean"},
          {"object_id": "voltage", "name": "voltage", "type": "Number"},
          {"object_id": "batteryCapacity", "name": "batteryCapacity", "type": "Number"}
        ],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.494235,13.398529]
            }
          },
          {
            "name": "deviceId",
            "type": "Property",
            "value": "'"$LORA_PARKING_BARRIER_DEVICE_ID"'"
          },
          {
            "name": "name",
            "type": "Property",
            "value": "PB001"
          },
          {
              "name": "inactive",
              "type": "Property",
              "value": "false"
          }
        ],
        "internal_attributes": {
            "lorawan": {
                "application_server": {
                    "host": "eu1.cloud.thethings.network",
                    "protocol": "mqtts",
                    "port": 8883,
                    "username": "'$LORA_PARKING_BARRIER_APPLICATION_USER'",
                    "password": "'$LORA_PARKING_BARRIER_APPLICATION_PASSWORD'",
                    "provider": "TTN"
                },
                "app_eui": "'"$LORA_PARKING_BARRIER_APP_EUI"'",
                "dev_eui": "'"$LORA_PARKING_BARRIER_DEV_EUI"'",
                "application_id": "'"$LORA_PARKING_BARRIER_APPLICATION_USER"'",
                "application_key": "'"$LORA_PARKING_BARRIER_APP_KEY"'",
                "data_model": "application_server"
            }
        }
      },
       {
        "device_id": "fuellstand-wastebox",
        "entity_name": "urn:ngsi-ld:zenner-wastebox:WB001",
        "entity_type": "zenner-wastebox",
        "timezone": "Europe/Berlin",
        "explicitAttrs": true,
         "attributes": [
            {"object_id": "distance_cm","name":"distance_cm","type":"Number"},
            {"object_id": "error","name":"error","type":"Boolean"}
        ],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.494235,13.398529]
            }
          },
          {
            "name": "deviceId",
            "type": "Property",
            "value": "'$LORA_ZENNER_WASTE_APP_EUI'"
          },
          {
            "name": "name",
            "type": "Property",
            "value": "WB001"
          },
          {
              "name": "inactive",
              "type": "Property",
              "value": "false"
          }
        ],
        "internal_attributes": {
            "lorawan": {
                "application_server": {
                    "host": "eu1.cloud.thethings.network",
                    "protocol": "mqtts",
                    "port": 8883,
                    "username": "'$LORA_ZENNER_WASTE_APPLICATION_USER'",
                    "password": "'$LORA_ZENNER_WASTE_APPLICATION_PASSWORD'",
                    "provider": "TTN"
                },
                "app_eui": "'$LORA_ZENNER_WASTE_APP_EUI'",
                "dev_eui": "'$LORA_ZENNER_WASTE_DEV_EUI'",
                "application_id": "'"$LORA_ZENNER_WASTE_APPLICATION_USER"'",
                "application_key": "'$LORA_ZENNER_WASTE_APP_KEY'",
                "data_model": "application_server"
            }
        }
      },
       {
        "device_id": "dragino-wqs-lb-water-1",
        "entity_name": "urn:ngsi-ld:dragino-wqs:DW001",
        "entity_type": "dragino-wqs",
        "timezone": "Europe/Berlin",
        "explicitAttrs": true,
         "attributes": [
                      {"object_id": "BatV","name":"BatV","type":"Number"},
                     {"object_id": "PH","name":"PH","type":"Number"},
                     {"object_id": "dissolved_oxygen","name":"dissolved_oxygen","type":"Number"},
                     {"object_id": "temp_DS18B20","name":"temp_DS18B20","type":"Number"},
                     {"object_id": "turbidity","name":"turbidity","type":"Number"}
        ],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.494235,13.398529]
            }
          },
          {
            "name": "deviceId",
            "type": "Property",
            "value": "'$LORA_DRAGINO_WQS_APP_EUI'"
          },
          {
            "name": "name",
            "type": "Property",
            "value": "DW001"
          },
          {
              "name": "inactive",
              "type": "Property",
              "value": "false"
          }
        ],
        "internal_attributes": {
            "lorawan": {
                "application_server": {
                    "host": "eu1.cloud.thethings.network",
                    "protocol": "mqtts",
                    "port": 8883,
                    "username": "'$LORA_DRAGINO_WQS_APPLICATION_USER'",
                    "password": "'$LORA_DRAGINO_WQS_APPLICATION_PASSWORD'",
                    "provider": "TTN"
                },
                "app_eui": "'$LORA_DRAGINO_WQS_APP_EUI'",
                "dev_eui": "'$LORA_DRAGINO_WQS_DEV_EUI'",
                "application_id": "'"$LORA_DRAGINO_WQS_APPLICATION_USER"'",
                "application_key": "'$LORA_DRAGINO_WQS_APP_KEY'",
                "data_model": "application_server"
            }
        }
      }
    ]
  }'