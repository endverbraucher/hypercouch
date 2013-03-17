# Hypercouch

HyperCouch is my blogging web app based on Ruby on Rails and CouchDB

## Setup

ToDo for Setup:
* Set environment variable `Couch` for couchdb.yml that points to
your CouchDB instance. For OSX look here:
http://developer.apple.com/library/mac/#qa/qa1067/_index.html
* For production environment set variable `slog_secret` for the secret token of
  rails. For a new one simply run `rake secret`.
* For Production: generate a new secret token with `rake secret`