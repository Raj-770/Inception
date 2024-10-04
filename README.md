<div align="center">
  <h1>
    Inception
  </h1>
  <p>
    <b><i>
      Set up for a small infrastructure composed of Wordpress with LEMP Stack using Docker Containers
    </i></b>
  </p>
  <p>
    <a href="https://skillicons.dev">
      <img src="https://skillicons.dev/icons?i=linux,docker,mysql,nginx,php,wordpress" />
    </a>
  </p>
</div>

## Overview

A Docker-based setup for deploying a small infrastructure composed of WordPress with a LEMP stack (Linux, Nginx, MariaDB, PHP) using Docker containers. This project automates the process of setting up a WordPress site with Nginx as the web server, MariaDB as the database server, and PHP-FPM for processing PHP files.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Configuration](#configuration)
  - [Build and Run](#build-and-run)
- [Services Overview](#services-overview)
  - [Nginx](#nginx)
  - [MariaDB](#mariadb)
  - [WordPress](#wordpress)
- [Docker Compose Details](#docker-compose-details)
- [Environment Variables](#environment-variables)
- [Makefile Targets](#makefile-targets)
- [Volumes and Networking](#volumes-and-networking)
- [Troubleshooting](#troubleshooting)
- [Acknowledgments](#acknowledgments)

## Features

- Automated setup of WordPress with Nginx, MariaDB, and PHP-FPM using Docker containers.
- SSL encryption using a self-signed certificate generated with OpenSSL.
- Custom Nginx configuration supporting HTTPS and HTTP/2.
- Persistent storage using Docker volumes for WordPress and MariaDB data.
- Environment variable configuration for sensitive data using a `.env` file.
- Makefile for easy management of Docker containers and resources.

## Technologies Used

- **Docker**: Containerization platform for packaging applications.
- **Docker Compose**: Tool for defining and running multi-container Docker applications.
- **Nginx**: High-performance HTTP server and reverse proxy.
- **MariaDB**: Community-developed fork of MySQL relational database management system.
- **PHP-FPM**: FastCGI Process Manager for handling PHP scripts.
- **WordPress**: Popular open-source content management system.
- **WP-CLI**: Command-line interface for WordPress administration.

## Prerequisites

- **Docker Engine** installed on your system.
- **Docker Compose** installed on your system.
- Basic understanding of Docker and Docker Compose.
- **Git** (optional, for cloning the repository).

## Project Structure

```
.
├── docker-compose.yml
├── Makefile
├── .env
├── requirements
│   ├── nginx
│   │   ├── Dockerfile
│   │   └── conf
│   │       └── nginx.conf
│   ├── mariadb
│   │   ├── Dockerfile
│   │   ├── conf
│   │   │   └── 99-server.cnf
│   │   └── tools
│   │       └── init_mariadb.sh
│   └── wordpress
│       ├── Dockerfile
│       └── tools
│           └── setup.sh
└── data
    ├── mariadb (created at runtime)
    └── wordpress (created at runtime)
```

- **docker-compose.yml**: Defines services, volumes, and networks.
- **Makefile**: Contains commands to manage the Docker environment.
- **.env**: Contains environment variables for configuration.
- **requirements/**: Directory containing service-specific Dockerfiles and configurations.
- **data/**: Directory where Docker volumes mount data for persistence.

## Getting Started

### Configuration

1. **Clone the Repository** (if applicable):

   ```bash
   git clone https://github.com/yourusername/wordpress-lemp-docker.git
   cd wordpress-lemp-docker
   ```

2. **Create the `.env` File**:

   Create a `.env` file in the root directory with the following content. Replace the placeholder values with your desired configurations.

   ```dotenv
   # Database Configuration
   DB_NAME=wp_database
   DB_USER=wp_user
   DB_PASSWORD=wp_secure_pass123
   ROOT_PASSWORD=rootSecure!456

   # WordPress Configuration
   WP_URL=https://yourdomain.com
   WP_TITLE=Your Site Title
   WP_ADMIN_NAME=adminUser
   WP_ADMIN_PASS=strongAdminPass!789
   WP_ADMIN_EMAIL=admin@yourdomain.com

   # Additional WordPress User
   WP_USER_NAME=editorUser
   WP_USER_EMAIL=editor@yourdomain.com
   WP_USER_PASS=editorPass!101
   ```

   > **Note**: Ensure that the email addresses for the admin and additional user are different to avoid conflicts during WordPress setup.

3. **Adjust Volume Paths**:

   In the `docker-compose.yml` file, adjust the volume paths under `driver_opts` to match your system's directory structure. Ensure the directories exist or create them accordingly.

   ```yaml
   volumes:
     wordpress:
       driver_opts:
         device: /home/<YourUsername>/data/wordpress
     mariadb:
       driver_opts:
         device: /home/<YourUsername>/data/mariadb
   ```

### Build and Run

Use the provided Makefile to manage the Docker environment.

- **Build and Start Containers**:

  ```bash
  make up
  ```

- **Check Container Status**:

  ```bash
  make status
  ```

- **Stop Containers**:

  ```bash
  make stop
  ```

- **Start Containers**:

  ```bash
  make start
  ```

- **Stop and Remove Containers**:

  ```bash
  make down
  ```

- **Clean Up Docker Resources**:

  ```bash
  make clean
  ```

## Services Overview

### Nginx

- **Dockerfile Path**: `requirements/nginx/Dockerfile`
- **Base Image**: `debian:buster`
- **Installed Packages**:
  - `nginx`
  - `openssl`
- **Configuration**:
  - Generates a self-signed SSL certificate.
  - Custom `nginx.conf` to support HTTPS and PHP processing.
- **Exposed Port**: `443`

### MariaDB

- **Dockerfile Path**: `requirements/mariadb/Dockerfile`
- **Base Image**: `debian:buster`
- **Installed Packages**:
  - `mariadb-server`
  - `mariadb-client`
- **Configuration**:
  - Custom `99-server.cnf` for MariaDB settings.
  - Initialization script `init_mariadb.sh` to set up the database and user.
- **Exposed Port**: `3306`

### WordPress

- **Dockerfile Path**: `requirements/wordpress/Dockerfile`
- **Base Image**: `debian:buster`
- **Installed Packages**:
  - `php-fpm`
  - `php-mysql`
  - `curl`
- **Configuration**:
  - Installs WP-CLI for WordPress management.
  - Modifies PHP-FPM to listen on port `9000`.
  - Setup script `setup.sh` to install and configure WordPress.
- **Exposed Port**: `9000`

## Docker Compose Details

The `docker-compose.yml` file defines the services, networks, and volumes.

- **Services**:
  - `nginx`: Depends on `wordpress`, exposes port `443`.
  - `wordpress`: Depends on `mariadb`.
  - `mariadb`: Database service.

- **Networks**:
  - `inception`: A bridge network connecting all services.

- **Volumes**:
  - `wordpress`: Mounted to `/var/www/html` in `nginx` and `wordpress`.
  - `mariadb`: Mounted to `/var/lib/mysql` in `mariadb`.

```yaml
services:
  nginx:
    build: ./requirements/nginx/.
    ports:
      - "443:443"
    depends_on:
      - wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - inception
    env_file:
      - .env

  wordpress:
    build: ./requirements/wordpress/.
    depends_on:
      - mariadb
    volumes:
      - wordpress:/var/www/html
    env_file:
      - .env
    networks:
      - inception

  mariadb:
    build: ./requirements/mariadb/.
    volumes:
      - mariadb:/var/lib/mysql
    env_file:
      - .env
    networks:
      - inception

volumes:
  wordpress:
    driver: local
    driver_opts:
      device: /home/<YourUsername>/data/wordpress
      o: bind
      type: none
  mariadb:
    driver: local
    driver_opts:
      device: /home/<YourUsername>/data/mariadb
      o: bind
      type: none

networks:
  inception:
    driver: bridge
```

## Environment Variables

Sensitive data and configuration parameters are stored in the `.env` file.

- **Database Configuration**:
  - `DB_NAME`
  - `DB_USER`
  - `DB_PASSWORD`
  - `ROOT_PASSWORD`

- **WordPress Configuration**:
  - `WP_URL`
  - `WP_TITLE`
  - `WP_ADMIN_NAME`
  - `WP_ADMIN_PASS`
  - `WP_ADMIN_EMAIL`

- **Additional WordPress User**:
  - `WP_USER_NAME`
  - `WP_USER_EMAIL`
  - `WP_USER_PASS`

> **Important**: Do not push the `.env` file to any public repository to avoid exposing sensitive information.

## Makefile Targets

Simplify Docker operations using the Makefile.

- **Build and Start All Containers**:

  ```bash
  make up
  ```

- **Stop and Remove All Containers**:

  ```bash
  make down
  ```

- **Stop Containers**:

  ```bash
  make stop
  ```

- **Start Containers**:

  ```bash
  make start
  ```

- **Show Container Status**:

  ```bash
  make status
  ```

- **Clean Containers, Images, and Volumes**:

  ```bash
  make clean
  ```

- **Remove All Docker Images**:

  ```bash
  make clean-images
  ```

- **Remove All Docker Volumes**:

  ```bash
  make clean-volumes
  ```

- **Full Clean and System Prune**:

  ```bash
  make fclean
  ```

- **Reset Project Data**:

  ```bash
  make reset
  ```

- **Help**:

  ```bash
  make help
  ```

## Volumes and Networking

### Volumes

- **Purpose**: Persist data between container restarts and maintain data on the host system.
- **Configured Paths**:
  - WordPress data: `/home/<YourUsername>/data/wordpress`
  - MariaDB data: `/home/<YourUsername>/data/mariadb`
- **Driver Options**:
  - `device`: Host path to mount.
  - `o`: Mount options, `bind` indicates a bind mount.
  - `type`: Set to `none` for a simple bind mount.

### Networks

- **Network Name**: `inception`
- **Driver**: `bridge`
- **Purpose**: Isolate the container network and allow inter-service communication.

## Troubleshooting

- **Adjusting Volume Paths**: Ensure the directories specified in the `device` option of volumes exist on your host machine. Create them if they do not.

  ```bash
  mkdir -p /home/<YourUsername>/data/wordpress
  mkdir -p /home/<YourUsername>/data/mariadb
  ```

- **Environment Variables Not Loaded**: Ensure the `.env` file is in the correct location and properly formatted.

- **Permission Issues**: If you encounter permission issues with mounted volumes, adjust the permissions on the host directories.

  ```bash
  sudo chown -R $USER:$USER /home/<YourUsername>/data/
  ```

- **SSL Certificate Warnings**: Browsers will warn about the self-signed SSL certificate. For testing purposes, you can proceed by accepting the risk.

- **Ports Already in Use**: If port `443` or `3306` is already in use on your host machine, adjust the `ports` mapping in the `docker-compose.yml` file.

## Acknowledgments

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress Documentation](https://wordpress.org/support/)
- [WP-CLI Documentation](https://wp-cli.org/)

---

Happy coding!