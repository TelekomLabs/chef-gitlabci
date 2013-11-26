#
# Cookbook Name:: gitlab
# Recipe:: database_postgresql
#

postgresql = node['postgresql']
gitlabci = node['gitlabci']

# Merge environmental variables
gitlabci = Chef::Mixin::DeepMerge.merge(gitlabci,gitlabci[gitlabci['env']])

# database
include_recipe "postgresql::server"
include_recipe "database::postgresql"

postgresql_connexion = {
  :host => 'localhost',
  :username => 'postgres',
  :password => postgresql['password']['postgres']
}

# create a user for gitlab ci.
postgresql_database_user gitlabci['user'] do
  connection postgresql_connexion
  password gitlabci['database_password']
  action :create
end

# create the gitlabci database & grant all privileges on database
gitlabci['environments'].each do |environment|
  postgresql_database "gitlabci_#{environment}" do
    connection postgresql_connexion
    action :create
  end

  postgresql_database_user gitlabci['user'] do
    connection postgresql_connexion
    database_name "gitlabci_#{environment}"
    password gitlabci['database_password']
    action :grant
  end
end
