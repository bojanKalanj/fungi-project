set :stage, :production
set :branch, 'master'

set :deploy_to, '/usr/share/nginx/fungiorbis_rails'
set :rails_env, :production
# set :passenger_restart_options, -> { "#{deploy_to}/current --ignore-app-not-running" }
# set :passenger_restart_options, -> { "#{deploy_to}/current" }

set :rvm_gemset_wrappers_dir, '/home/markob/.rvm/gems/ruby-2.1.5@fungiorbis2/wrappers/ruby'

set :full_app_name, fetch(:application)
set :deploy_user, 'markob'
server 'fungiorbis', user: 'markob', roles: %w{db web app}, primary: true