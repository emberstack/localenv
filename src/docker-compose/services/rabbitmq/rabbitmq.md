## Default Definitions

Default users:
- `admin`
    - tags: administrator
    - password: `SuperPass123#`
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

## Plugins

Enabled via `config/enabled_plugins` (mounted over the image default, so `rabbitmq_management` must stay in the list):
- `rabbitmq_management` + `rabbitmq_prometheus` (image defaults)
- `rabbitmq_shovel` + `rabbitmq_shovel_management` - move/replay messages between queues (e.g. from a `*_error` queue back to its endpoint queue). Create dynamic shovels under `Admin > Shovel Management`; status under `Admin > Shovel Status`.

## Utilities

#### Generating a new password hash
```powershell
docker run --rm -it rabbitmq:management rabbitmqctl hash_password <password>
```

#### Import additional definitions
```powershell
docker run --rm --network localenv -v /path/to/definitions.json:/definitions.json --entrypoint /bin/sh rabbitmq:management -c "rabbitmqadmin --host rabbitmq -u <username> -p <password> import /definitions.json"
```
