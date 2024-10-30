# postgraphile-playground


NOTE: superseeded by https://github.com/alexisrolland/docker-postgresql-postgraphile



see: https://github.com/graphile/postgraphile

## node.js : install + use
```
$ nvm install v10.15.1
$ nvm use v10.15.1
```

## postgres-db
```
# start
$ make db-local.up
# stop
$ make db-local.down
# stop + remove volumes
$ make db-local.down.v
```

## postgraphile: install
```
$ yarn add postgraphile
```

## postgraphile: run 
```

$ make postgraphile.up DB_URI=postgres:postgres@localhost/app

```


