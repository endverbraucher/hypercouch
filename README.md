# Hypercouch

HyperCouch is my blogging web app based on Ruby on Rails and CouchDB

## Setup
* Set environment variable `Couch` for couchdb.yml that points to
your CouchDB instance.
* For production environment set variable `slog_secret` for the secret token of
rails. For a new one simply run `rake secret`.