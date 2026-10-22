FROM python:3.12

WORKDIR /app

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

ENV BASE_URL=http://context-broker:9090
ENV DEVICE_COUNT=2
ENV INTERVAL=1

CMD python fiware_data_generator.py --base-url ${BASE_URL} --device-count ${DEVICE_COUNT} --interval ${INTERVAL}