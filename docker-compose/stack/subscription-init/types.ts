export interface Subscription {
  id: string;
  description: string;
  type: string;
  entities: Entity[];
  watchedAttributes: string[];
  notification: Notification;
  throttling: number | undefined;
  "@context": string;
}

export interface Entity {
  type: string;
}

export interface Notification {
  attributes: string[];
  format: string;
  endpoint: Endpoint;
}

export interface Endpoint {
  uri: string;
  accept: string;
}

export type CreateSubscription = Omit<Subscription, "id">;
