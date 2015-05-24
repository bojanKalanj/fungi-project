# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'fungiorbis_rails'

set :repo_url, 'http://github.com/bosskovic/fungiorbis_pure_rails.git'

set :rvm_ruby_version, '2.1.5@fungiorbis2'

set :passenger_rvm_ruby_version, '2.1.5@fungiorbis2'
set :passenger_restart_with_sudo, true

set :stages, ['production']
set :bundle_without, %w{development test}.join(' ')

set :pty, false

set :linked_files, %w{config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set(:config_files, %w(nginx.conf))

set(:executable_config_files, [])

set(:symlinks, [
  { source: 'nginx.conf', link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}" },
  # { source: 'log_rotation', link: "/etc/logrotate.d/#{fetch(:full_app_name)}" },
  # { source: 'monit', link: "/etc/monit/conf.d/#{fetch(:full_app_name)}.conf" }
])

namespace :deploy do
  before :deploy, 'deploy:check_revision'
  # compile assets locally then rsync
  after :finishing, 'deploy:cleanup'

  before :deploy, 'deploy:setup_config'

  # remove the default nginx configuration as it will tend to conflict with our configs.
  before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # Restart monit so it will pick up any monit configurations we've added
  # after 'deploy:setup_config', 'monit:restart'


  after 'deploy:publishing', 'deploy:restart'
end

after 'deploy:finished', 'airbrake:deploy'

# usage example:
# cap production run_rake[namespace:task_name,parameter]
desc 'Executes rake task in the selected environment with passed arguments'
task :run_rake, [:task_name, :argument] do |t, args|
  on roles(:app), in: :sequence, wait: 5 do
    within release_path do
      with rails_env: fetch(:stage) do
        command = args[:task_name]
        command += "[#{args[:argument]}]" if args[:argument]
        execute :rake, command
      end
    end
  end
end