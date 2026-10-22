import { Property } from "./types";

const getRandomNumber = (
  min: number,
  max: number,
  type: "int" | "float"
): number => {
  if (type === "int") {
    const minCeiled = Math.ceil(min);
    const maxFloored = Math.floor(max);
    return Math.floor(Math.random() * (maxFloored - minCeiled) + minCeiled);
  }
  return Math.random() * (max - min) + min;
};

const buildNumberProperties = (ids: string[]): Property[] => {
  let measurements: Property[] = [];

  for (const id of ids) {
    measurements.push({
      key: id,
      value: getRandomNumber(50, 80, "float").toFixed(0),
    });
  }

  return measurements;
};

const buildDateProperties = (ids: string[]): Property[] => {
  let measurements: Property[] = [];

  let date = new Date();

  for (const id of ids) {
    measurements.push({
      key: id,
      value: `${date.getFullYear()}-${date.getMonth()}-${date.getDay()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`,
    });
  }

  return measurements;
};

export const getProperties = (
  randomNumberProperties: string[],
  dateProperties: string[],
  staticProperties: Property[]
): Property[] => {
  let properties = buildNumberProperties(randomNumberProperties);

  for (const property of buildDateProperties(dateProperties)) {
    properties.push(property);
  }

  for (const property of staticProperties) {
    properties.push(property);
  }

  return properties;
};

export const buildUrl = (url: string, properties: Property[]): string => {
  let result: string = url;

  for (let [index, entry] of properties.entries()) {
    if (index == 0) {
      result += "?";
    } else {
      result += "&";
    }
    result += entry.key + "=" + entry.value;
  }

  return result;
};
