# Virtual Tribunals

An Arclight-based discovery application for materials from the Virtual Tribunals project

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
## Index seed data
You can seed the index with `rake vt:seed`. This loads data from our `spec/fixtures` directory. It is a vastly reduced (200K vs 1K lines of XML) version of the collection EAD file, which should be representative of different media types, series, subseries, date formats, etc. The fulltext transcript files associated with the items in `seed.xml` are also stored in our fixtures; these files will be indexed for fulltext search.

You can always delete the current index with `rake arclight:destroy_index_docs`.

## Index data from records stored in ArchivesSpace

### Required environment variables
Making requests to the ArchivesSpace endpoints via rake task requires that certain environment variables are set. Locally you can pass them on the command line or set them up another way. On staging and production servers, they are stored and accessible.
- `ASPACE_URL`
- `ASPACE_USER`
- `ASPACE_PASSWORD`

You can get the values of Vault by running the following (stage example):
```shell
vault kv get puppet/application/vt/stage/aspace_url
vault kv get puppet/application/vt/stage/aspace_user
vault kv get puppet/application/vt/stage/aspace_password
```

### Requesting ASpace data and indexing it
1. Collection data is stored in the `public/data` directory. It may not be the lastest data uploaded to ArchivesSpace, but it is useable for indexing in step 4 below. If you're fine with using this data skip to step 4. 

2. If you want to download the latest data and overwrite the file in `public/data` follow these steps. Find out the ID of the Resource and its Resository that you want in ArchivesSpace. Repository refers to internal SUL organization. On the staging ArchivesSpace server, for now we can assume the Repository ID is `18`, for Virtual Tribunals.

    "Resource" is the name for top level containers in ArchivesSpace. The Resource ID is the permanent identifier we use for the collection. It's the same as the PURL and won't change: `mt839rq8746`

3. Download the EAD for a specific Resource. This will download EAD to our `/data` folder with the Resource ID as the filename, e.g. `/data/mt839rq8746.xml`. You can use the following command. When trying to pass arguments to a rake task in the form of `[arg1,arg2]`, it seems my zsh shell requires escaping the brackets:
    ```shell
    rake vt:download_resource\[18,mt839rq8746\]           
    ```

    Locally with passing env variables, the command could like like this:
    ```shell
     ASPACE_URL=http://spec-as-stage.stanford.edu:8089 ASPACE_USER=<xxx> ASPACE_PASSWORD=<xxx> rake vt:download_resource\[18,mt839rq8746\]  
     ```
4. Index the file.
    ```shell
     rake vt:index 
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
