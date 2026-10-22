#!/bin/sh
IOTA_HOST="http://iot-agent-json:4041"
CBROKER_URL="http://context-broker:9090"
FIWARE_SERVICE=smartcity
FIWARE_SERVICE_PATH=/


echo "Cleaning Services"

## dont fail on error since service might not exist
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/services?resource=/iot/json&apikey=$FROGGIT_API_KEY" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/services?resource=/iot/json&apikey=waterLevelApiKey" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/services?resource=/iot/json&apikey=airApiKey" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
    
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/services?resource=/iot/json&apikey=energyApiKey" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

echo -e "\nCleaning Devices"

## dont fail on error since service might not exist

for i in $(seq 0 2);
do
    for j in $(seq 0 9);
    do
        curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/WS0$i$j" \
            -H "fiware-service: $FIWARE_SERVICE" \
            -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
    done
done

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/WS099" \
            -H "fiware-service: $FIWARE_SERVICE" \
            -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/WS055" \
            -H "fiware-service: $FIWARE_SERVICE" \
            -H "fiware-servicepath: $FIWARE_SERVICE_PATH"


curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LOAD10000000001" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LOAD10000000002" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LOAD10000000003" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LOAD10000000004" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LEVEL10097" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LEVEL10030" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/LEVEL10109" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"
curl --silent --show-error -X DELETE "$IOTA_HOST/iot/devices/AQS001" \
    -H "fiware-service: $FIWARE_SERVICE" \
    -H "fiware-servicepath: $FIWARE_SERVICE_PATH"

echo -e "\nCreating config groups"

