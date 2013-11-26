#
# Cookbook Name:: gitlabci
# Recipe:: ci_mysql
#

mysql = node['mysql']
gitlabci = node['gitlabci']

# merge environmental variables
gitlabci = Chef::Mixin::DeepMerge.merge(gitlabci,gitlabci[gitlabci['env']])

# database
include_recipe "mysql::server"
include_recipe "database::mysql"

mysql_connexion = {
  :host => 'localhost',
  :username => 'root',
  :password => mysql['server_root_password']
}

# create a user for gitlab ci
mysql_database_user gitlabci['user'] do
  connection mysql_connexion
  password gitlabci['database_password']
  action :create
end

# create gitlab database & grant all privileges on database
gitlabci['environments'].each do |environment|
  mysql_database "gitlab_ci_#{environment}" do
    connection mysql_connexion
    action :create
  end

  mysql_database_user gitlabci['user'] do
    connection mysql_connexion
    password gitlabci['database_password']
    database_name "gitlab_ci_#{environment}"
    host 'localhost'
    privileges ["SELECT", "UPDATE", "INSERT", "DELETE", "CREATE", "DROP", "INDEX", "ALTER", "LOCK TABLES"]
    action :grant
  end
end