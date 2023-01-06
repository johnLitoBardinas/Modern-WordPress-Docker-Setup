
# Bedrock + SAGE10 + COMPOSER v2 + WP CLI + ACORN  Docker Setup

[![Donate](https://img.shields.io/badge/Donation-green?logo=paypal&label=Paypal)](https://www.paypal.me/johnlitob)

Use [BEDROCK](https://roots.io/bedrock/) + [SAGE-10](https://roots.io/sage/) + [ACORN](https://roots.io/acorn/) + [COMPOSER-2+](https://getcomposer.org/) + [WP CLI](https://wp-cli.org/) locally with Docker using [Docker compose](https://docs.docker.com/compose/)

## Contents
+ PHP 8.0
+ MySQL 8.0
+ NGINX 1.22.1
+ Custom domain and HTTPS support. So you can use for example [https://wordpress-docker.local](https://wordpress-docker.test/) in your local machine.
+ Custom nginx config in `./nginx`
+ Custom PHP `php.ini` config in `./config`
+ Volumes for `nginx`, `bedrock` and `mysql8`
+ [Bedrock](https://roots.io/bedrock/) - modern development tools, easier configuration, and an improved secured folder structure for WordPress.
+ [Sage10]()
+ [Composer version 2+](https://getcomposer.org/)
+ [WP-CLI](https://wp-cli.org/) - WP-CLI is the command-line interface for WordPress.

## Instructions

<details>
 <summary>NGINX Setup</summary>

+ [Docker](https://www.docker.com/get-started)
+ [mkcert](https://github.com/FiloSottile/mkcert) for creating the SSL cert.
Install mkcert:

```
brew install mkcert
brew install nss # if you use Firefox
```
+ [NVM](https://github.com/nvm-sh/nvm)

</details>

<details>
 <summary>LOCAL Certificate Setup</summary>

+ [Docker](https://www.docker.com/get-started)
+ [mkcert](https://github.com/FiloSottile/mkcert) for creating the SSL cert.
Install mkcert:

```
brew install mkcert
brew install nss # if you use Firefox
```
+ [NVM](https://github.com/nvm-sh/nvm)

</details>

<details>
 <summary>Requirements</summary>

+ [Docker](https://www.docker.com/get-started)
+ [mkcert](https://github.com/FiloSottile/mkcert) for creating the SSL cert.
Install mkcert:

```
brew install mkcert
brew install nss # if you use Firefox
```
+ [NVM](https://github.com/nvm-sh/nvm)

</details>

<details>
 <summary>Setup</summary>

 ### Setup Environment variables

Both step 1. and 2. below are required:

#### 1. For Docker and the CLI script (Required step)

Copy `.env.example` in the project root to `.env` and edit your preferences.

Example:

```dotenv
IP=127.0.0.1
APP_NAME=myapp
DOMAIN="myapp.local"
DB_HOST=mysql
DB_NAME=myapp
DB_ROOT_PASSWORD=password
DB_TABLE_PREFIX=wp_
```

#### 2. For WordPress (Required step)

Edit `./src/.env.example` to your needs. During the `composer create-project` command described below, an `./src/.env` will be created.

Example:

```dotenv
DB_NAME='myapp'
DB_USER='root'
DB_PASSWORD='password'

# Optionally, you can use a data source name (DSN)
# When using a DSN, you can remove the DB_NAME, DB_USER, DB_PASSWORD, and DB_HOST variables
# DATABASE_URL='mysql://database_user:database_password@database_host:database_port/database_name'

# Optional variables
DB_HOST='mysql'
# DB_PREFIX='wp_'

WP_ENV='development'
WP_HOME='https://myapp.local'
WP_SITEURL="${WP_HOME}/wp"
WP_DEBUG_LOG=/path/to/debug.log

# Generate your keys here: https://roots.io/salts.html
AUTH_KEY='generateme'
SECURE_AUTH_KEY='generateme'
LOGGED_IN_KEY='generateme'
NONCE_KEY='generateme'
AUTH_SALT='generateme'
SECURE_AUTH_SALT='generateme'
LOGGED_IN_SALT='generateme'
NONCE_SALT='generateme'
```

</details>

<details>
 <summary>Option 1). Use HTTPS with a custom domain</summary>

1. Create a SSL cert:

```shell
cd cli
./create-cert.sh
```

This script will create a locally-trusted development certificates. It requires no configuration.

> mkcert needs to be installed like described in Requirements. Read more for [Windows](https://github.com/FiloSottile/mkcert#windows) and [Linux](https://github.com/FiloSottile/mkcert#linux)

1b. Make sure your `/etc/hosts` file has a record for used domains.

```
sudo nano /etc/hosts
```

Add your selected domain like this:

```
127.0.0.1 myapp.local
```

2. Continue on the Install step below

</details>

<details>
 <summary>Option 2). Use a simple config</summary>

1. Edit `nginx/default.conf.conf` to use this simpler config (without using a cert and HTTPS)

```shell
server {
    listen 80;

    root /var/www/html/web;
    index index.php;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    client_max_body_size 100M;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}

```

2. Edit the nginx service in `docker-compose.yml` to use port 80. 443 is not needed now.

```shell
  nginx:
    image: nginx:latest
    container_name: ${APP_NAME}-nginx
    ports:
      - '80:80'

```

3. Continue on the Install step below

</details>

<details>
 <summary>Install</summary>

```shell
docker-compose run composer create-project
```

</details>

<details>
 <summary>Run</summary>

```shell
docker-compose up
```

Docker Compose will now start all the services for you:

```shell
Starting myapp-mysql    ... done
Starting myapp-composer ... done
Starting myapp-phpmyadmin ... done
Starting myapp-wordpress  ... done
Starting myapp-nginx      ... done
Starting myapp-mailhog    ... done
```

🚀 Open [https://myapp.local](https://myapp.local) in your browser

## PhpMyAdmin

PhpMyAdmin comes installed as a service in docker-compose.

🚀 Open [http://127.0.0.1:8082/](http://127.0.0.1:8082/) in your browser

## MailHog

MailHog comes installed as a service in docker-compose.

🚀 Open [http://0.0.0.0:8025/](http://0.0.0.0:8025/) in your browser

</details>

<details>
 <summary>Tools</summary>

### Update WordPress Core and Composer packages (plugins/themes)

```shell
docker-compose run composer update
```

#### Use WP-CLI

```shell
docker exec -it myapp-wordpress bash
```

Login to the container

```shell
wp search-replace https://olddomain.com https://newdomain.com --allow-root
```

Run a wp-cli command

> You can use this command first after you've installed WordPress using Composer as the example above.

### Update plugins and themes from wp-admin?

You can, but I recommend to use Composer for this only. But to enable this edit `./src/config/environments/development.php` (for example to use it in Dev)

```shell
Config::define('DISALLOW_FILE_EDIT', false);
Config::define('DISALLOW_FILE_MODS', false);
```

### Useful Docker Commands

When making changes to the Dockerfile, use:

```bash
docker-compose up -d --force-recreate --build
```

Login to the docker container

```shell
docker exec -it myapp-wordpress bash
```

Stop

```shell
docker-compose stop
```

Down (stop and remove)

```shell
docker-compose down
```

Cleanup

```shell
docker-compose rm -v
```

Recreate

```shell
docker-compose up -d --force-recreate
```

Rebuild docker container when Dockerfile has changed

```shell
docker-compose up -d --force-recreate --build
```
</details>

<details>
<summary>Changelog</summary>

#### 2023-01-06
- Include and setup the phpmyadmin container linked to mysql container.

#### 2023-01-05
- Add a volume from nginx/logs (container) to ./nginx(host) directory.

</details>

----

_By:_ [JLBardinas](https://www.jlbardinas.com)