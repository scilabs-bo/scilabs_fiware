import axios from "axios";
import { buildUrl, getProperties } from "./functions";
import { DeviceConfiguration, Property } from "./types";

export class HttpGetMock {
  public mockDevice(configuration: DeviceConfiguration) {
    console.info(
      `Sending properties every ${configuration.interval / 1000} seconds.`
    );

    setInterval(async () => {
      try {
        let properties: Property[] = getProperties(
          configuration.randomNumberProperties,
          configuration.dateProperties,
          configuration.staticProperties
        );

        await axios.get(buildUrl(configuration.url, properties), {
          headers: {
            Accept: "*/*",
            Connection: "close",
          },
        });
      } catch (error) {
        console.error(error);
      }
    }, configuration.interval);
  }
}
