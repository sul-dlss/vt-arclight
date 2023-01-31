# Virtual Tribunals
[![Ruby on Rails CI](https://github.com/sul-dlss/vt-arclight/actions/workflows/rubyonrails.yml/badge.svg)](https://github.com/sul-dlss/vt-arclight/actions/workflows/rubyonrails.yml)

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

We also added a `video.xml` file in fixtures that only contains the records/druids for the 37 items with video. This was useful for example in testing whether transcript harvesting worked on the videos, rather than harvesting from the entire collection.

You can always delete the current index with `rake arclight:destroy_index_docs`.

## Data from ArchivesSpace

We store EAD XML generated from ArchivesSpace in `public/data/mt839rq8746.xml`. `mt839rq8746` is the druid associated with the Nuremberg collection, and we use it as a permanent identifier in ArchivesSpace. `mt839rq8746.xml` contains all the records in the Nuremberg Trial collection, around 9,000 records. We pull the file from SUL's production instance of ArchivesSpace (http://spec-as-prod.stanford.edu:8080/). A staging instance (http://spec-as-stage.stanford.edu:8080/) also exists; you can use this to experiment, but the files we commit to this repository should be downloaded from production.

### How to download mt839rq8746.xml
Making requests to the ArchivesSpace endpoints via rake task requires certain environment variables be set. Locally you can pass them on the command line or set them up another way. On our `vt-stage` and `vt-prod` servers running this application, these env vars are stored and accessible. Both `vt-stage` and `vt-prod` are set in Vault to point to `http://spec-as-prod.stanford.edu` (production ArchivesSpace) as the source for their EAD. The following variables are needed to perform the download:

- `ASPACE_URL`
- `ASPACE_USER`
- `ASPACE_PASSWORD`

You can get these values from Vault by running the following (stage example):
```shell
vault kv get puppet/application/vt/<stage or prod>/aspace_url
vault kv get puppet/application/vt/<stage or prod>/aspace_user
vault kv get puppet/application/vt/<stage or prod>/aspace_password
```

If you want to download the latest data and overwrite the file in `public/data` follow these steps:

1. Find out the ID of the Resource and its Resository that you want in ArchivesSpace. Repository refers to internal SUL organization. On the production ArchivesSpace server, the Repository ID is `18`, for Virtual Tribunals. "Resource" is the name for top level containers in ArchivesSpace. The Resource ID is the permanent identifier we use for the collection. It's the same as the druid and won't change: `mt839rq8746`

2. Run the download task -- it takes resource and repository as arguments. When trying to pass arguments to a rake task in the form of `[arg1,arg2]`, it seems my zsh shell requires escaping the brackets:
    ```shell
    rake vt:download_resource\[18,mt839rq8746\]           
    ```

    Locally with passing env variables, the command should look like this:
    ```shell
     ASPACE_URL=http://spec-as-prod.stanford.edu:8089 ASPACE_USER=<xxx> ASPACE_PASSWORD=<xxx> rake vt:download_resource\[18,mt839rq8746\]  
     ```
### How to index mt839rq8746.xml

Now that the new copy of `mt839rq8746` is downloaded, we can index it.

3. Index the file.
    ```shell
     rake vt:index 
    ```
4. If indexing on a remote server, we need to clear the caches:
   ```shell
    cap prod remote_execute["cd vt/current; RAILS_ENV=production bin/rails r 'Rails.cache.clear'"]
   ```

Here is an example of indexing new data onto a remote server. Make sure the SOLR_URL in the last step actually matches your index.
```shell
cap stage deploy # put latest EAD file onto the server
cap stage ssh
SOLR_URL=http://sul-solr.stanford.edu/solr/nta-arclight-stage/ RAILS_ENV=production bin/rails arclight:destroy_index_docs vt:index
RAILS_ENV=production bin/rails r 'Rails.cache.clear'
```

Most likely you will be reindexing the EAD XML, and not the full text files, as those are fairly static. You can skip the slow processing involved with re-indexing fulltext by commenting out the `to_field 'full_text_tesimv'` block in `lib/traject/vt_component_config.rb`.

### Note on the data in ArchivesSpace
The data we upload to ArchivesSpace is generated from a custom pipeline. See [/source_data/README.md]().
Edits can be made to individual records manually, or on a larger scale by rerunning the steps in our data pipeline, and reuploading files to ArchivesSpace. When chanages are made to the collection in production ArchiveSpace, you should download the new file as described aboce, and save it in `public/data`, overwriting the existing file. Commit this new file and submit a PR. Once merged and deployed, you can reindex on  `vt-stage` and `vt-prod`, as described above.

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
