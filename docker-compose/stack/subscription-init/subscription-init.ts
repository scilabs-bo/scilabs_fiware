import { subscriptionsToCreate } from "./subscriptions";
import { Subscription } from "./types";
import axios from "axios";

const baseUrl = process.env.BASE_URL;
const notificationEndpointUrl = process.env.NOTIFICATION_ENDPOINT_URL;

if (baseUrl === undefined || baseUrl === "") {
  throw new Error("Please provide context broker base url!");
}

if (notificationEndpointUrl === undefined || notificationEndpointUrl === "") {
  throw new Error("Please provide notification endpoint url!");
}

console.log(`Context broker base URL: ${baseUrl}`);

const deleteSubscriptions = async () => {
  const subscriptions = await axios.get<Subscription[]>(
    `${baseUrl}/ngsi-ld/v1/subscriptions`
  );

  console.log(
    `Found ${subscriptions.data.length} existing subscriptions to delete`
  );

  for (const subscription of subscriptions.data) {
    await axios.delete(
      `${baseUrl}/ngsi-ld/v1/subscriptions/${subscription.id}`
    );

    console.log(`Deleted subscription "${subscription.description}"`);
  }

  console.log(`Found ${subscriptionsToCreate.length} subscriptions to create`);

  for (const subscriptionToCreate of subscriptionsToCreate) {
    subscriptionToCreate.notification.endpoint.uri = notificationEndpointUrl;

    await axios.post(
      `${baseUrl}/ngsi-ld/v1/subscriptions`,
      subscriptionToCreate,
      {
        headers: {
          "Content-Type": "application/ld+json",
          "NGSILD-Tenant": "smartcity",
          "NGSILD-Path": "/",
        },
      }
    );

    console.log(`Created subscription "${subscriptionToCreate.description}"`);
  }
};

deleteSubscriptions();
