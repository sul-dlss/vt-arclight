# Nurembeg Trial Archive

An Arclight-based discovery application for materials from the Nuremberg Trial

## Install
```
bundle
yarn
```


## Start solr
First start solr.
```shell
bundle exec solr_wrapper
```
Index all the data in the `/data` folder. NOTE: for test purposes we are saying that NTA data is part of `sul-spec` repository because it is a required field, this will change.
```shell
rake arclight:index_dir DIR=data REPOSITORY_ID=sul-spec           
```

## Start the app

### Locally
Then in another terminal, start the app:
```shell
bin/dev
```
A server will start with the application on port 3000.

### OR with Docker
You can start the application by running:
```
docker compose up
```
Then point your browser at http://localhost:3000/
