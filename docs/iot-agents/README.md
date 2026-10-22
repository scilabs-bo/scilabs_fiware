# IOT Agents

IoT Agents enable the communication between groups of IoT devices and a NGSI Context Broker. The Agents translate the devices´ native protocol into the NGSI context information protocol.  
There are several IoT Agents available, each designed for a specific protocol. They are based on the standard interaction model defined in the [IoT Agent Framework Library](https://github.com/telefonicaid/iotagent-node-lib).  
[List of available Agents](https://github.com/telefonicaid/iotagent-node-lib/tree/master?tab=readme-ov-file#iot-agents-available).

## IoT Agent for JSON

- [Git Repository](https://github.com/telefonicaid/iot-agent-json)
- [Docker](https://quay.io/repository/fiware/iot-agent-json)
- [Documentation](https://fiware-iotagent-json.rtfd.io)

### Configuration

To deploy the IoT Agent for JSON, we utilize a Docker container that can be configured via environment variables. Below are the configuration parameters used in our setup:

| Environment variable   | Value          | Description                                                            |
| ---------------------- | -------------- | ---------------------------------------------------------------------- |
| TZ                     | Europe/Berlin  | Sets the timezone for timestamps                                       |
| IOTA_TIMESTAMP         | true           | Whether to supply timestamp information with each measurement received |
| IOTA_AUTOCAST          | true           | Cast strings to numeric types when possible                            |
| IOTA_CB_HOST           | context-broker | Hostname or IP address of the Context Broker                           |
| IOTA_CB_PORT           | 9090           | Port on which the Context Broker is listening                          |
| IOTA_CB_NGSI_VERSION   | ld             | Specifies the used NGSI version (v2 or ld)                             |
| IOTA_JSON_LD_CONTEXT   | CONTEXT_URL    | URL of the @context file used to define the device data models         |
| IOTA_MONGO_HOST        | mongo-db       | Hostname or IP address of the MongoDB instance                         |
| IOTA_MONGO_PORT        | 27017          | Port on which the MongoDB is listening                                 |
| IOTA_MONGO_USER        | MONGO_USERNAME | Username for MongoDB authentication                                    |
| IOTA_MONGO_PASSWORD    | MONGO_PASSWORD | Password for MongoDB authentication                                    |
| IOTA_MONGO_AUTH_SOURCE | admin          | Database name for MongoDB authentication                               |
| IOTA_MONGO_DB          | iot-agent-json | Database name where device information is stored                       |
| IOTA_HTTP_PORT         | 7896           | Port the IoT Agent listens on for incoming device data                 |
| IOTA_MQTT_DISABLED     | true           | Disables MQTT transport protocol                                       |
| IOTA_AMQP_DISABLED     | true           | Disables AMQP transport protocol                                       |

### Provisioning

There is no guarantee that every supplied IoT device <device-id> will always be unique, therefore all provisioning requests to the IoT Agent require two mandatory headers:

- `fiware-service` (equivalent to `NGSILD-Tenant`) is defined so that entities for a given service can be held in a separate mongoDB database.
- `fiware-servicepath` (equivalent to `NGSILD-Path`) can be used to differentiate between arrays of devices.

For example within a smart city application you would expect different `fiware-service` headers for different departments (e.g. parks, transport, refuse collection etc.) and each `fiware-servicepath` would then refer to specific park and so on.

### Auto provisioning

There is an option to disable the `autoprovisioning` when provisioning a service described in the [api](https://github.com/telefonicaid/iotagent-node-lib/blob/master/doc/api.md#autoprovision-configuration-autoprovision) under the topic `Autoprovision configuration (autoprovision)`. The default value is `true`. If `autoprovisioning` is enabled any not provisioned device for a config group is created by the IOTAgent on reception.

#### Service Provisioning

Before devices can send data, you must provision a service group that defines the context in which devices operate. This is done by sending a POST request to the `/iot/services` endpoint.

Example:

```bash
curl -iX POST 'http://localhost:4041/iot/services' \
-H 'fiware-service: smartcity' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
    "services": [
        {
            "apikey": "exampleKey",
            "entity_type": "Device",
            "resource": "/iot/json",
            "autoprovision": false,
            "attributes": [
                {
                    "object_id": "t",
                    "name": "temperature",
                    "type": "Number"
                }
            ]
        }
    ]
}'
```

- `apikey`: This key is used to uniquely identify this service group. All devices that use this key will be associated with this service group.
- `entityType`: Specifies the type of NGSI-LD entity that represents each device.
- `resource`: The resource path used by devices to send data.
- `attributes`: A list of dynamic attributes the device will report (e.g., temperature, humidity).
- `static_attributes`: Attributes that do not change and provide additional context (such as relationships).

#### Device Provisioning

Each device must be registered with the IoT Agent before it can start sending data. This is achieved by sending a POST request to the `/iot/devices` endpoint.

Example:

```bash
curl -iX POST 'http://localhost:4041/iot/devices' \
-H 'fiware-service: smartcity' \
-H 'fiware-servicepath: /' \
-H 'Content-Type: application/json' \
-d '{
    "devices": [
        {
            "device_id": "temperature001",
            "entity_name": "urn:ngsi-ld:Device:temperature001",
            "apikey": "exampleKey",
            "explicitAttrs": true
        }
    ]
}'
```

- `device_id`: Unique identifier for the device.
- `entity_name`: NGSI-LD URN for the device entity.

[Device datamodel](https://github.com/telefonicaid/iotagent-node-lib/blob/master/doc/api.md#device-datamodel)

###### ExplicitAttrs

There is an option, to enable `explicitAttrs` on devices described in the [api](https://github.com/telefonicaid/iotagent-node-lib/blob/master/doc/api.md#explicitly-defined-attributes-explicitattrs) under the topic `Explicitly defined attributes (explicitAttrs)`. If not enabled a device can send properties that ain't defined in service nor device and those extra values are send to the context broker.

### Sending Measurements to Agent

Once devices are provisioned, they can send their measurements to the IoT Agent, which then forwards the data to the Context Broker.

We can simulate a dummy IoT device measurement coming from the Temperature Sensor device `temperature001` with the following request:

```bash
curl -iX POST 'http://localhost:7896/iot/json?i=temperature001&k=exampleKey' \
-H 'Content-Type: application/json' \
-d '{ "t": 23.5 }'
```

- `i=temperature001`: The device ID (matches the device_id from provisioning).
- `k=exampleKey`: API key for the service group (matches the apikey from service provisioning).

To check if our measurement was recorded we can query the entity data from the context broker:

```bash
curl -G 'http://localhost:1026/ngsi-ld/v1/entities/urn:ngsi-ld:Device:temperature001' \
-H 'NGSILD-Tenant: smartcity' \
-H 'NGSILD-Path: /' \
-H 'Accept: application/ld+json' \
```

### Additional Notes

The definition of every attribute of each device entity should be made available in the supplied @context file.
