import { configuration } from "./configuration";
import { HttpGetMock } from "./http-get-mock";
import { IotAgentJson } from "./iot-agent-json";

console.info("Starting Mocking Service");

for (const device of configuration.devices) {
  switch (device.type) {
    case "HttpGet":
      const httpGetMock = new HttpGetMock();
      httpGetMock.mockDevice(device);
      break;
    case "IotAgentJson":
      const iotAgentMock = new IotAgentJson();
      iotAgentMock.mockDevice(device);
      break;
    default:
      console.warn(`unsupported device type: ${device.type} found!`);
      throw Error("Configuration error");
  }
}
