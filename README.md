# Gateway

Ties every service together.

## How to run

A lot of these steps are the same as in individual services.

### Generate RSA keys

You must generate RSA keys for grants and public token.

```sh
# grants keys
openssl genrsa -out grants_private_key.pem 2048
openssl rsa -pubout -in grants_private_key.pem -out grants_public_key.pem
# public token keys
openssl genrsa -out public_token_private_key.pem 2048
openssl rsa -pubout -in public_token_private_key.pem -out public_token_public_key.pem
```

### Download required files

Clone the repo:

```sh
git clone --recursive https://github.com/Pokedex-gamba/gateway.git
```

### Edit compose files

Compose files are setup to just work so you don't really need to edit them.

Main compose file is `docker-compose.yaml`, other included files are located in `compose-files` folder. If you decide to edit these files, then most of the comments and other config variables are removed. You can look for them in repos with similar names to figure out what you can edit.

### Encoding and decoding keys

All mounts are setup to point to specific key names. If you followed chapter `Generate RSA keys`, then your commands will look similar to the commands bellow.\
Make sure the names of files to be linked and the link names are the same for keys to be linked correctly.

```sh
# navigate from parent folder containing keys to folder containing this repo
cd gateway
# correctly link keys
ln -s ../grants_private_key.pem ./grants_encoding_key
ln -s ../grants_public_key.pem ./grants_decoding_key
ln -s ../public_token_private_key.pem ./token_encoding_key
ln -s ../public_token_public_key.pem ./token_decoding_key
```

### Finally start it

```sh
docker compose up -d
```

## How to use

Each service has it's own server name in nginx so you need to match it to make requests to it.\
For that you only need to set the `Host` header to the right value.

`Host` header value can be found in server configs.\
These configs are located in `server-configs` folder.

### Authorization

Any request to any service is authorized through public token, that you (most of the time) need to have.\
Without public token you are just a guest user and have very limited access.

First you need to register or login to get your public token.\
You then put this token into your `Authorization` header (in bearer format) and use this public token to make all your requests.

For user that has all grants you can use this login info:
```json
{
    "email": "root@root.root",
    "password": "toor"
}
```

### Debug info

In some services you can enabled `DEBUG`, then you will get debug responses from those services.\
Some also enable `/docs` endpoint so don't forget to check it out!\
If you want to access docs endpoints in your browser you need to either add server names in your hosts file or in your dns server.\
Or you can go to `/SERVICE_NAME/docs`.

Testing requests also works just set token to public token you get from login.\
It works by pulling service name from `Referer` header if it exists
or you just can set `X-Host` header or `Host` header if it's allowed (in browsers it is not allowed).\
`Host` and `X-Host` header will always override `Referer` header.

You can also get grants token by sending request to `/token/authorize` with `Authorization` header set to public token in bearer format.

#### Disabling debug and docs endpoint

If you want to disable debug and `/docs` endpoints, then go into `compose-files` and in each file look for `DEBUG` environmental variable and delete it (if it has one). After that you want to delete include for docs override in `server-configs/default-server.conf`.
