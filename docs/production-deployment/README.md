# Production Server Deployment

## Table of Contents

1. [Introduction](#introduction)
2. [Updating Ubuntu](#updating-ubuntu)
3. [Installing Docker](#installing-docker)
4. [Configuring Docker without `sudo`](#configuring-docker-without-sudo)
5. [Configuring the Firewall to Allow Ports 80 and 443](#configuring-the-firewall-to-allow-ports-80-and-443)
6. [Deployment](#deployment)
7. [Update deployment](#update-deployment)

---

## Introduction

This documentation outlines the process of preparing and configuring a production server. It includes updating Ubuntu,
installing Docker, configuring Docker to run without `sudo`, and setting up the firewall to allow necessary ports.

---

## Requirements

- Freshly installed [Ubuntu](https://ubuntu.com/about/release-cycle) LTS - 24.04 LTS (Noble Numbat)
- SSH Terminal with permissions to use sudo
- Release.zip containing the stack

---

## Updating Ubuntu

To bring the system up to date, upgrade Ubuntu by following the official guide:

- **Guide:** [How to Upgrade Your Ubuntu Release](https://ubuntu.com/server/docs/how-to-upgrade-your-release)

---

## Installing Docker

Install Docker by following the official documentation:

- **Guide:** [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

---

## Configuring Docker without `sudo`

To enable Docker commands without `sudo`, the deployment user must be added to the `docker` group:

1. **Add the user to the `docker` group:**

   ```bash
   sudo usermod -aG docker <user>
   ```

2. **Log out and log back in** to apply the group changes.

3. **Verify Docker without `sudo`:**

   ```bash
   docker run hello-world
   ```

   - If you see the Docker welcome message, the configuration was successful.

---

## Configuring the Firewall to Allow Ports 80 and 443

To ensure that the server can accept incoming HTTP and HTTPS connections, it is necessary to allow traffic on ports **80
** (HTTP) and **443** (HTTPS) through the firewall.

### Steps to Configure the Firewall

#### 1. Check the Firewall Status

First, verify if the firewall is active:

```bash
sudo ufw status verbose
```

- If the firewall is inactive, you can enable it using:

  ```bash
  sudo ufw enable
  ```

#### 2. Allow Incoming Traffic on Ports 80 and 443

Add rules to allow HTTP and HTTPS traffic:

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

#### 3. Reload the Firewall

Reload the firewall to apply the changes:

```bash
sudo ufw reload
```

#### 4. Verify the New Rules

Check the firewall status again to confirm that the new rules are active:

```bash
sudo ufw status
```

- **Expected Output:**

  ```
  Status: active

  To                         Action      From
  --                         ------      ----
  22/tcp                     ALLOW       Anywhere
  80/tcp                     ALLOW       Anywhere
  443/tcp                    ALLOW       Anywhere
  22/tcp (v6)                ALLOW       Anywhere (v6)
  80/tcp (v6)                ALLOW       Anywhere (v6)
  443/tcp (v6)               ALLOW       Anywhere (v6)
  ```

### Additional Notes

- **Security Considerations:** Opening ports 80 and 443 is standard practice for web servers, but ensure that the
  services running on these ports are secure.

- **ICMP (Ping) Traffic:** If you also need to allow ICMP traffic (e.g., to enable ping responses), you can adjust the
  firewall settings accordingly:

  ```bash
  sudo ufw allow proto icmp
  ```

- **Common Firewall Commands:**

  - **Deny a Port:**

    ```bash
    sudo ufw deny 22/tcp
    ```

  - **Delete a Rule:**

    ```bash
    sudo ufw delete allow 22/tcp
    ```

  - **Reset UFW to Default Settings:**

    ```bash
    sudo ufw reset
    ```

## Deployment

#### To deploy the Application on the Server, please follow the following steps.

### Initial deployment

1. If the release files are not on the server, please create a zip file from the /docker-compose/stack folder. This
   contains all the necessary files for deployment.

2. Copy the Release files on the Server

```bash
scp -i ~/.ssh/your_id_rsa -o "IdentitiesOnly=yes" ./stack.zip  <user>@<server-ip>:/home/<user>/
```

3. Go to your Server and unzip the Release files. In case, **_unzip_** is not installed:

```bash
sudo apt install unzip

unzip stack.zip
```

4. Navigate into the stack folder

```bash
cd stack
```

5. Edit the environment variables in the `.env` file.

There is an .env file in the root directory of the release folder. This file contains environment variables for the
services in the `docker-compose.yml` file. Please edit these with safe values that are valid for a productive environment.

These environment variables are included in `docker-compose` as follows:

```yaml
# ${POSTGRES_PASSWORD} comes from the `.env` file
- POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
```

example content of a `.env`.

```dotenv
MONGO_USERNAME=ReplaceMe
MONGO_PASSWORD=ReplaceMe
POSTGRES_USER=ReplaceMe
POSTGRES_PASSWORD=ReplaceMe
POSTGRES_DB=ReplaceMe
GF_SECURITY_ADMIN_USER=ReplaceMe
GF_SECURITY_ADMIN_PASSWORD=ReplaceMe
MOSQUITTO_USERNAME=ReplaceMe
MOSQUITTO_PASSWORD=ReplaceMe
```

6. execute the following to run the services.

```bash
docker compose up -d
```

### Update deployment

#### to update the services you can just do the same steps as above, and run the following command again.

```bash
docker compose up -d
```
