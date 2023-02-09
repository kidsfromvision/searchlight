# README

## Searchlight

### Introduction

Searchlight is a web app to help indie music labels keep track of the songs that they're following. It shows them data that may be relevant to a label when deciding whether a song is interesting or not. 

It is a full stack Ruby on Rails application.

### We use...

* Ruby version: 3.2.0

* Database: Postgres

* Redis

### Set up...

If you want to host Searchlight yourself, the most important things you'll need (apart from Ruby & Rails, Postgres, and Redis) are the following env vars:

* SPOTIFY_CLIENT_ID
* SPOTIFY_CLIENT_SECRET
* CHARTMETRIC_REFRESH_TOKEN

These will allow the search and stream api requests to work. 

There's no sign up form (intended as a B2B product), so you'll have to create your user in console (it just needs an email and a password). 

### Some features...

* Turbo frames for snappy, server-synced, table sorting.
* Stimulus for auto-submit on forms (search bar and status changing)
* Turbo streams for synced loading state and updates across users belonging to the same label. 

