## Default Definitions

Default users:
- `admin`
    - tags: administrator
    - password: `SuperPass#`
- `localenv`
    - tags: -
    - password: `localenv`

Default vhosts:
- `/`
    - users:
        - admin
- `localenv`
    - users:
        - admin
        - localenv

## Utilities

#### Generating a new password hash
```powershell
docker run --rm -it rabbitmq:management rabbitmqctl hash_password <password>
```

#### Import additional definitions
```powershell
docker run --rm --network localenv -v /path/to/definitions.json:/definitions.json --entrypoint /bin/sh rabbitmq:management -c "rabbitmqadmin --host rabbitmq -u <username> -p <password> import /definitions.json"
```
