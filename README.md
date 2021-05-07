# README

This is the ADMIN site and the JSON api for the [angular front-end](https://github.com/coopermayne/morph-s3) (which is hosted on firebase)

Runs on heroku and pulls images from AWS



## Reqs for local dev setup

- Postgres

- Node

- Appropriate version of ruby and ruby gems (see gemfile.lock)

- Sample data (it might thow errors if there is no data in the DB... so you'll have to seed database)

  - this can be done by copying data from heroku and pushing it into local db

  - see https://devcenter.heroku.com/articles/heroku-postgres-import-export

  - ```term
    heroku pg:backups:capture
    heroku pg:backups:download
    ```

  - ```term
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump
    ```



## Reqs for heroku setup

- At least a **Hobby Dyno** ($7/mo)
- Required heroku addons
  - Heroku Postgres **Hobby Basic** ($9/mo)
  - MemCachier **Developer**



## Link to AWS images

- needs to be linked up to an AWS bucket for image storage
- set up a bucket and change the ENV variables
  - aws_access_key_id
    aws_secret_access_key
    aws_region
    bucket_name
- These should be set in a config/application.yml file which is hidden from hit repo