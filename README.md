## Realtime Chatting
This is a realtime-chatting room app base on Rails5. Use ActionCable to
make the user can talk to each other real-time.

## Requirements
* Ruby 2.2.0 +
* Rails 5.0.0 + (currently beta)
* Redis 2.2 +
* Postgresql, Mysql or sqlite3

## Run
```sh
$ bundle install
$ bin/rails db:migrate
$ bin/rails server
$ sidekiq
```
