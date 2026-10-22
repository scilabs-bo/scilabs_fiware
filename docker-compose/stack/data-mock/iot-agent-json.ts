import axios from "axios";
import { buildUrl, getProperties } from "./functions";
import { DeviceConfiguration } from "./types";

// const apiKey = "test";
// const agentBaseUrl = "http://localhost:4041/iot/";
// const httpEndpointUrl = "http://localhost:7896/iot/json";

export class IotAgentJson {
  mockDevice(configuration: DeviceConfiguration) {
    console.info("Setting up services");
    try {
      axios.post(
        `${configuration.url}/services`,
        {
          services: [],
        },
        {
          headers: {
            "content-type": "application/ld+json",
            "fiware-service": "smartcity",
            "fiware-servicepath": "/",
          },
        }
      );
    } catch (error) {
      console.error(error);
    }

    console.info("Setting up devices");
    try {
      axios.post(
        `${configuration.url}/devices`,
        {
          devices: [],
        },
        {
          headers: {
            "content-type": "application/ld+json",
            "fiware-service": "smartcity",
            "fiware-servicepath": "/",
          },
        }
      );
    } catch (error) {
      console.error(error);
    }

    console.info(
      `Devices are sending measurements every ${
        configuration.interval / 1000
      } seconds`
    );

    setInterval(() => {
      try {
        const url = buildUrl(configuration.url, configuration.staticProperties);
        axios.post(
          url,
          getProperties(
            configuration.randomNumberProperties,
            configuration.dateProperties,
            []
          )
        );
      } catch (error) {
        console.error(error);
      }
    }, configuration.interval);
  }
}
