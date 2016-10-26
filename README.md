# ikemen.okamu.ro
[真のイケメンを発掘するサービス](http://ikemen.okamu.ro)

## Environment
### Ruby
* version 2.2.4

### Rails
* version 5.0.0.1

### Rack
* Puma 3.6.0

### Deploy
* Capistrano 3.6.1

## Setting
### Quick start
```
$ git clone https://github.com/okamuroshogo/ikemen.git

$ mv .env.sample .env (edit me)

$ bundle install --path=vender/bundler/

$ bundle exec rails ikemen:setup

$ bundle exec rails s
```

### Use puma
```
$ bundle exec puma -e production -C config/puma.rb
```

### Deploy
```
$ vim config/deploy.rb
$ vim config/deploy/production.rb

$ bundle exec cap production deploy
```

