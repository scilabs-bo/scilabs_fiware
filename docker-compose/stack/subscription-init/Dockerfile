FROM node:20.18

WORKDIR /app

COPY package.json .
COPY package-lock.json .

RUN npm i

COPY . .

ENV BASE_URL=http://context-broker:9090
ENV NOTIFICATION_ENDPOINT_URL=http://quantumleap:8668/v2/notify

CMD npm start