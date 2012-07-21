require "bundler/capistrano"

# add multistaging environment

set :application, "tt"
set :repository,  "git@github.com:lsaffie/TimeTracker.git"
set :user, "local"
set :use_sudo, false
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH"
}

set :scm, :git

role :web, "192.168.69.173"
role :app, "192.168.69.173"
role :db,  "192.168.69.173", :primary => true
role :db,  "192.168.69.173"

#set :unicorn_binary, "/home/#{user}/.rbenv/shims/unicorn_rails"
#try without the path. It may pick it up from the dfault path set above
set :unicorn_binary, "unicorn_rails"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

def red(str)
  "\e[31m#{str}\e[0m"
end

# Figure out the name of the current local branch
def current_git_branch
  branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
  puts "Deploying branch #{red branch}"
  branch
end

set :branch, current_git_branch

namespace :deploy do
  desc "starts unicorn"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "kill `cat #{unicorn_pid}`"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc "zero downtime restart"
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end