# use "type": "**Number**" for jsonb in db
curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/services" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH" \
  -d '{
    "services": [
      {
        "apikey": "'"$FROGGIT_API_KEY"'",
        "cbroker": "'"$CBROKER_URL"'",
        "entity_type": "froggit-wh-4000-se",
        "resource": "/iot/json",
        "autoprovision": false,
        "explicitAttrs": true,
        "attributes": [
          {"object_id": "indoortempf", "name": "indoorTemperature", "type": "Float", "expression": "(indoortempf-32)*5/9"},
          {"object_id": "tempf", "name": "temperature", "type": "Float", "expression": "(tempf-32)*5/9"},
          {"object_id": "dewptf", "name": "dewPoint", "type": "Float", "expression": "(dewptf-32)*5/9"},
          {"object_id": "windchillf", "name": "windChill", "type": "Float", "expression": "(windchillf-32)*5/9"},
          {"object_id": "indoorhumidity", "name": "indoorHumidity", "type": "Float"},
          {"object_id": "humidity", "name": "relativeHumidity", "type": "Float"},
          {"object_id": "windspeedmph", "name": "windSpeed", "type": "Float", "expression": "windspeedmph*0.44704"},
          {"object_id": "windgustmph", "name": "gustSpeed", "type": "Float", "expression": "windgustmph*0.44704"},
          {"object_id": "winddir", "name": "windDirection", "type": "Float"},
          {"object_id": "absbaromin", "name": "atmosphericPressure", "type": "Float", "expression": "absbaromin*33.86388"},
          {"object_id": "baromin", "name": "barOMin", "type": "Float"},
          {"object_id": "rainin", "name": "precipitation", "type": "Float", "expression": "precipitation*25.4"},
          {"object_id": "dailyrainin", "name": "dailyRainIn", "type": "Float"},
          {"object_id": "weeklyrainin", "name": "weeklyRainIn", "type": "Float"},
          {"object_id": "monthlyrainin", "name": "monthlyRainIn", "type": "Float"},
          {"object_id": "yearlyrainin", "name": "yearlyRainIn", "type": "Float"},
          {"object_id": "solarradiation", "name": "solarRadiation", "type": "Float"},
          {"object_id": "UV", "name": "uvIndex", "type": "Float"},
          {"object_id": "dateutc", "name": "dateObserved", "type": "DateTime", "expression": "substr(dateutc, 0, 10)}Tsubstr(dateutc, 11, 8)Z"},
          {"object_id": "realtime", "name": "realTime", "type": "Float"},
          {"object_id": "rtfreq", "name": "rtFreq", "type": "Float"},
          {"object_id": "softwaretype", "name": "softwareType", "type": "String"}
        ]
      },
      {
        "apikey": "energyApiKey",
        "cbroker": "'"$CBROKER_URL"'",
        "entity_type": "energy-meter",
        "resource": "/iot/json",
        "autoprovision": false,
        "explicitAttrs": true,
        "attributes": [
          { "object_id": "meterPoint", "name": "meterPoint", "type": "String" },
          { "object_id": "timestamp", "name": "timestamp", "type": "DateTime" },
          { "object_id": "activeConsumption", "name": "activeConsumption", "type": "Float" },
          { "object_id": "statusActiveConsumption", "name": "statusActiveConsumption", "type": "Boolean" },
          { "object_id": "reactiveConsumption", "name": "reactiveConsumption", "type": "Float" },
          { "object_id": "statusReactiveConsumption", "name": "statusReactiveConsumption", "type": "Boolean" },
          { "object_id": "activeFeed", "name": "activeFeed", "type": "Float" },
          { "object_id": "statusActiveFeed", "name": "statusActiveFeed", "type": "Boolean" },
          { "object_id": "reactiveFeed", "name": "reactiveFeed", "type": "Float" },
          { "object_id": "statusReactiveFeed", "name": "statusReactiveFeed", "type": "Boolean" }
        ]
      },
      {
        "apikey": "waterLevelApiKey",
        "cbroker": "'"$CBROKER_URL"'",
        "entity_type": "water-level-sensor",
        "resource": "/iot/json",
        "autoprovision": false,
        "explicitAttrs": true,
        "attributes": [
          {"object_id": "address", "name": "address", "type": "String"},
          {"object_id": "levelId", "name": "levelId", "type": "String"},
          {"object_id": "name", "name": "name", "type": "String"},
          {"object_id": "location", "name": "location", "type": "GeoProperty"},
          {"object_id": "dateWaterLevel", "name": "dateWaterLevel", "type": "String"},
          {"object_id": "waterLevel", "name": "waterLevel", "type": "Float", "expression": "waterLevel*0.01"},
          {"object_id": "waterLevelWarning", "name": "waterLevelWarning", "type": "String"},
          {"object_id": "dateDischarge", "name": "dateDischarge", "type": "String"},
          {"object_id": "discharge", "name": "discharge", "type": "Float", "expression": "discharge*0.01"},
          {"object_id": "dischargeWarningLevel", "name": "dischargeWarningLevel", "type": "String"},
          {"object_id": "hasCurrentWaterLevel", "name": "hasCurrentWaterLevel", "type": "Boolean"},
          {"object_id": "hasCurrentDischarge", "name": "hasCurrentDischarge", "type": "Boolean"}    
        ]
      },
      {
        "apikey": "airApiKey",
        "cbroker": "'"$CBROKER_URL"'",
        "entity_type": "air-quality-station",
        "resource": "/iot/json",
        "autoprovision": false,
        "explicitAttrs": true,
        "attributes": [
          {"object_id": "ambientLight", "name": "ambientLight", "type": "Float"},
          {"object_id": "atmosphericPressure", "name": "atmosphericPressure", "type": "Float"},
          {"object_id": "batteryCharge", "name": "batteryCharge", "type": "Float"},
          {"object_id": "carbonDioxide", "name": "carbonDioxide", "type": "Float"},
          {"object_id": "deviceStatus", "name": "deviceStatus", "type": "String"},
          {"object_id": "externalTemperature", "name": "externalTemperature", "type": "Float"},
          {"object_id": "internalTemperature", "name": "internalTemperature", "type": "Float"},
          {"object_id": "meanSeaLevelPressure", "name": "meanSeaLevelPressure", "type": "Float"},
          {"object_id": "nitrogenDioxide", "name": "nitrogenDioxide", "type": "Float"},
          {"object_id": "ozone", "name": "ozone", "type": "Float"},
          {"object_id": "particulateMatter1_0", "name": "particulateMatter1_0", "type": "Float"},
          {"object_id": "particulateMatter10", "name": "particulateMatter10", "type": "Float"},
          {"object_id": "particulateMatter2_5", "name": "particulateMatter2_5", "type": "Float"},
          {"object_id": "relativeHumidity", "name": "relativeHumidity", "type": "Float"},
          {"object_id": "soundLevel", "name": "soundLevel", "type": "Float"},
          {"object_id": "timestamp", "name": "timestamp", "type": "DateTime"}
        ]
      }
    ]
  }'

echo -e "\nCreating devices."

