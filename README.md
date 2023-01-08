
# Modern WordPress Setup
#### Bedrock, Sage 10, Composer v2, WP CLI, and Acorn Docker setup for local development.

[![Donate](https://img.shields.io/badge/Donation-green?logo=paypal&label=Paypal)](https://www.paypal.me/johnlitob)

###### Technologies and Tools Included:
* [NGINX](https://www.nginx.com/)
* [PHP-8](https://www.php.net/)
* [MySQL-8](https://www.mysql.com/)
* [phpMyAdmin](https://www.phpmyadmin.net/)
* [BEDROCK](https://roots.io/bedrock/)
* [SAGE-10](https://roots.io/sage/)
* [ACORN](https://roots.io/acorn/)
* [COMPOSER-2](https://getcomposer.org/)
* [WP CLI](https://wp-cli.org/)

_All of the above are not required for your local machine to be installed. Just install [Docker Desktop](https://www.docker.com/products/docker-desktop/)._

## Requirements:
* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [MKCERT](https://github.com/FiloSottile/mkcert) </br>
_for MAC use [HomeBrew](https://brew.sh/)_
```bash
# For MAC Installation.
brew install mkcert
brew install nss # if you use Firefox

# To confirm the installation.
mkcert
```

* [NVM](https://github.com/nvm-sh/nvm) - Needed to proxy the web server.

---

## Instructions

<details>
<summary>Root Directory Setup</summary>

+ Create a .env file in the root directory using the .env-example file as a example.

+ If you have a [BedRock](https://roots.io/bedrock/) already running then replace the ```./bedrock``` folder inside the project.
</details>

<details>
<summary>Hosts File Setup</summary>

+ For (Mac, Linux) use the ```nano``` text editor.
```bash
sudo nano /etc/hosts
# Edit the hosts file of your machine to serve local website.

# Enter computer password if prompted.

127.0.0.1 wordpress-docker.test www.wordpress-docker.test
# Add the above statement in the very bottom of the hosts file.
```

</details>

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
