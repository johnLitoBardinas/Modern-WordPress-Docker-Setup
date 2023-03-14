
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

+ If you have a [BedRock](https://roots.io/bedrock/) already running then replace the ```./bedrock``` folder inside the project.

#### 1. For Docker and the CLI script.

Copy `.env.example` in the project root to `.env` and edit by your preferences.

Example:

```dotenv
IP=127.0.0.1
APP_NAME=myapp
DOMAIN="myapp.local"

DB_HOST=mysql
DB_NAME=template_db
DB_USER=admin
DB_USER_PASSWORD=secret
DB_ROOT_PASSWORD=secret
DB_TABLE_PREFIX=wp_

```

#### 2. WordPress Bedrock

Edit `./bedrock/.env.example` to your needs.

Example:

```dotenv
DB_NAME='template_db'
DB_USER='admin'
DB_PASSWORD='secret'

# Optionally, you can use a data source name (DSN)
# When using a DSN, you can remove the DB_NAME, DB_USER, DB_PASSWORD, and DB_HOST variables
# DATABASE_URL='mysql://database_user:database_password@database_host:database_port/database_name'

# Optional variables
DB_HOST='mysql'
# DB_PREFIX='wp_'

WP_ENV='development'
WP_HOME='{DOMAIN}'
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
<summary>Hosts File Setup</summary>

+ For __(Mac, Linux)__ use the ```nano``` text editor.
```bash
sudo nano /etc/hosts
# Edit the hosts file of your machine to serve local website.

# Enter computer password if prompted.

127.0.0.1 {DOMAIN} www.{DOMAIN}
# Replace the {DOMAIN} same with your own .env DOMAIN key.
# Add the above statement in the very bottom of the hosts file.
```

+
</details>

<details>
<summary>Local Certificate Setup</summary>

+ Create a __```certs```__ folder inside the ```./nginx``` folder then __```cd```__ into it to store the local site certificates.

```bash
mkcert
# Verify that the mkcert is available.
# Usage of mkcert:

#	$ mkcert -install
#	Install the local CA in the system trust store.

#	$ mkcert example.org
#	Generate "example.org.pem" and "example.org-key.pem".

#	$ mkcert example.com myapp.dev localhost 127.0.0.1 ::1
#	Generate "example.com+4.pem" and "example.com+4-key.pem".

#	$ mkcert "*.example.it"
#	Generate "_wildcard.example.it.pem" and "_wildcard.example.it-key.pem".

#	$ mkcert -uninstall
#	Uninstall the local CA (but do not delete it).


mkcert {DOMAIN}
# Replace the {DOMAIN} same with your own .env DOMAIN key.

# If the generation is successfull then 2 *.pem file will be present now.

````

+ Using the __./nginx/default-example.conf__ create a __```./nginx/default.conf```__ file and populate the necessary fields. Replace __```{DOMAIN}```__ to your own domain name.

+ __```{DOMAIN}```__ variable can be found /in the following Line Number: 3, 45, 83, 84.


</details>

<details>
 <summary>Run</summary>

```shell
docker-compose up
```

Docker Compose will now start all the services for you:

```shell
Starting myapp-mysql    ... done
Starting myapp-phpmyadmin    ... done
Starting myapp-php    ... done
Starting myapp-nginx    ... done
Starting myapp-wp-cli    ... done
Starting myapp-composer    ... done
```

🚀 Open [https://{DOMAIN}](https://{DOMAIN}) in your browser

## PhpMyAdmin

To us phpMyAdin just visit the following URL.

🚀 Open [http://127.0.0.1:8082/](http://127.0.0.1:8082/) in your browser

</details>

<details>
 <summary>Tools</summary>

### Usage Composer inside the container

```shell
docker-compose run --rm composer {command}
```

#### Use WP-CLI

```shell
docker-compose run --rm wp {command}
```

### Use Acorn
```shell
docker-compose run --rm wp acorn {command}
```

### Useful Docker Commands

Building again container from updated Docker Image.

```bash
docker-compose up --build
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
docker-compose --rmi=local -v
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
<summary>SAGE + ACORN Setup</summary>

+ Inside the __```./bedrock```__ directory. Run the following command:
```bash
composer require roots/acorn
```

+ Install the __[SAGE-10](https://roots.io/sage/)__ theme using the following command:

```bash
docker-compose run --rm composer create-project roots/sage {template_name} --working-dir=web/app/themes/
```

+ Verify your __[ACORN](https://roots.io/acorn/)__ Installation by running the following command:

```bash
docker-compose run --rm wp acorn
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