curl --fail-with-body --silent -X POST "$IOTA_HOST/iot/devices" \
  -H "Content-Type: application/json" \
  -H "fiware-service: $FIWARE_SERVICE" \
  -H "fiware-servicepath: $FIWARE_SERVICE_PATH" \
  -d '{
    "devices": [
      {
        "device_id": "WS001",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS001",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.492353,13.451471]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 001"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS002",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS002",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.535176,13.380098]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 002"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS003",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS003",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.500824,13.451078]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 003"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS004",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS004",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.544118,13.36951]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 004"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS005",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS005",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.534,13.391078]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 005"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS006",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS006",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.517765,13.413431]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 006"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS007",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS007",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.525059,13.445196]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 007"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS008",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS008",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.538235,13.397745]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 008"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS009",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS009",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.528824,13.378529]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 009"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS010",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS010",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.542235,13.435]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 010"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS011",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS011",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.540824,13.359706]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 011"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS012",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS012",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.505529,13.377745]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 012"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS013",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS013",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.545059,13.392255]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 013"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS014",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS014",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.548588,13.415392]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 014"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS015",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS015",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.497529,13.390686]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 015"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS016",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS016",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.514706,13.445196]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 016"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS017",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS017",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.510235,13.407941]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 017"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS055",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS055",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.495176,13.420098]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 055"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS018",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS018",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.516824,13.358922]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 018"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS019",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS019",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [0,0]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 019"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS020",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS020",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.529294,13.417353]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 020"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS021",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS021",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.527176,13.391078]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 021"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS022",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS022",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.512353,13.371078]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 022"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS023",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS023",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [0,0]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 023"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS024",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS024",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [52.500118,13.42598]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 024"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "WS025",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS025",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [0,0]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 025"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS026",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS026",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [0,0]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 026"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS027",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS027",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [0,0]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 027"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "WS099",
        "entity_name": "urn:ngsi-ld:froggit-wh-4000-se:WS099",
        "entity_type": "froggit-wh-4000-se",
        "apikey": "'"$FROGGIT_API_KEY"'",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "location",
            "type": "GeoProperty",
            "value": {
              "type": "Point",
              "coordinates": [0,0]
            }
          },
          {
            "name": "name",
            "type": "Property",
            "value": "Wetterstation 099"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "true"
          }
        ]
      },
      {
        "device_id": "LOAD10000000001",
        "entity_name": "urn:ngsi-ld:energy-meter:LOAD10000000001",
        "entity_type": "energy-meter",
        "apikey": "energyApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "name",
            "type": "Property",
            "value": "Messstelle 10000000001"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "LOAD10000000002",
        "entity_name": "urn:ngsi-ld:energy-meter:LOAD10000000002",
        "entity_type": "energy-meter",
        "apikey": "energyApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "name",
            "type": "Property",
            "value": "Messstelle 10000000002"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "LOAD10000000003",
        "entity_name": "urn:ngsi-ld:energy-meter:LOAD10000000003",
        "entity_type": "energy-meter",
        "apikey": "energyApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "name",
            "type": "Property",
            "value": "Messstelle 10000000003"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "LOAD10000000004",
        "entity_name": "urn:ngsi-ld:energy-meter:LOAD10000000004",
        "entity_type": "energy-meter",
        "apikey": "energyApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "attributes": [],
        "static_attributes": [
          {
            "name": "name",
            "type": "Property",
            "value": "Messstelle 10000000004"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "LEVEL10097",
        "entity_name": "urn:ngsi-ld:water-level-sensor:LEVEL10097",
        "entity_type": "water-level-sensor",
        "apikey": "waterLevelApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "static_attributes": [
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "LEVEL10030",
        "entity_name": "urn:ngsi-ld:water-level-sensor:LEVEL10030",
        "entity_type": "water-level-sensor",
        "apikey": "waterLevelApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "static_attributes": [
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "LEVEL10109",
        "entity_name": "urn:ngsi-ld:water-level-sensor:LEVEL10109",
        "entity_type": "water-level-sensor",
        "apikey": "waterLevelApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
        "static_attributes": [
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      },
      {
        "device_id": "AQS001",
        "entity_name": "urn:ngsi-ld:air-quality-station:AQS001",
        "entity_type": "air-quality-station",
        "apikey": "airApiKey",
        "transport": "HTTP",
        "timezone": "Europe/Berlin",
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
            "value": "Emissionsstation 1"
          },
          {
            "name": "inactive",
            "type": "Property",
            "value": "false"
          }
        ]
      }
    ]
  }'
