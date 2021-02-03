# Load files from ./seeds
Dir[ "#{Rails.root}/db/seeds/*.rb" ].map{ |f| load f }
