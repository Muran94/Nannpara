web: bin/rails server -p $PORT -e $RAILS_ENV
worker: mkdir -p tmp/pids && bundle exec sidekiq -C config/sidekiq.yml:work