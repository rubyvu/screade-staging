web: bundle exec puma --config config/puma.rb --bind unix:///var/run/puma/my_app.sock

worker: bundle exec que -q schedule -q default
