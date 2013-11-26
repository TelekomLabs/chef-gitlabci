#
# Cookbook Name:: gitlabci
# Recipe:: ci_nginx
#

gitlabci = node['gitlabci']

# merge environmental variables
gitlabci = Chef::Mixin::DeepMerge.merge(gitlabci,gitlabci[gitlabci['env']])

# nginx installation
package "nginx" do
  action :install
end

## Site Configuration
path = platform_family?("rhel") ? "/etc/nginx/conf.d/gitlab_ci.conf" : "/etc/nginx/sites-available/gitlab_ci"
template path do
  source "nginx.erb"
  mode 0644
  variables({
    :path => gitlabci['path'],
    :host => gitlabci['host'],
    :port => gitlabci['port']
  })
end

if platform_family?("rhel")
  directory gitlabci['home'] do
    mode 0755
  end
else
  link "/etc/nginx/sites-enabled/gitlab_ci" do
    to "/etc/nginx/sites-available/gitlab_ci"
  end

  file "/etc/nginx/sites-enabled/default" do
    action :delete
  end
end

## restart
service "nginx" do
  action :restart
end
