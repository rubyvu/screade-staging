web: bundle exec puma -C config/puma.rb --bind unix:///var/run/puma/my_app.sock
worker: bundle exec que -q schedule -q default -q searchkick
