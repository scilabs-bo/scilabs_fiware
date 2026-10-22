import { Configuration } from "./types";

const weatherStationRandomNumberProperties = [
  "indoortempf",
  "tempf",
  "dewptf",
  "windchillf",
  "indoorhumidity",
  "humidity",
  "windspeedmph",
  "windgustmph",
  "winddir",
  "absbaromin",
  "baromin",
  "rainin",
  "dailyrainin",
  "weeklyrainin",
  "monthlyrainin",
  "yearlyrainin",
  "solarradiation",
  "UV",
];

export const configuration: Configuration = {
  devices: [
    {
      url: "http://nodered:1880/wunderground",
      interval: 8000,
      randomNumberProperties: weatherStationRandomNumberProperties,
      dateProperties: ["dateutc"],
      staticProperties: [
        {
          key: "ID",
          value: "WS001",
        },
        {
          key: "PASSWORD",
          value: process.env.FROGGIT_API_KEY ?? "",
        },
        {
          key: "realtime",
          value: 1,
        },
        {
          key: "rtfreq",
          value: 5,
        },
        {
          key: "softwaretype",
          value: "EasyWeatherV1.6.9",
        },
      ],
      type: "HttpGet",
    },
    // {
    //   url: "http://172.17.0.1:3800",
    //   interval: 1000,
    //   randomNumberProperties: ["temperature001"],
    //   dateProperties: [],
    //   staticProperties: [
    //     {
    //       key: "i",
    //       value: "WS001",
    //     },
    //     {
    //       key: "k",
    //       value: "testApiKey",
    //     },
    //   ],
    //   type: "IotAgentJson",
    // },
  ],
};
