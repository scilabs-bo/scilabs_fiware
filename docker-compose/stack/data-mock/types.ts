export type DeviceProtocol = "HttpGet" | "IotAgentJson";

export type Property = {
  [key: string]: string | number;
};

export type DeviceConfiguration = {
  interval: number;
  url: string;
  type: DeviceProtocol;
  randomNumberProperties: string[];
  dateProperties: string[];
  staticProperties: Property[];
};

export interface Configuration {
  devices: DeviceConfiguration[];
}
