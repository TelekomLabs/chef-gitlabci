#
# Cookbook Name:: gitlabci
# Recipe:: ci_server
#

gitlabci = node['gitlabci']

# merge environmental variables
gitlabci = Chef::Mixin::DeepMerge.merge(gitlabci,gitlabci[gitlabci['env']])

# clone the source
old_home = ENV['HOME']
ruby_block "clear_home for CHEF-3940" do
  block do
    ENV['HOME'] = Etc.getpwnam("gitlab_ci").dir
  end
  not_if {`git --version`.split[2].to_f <= 1.7}
end

git gitlabci['path'] do
  repository gitlabci['repository']
  revision gitlabci['revision']
  user gitlabci['user']
  group gitlabci['group']
  action :sync
end

ruby_block "reset_home" do
  block do
    ENV['HOME'] = old_home
  end
  not_if {`git --version`.split[2].to_f <= 1.7}
  #subscribes :create, "git[/home/gitlab_ci/gitlab-ci]", :immediately
end

# copy the gitlab ci application config
template File.join(gitlabci['path'], 'config', 'application.yml') do
  source "application.yml.erb"
  user gitlabci['user']
  group gitlabci['group']
  variables({
    :server => gitlabci['gitlab']['server'],
    :https => gitlabci['gitlab']['ssl'],
  })
end

# gitlab puma config
template File.join(gitlabci['path'], 'config', 'puma.rb') do
  source "puma.rb.erb"
  user gitlabci['user']
  group gitlabci['group']
  variables({
      :path => gitlabci['path'],
      :user => gitlabci['user'],
      :env => gitlabci['env']
  })
end

### make sure gitlab ci can write to the log/ and tmp/ directories
%w{log tmp}.each do |path|
  directory File.join(gitlabci['path'], path) do
    owner gitlabci['user']
    group gitlabci['group']
    mode 0755
  end
end

# create directories for sockets/pids and make sure gitlab ci can write to them
%w{tmp/pids tmp/sockets}.each do |path|
  directory File.join(gitlabci['path'], path) do
    owner gitlabci['user']
    group gitlabci['group']
    mode 0755
  end
end

# install gems
template File.join(gitlabci['home'], ".gemrc") do
  source "gemrc.erb"
  user gitlabci['user']
  group gitlabci['group']
  notifies :run, "execute[bundle install]", :immediately
end

# gem without
bundle_without = []
case gitlabci['database_adapter']
when 'mysql'
  bundle_without << 'postgres'
when 'postgresql'
  bundle_without << 'mysql'
end

case gitlabci['env']
when 'production'
  bundle_without << 'development'
  bundle_without << 'test'
else
  bundle_without << 'production'
end

execute "bundle install" do
  command <<-EOS
    PATH="/usr/local/bin:$PATH"
    #{gitlabci['bundle_install']} --without #{bundle_without.join(" ")}
  EOS
  cwd gitlabci['path']
  user gitlabci['user']
  group gitlabci['group']
  action :nothing
end


## configure gitlab ci db settings
template File.join(gitlabci['path'], "config", "database.yml") do
  source "database.yml.#{gitlabci['database_adapter']}.erb"
  user gitlabci['user']
  group gitlabci['group']
  variables({
    :user => gitlabci['user'],
    :password => gitlabci['database_password']
  })
end

# per environment

### db:setup
gitlabci['environments'].each do |environment|

  log "#{environment}"

  # Setup tables
  execute "setup tables install" do
    command <<-EOS
      bundle exec rake db:setup RAILS_ENV=#{environment}
    EOS
    cwd gitlabci['path']
    user gitlabci['user']
    group gitlabci['group']
  end

  # setup schedules
  execute "setup schedules" do
    command <<-EOS
      bundle exec whenever -w RAILS_ENV=#{environment}
    EOS
    cwd gitlabci['path']
    user gitlabci['user']
    group gitlabci['group']
  end
end

case gitlabci['env']
when 'production'
  # install init script
  template "/etc/init.d/gitlab_ci" do
    source "initd.erb"
    mode 0755
    variables({
      :path => gitlabci['path'],
      :user => gitlabci['user'],
      :env => gitlabci['env']
    })
  end

  # start gitlab ci instance
  service "gitlab_ci" do
    supports :start => true, :stop => true, :restart => true, :status => true
    action :enable
  end

  file File.join(gitlabci['home'], ".gitlab_start") do
    owner gitlabci['user']
    group gitlabci['group']
    action :create_if_missing
    notifies :start, "service[gitlab_ci]"
  end
else
  # execute javascript test
  include_recipe "phantomjs"
end
