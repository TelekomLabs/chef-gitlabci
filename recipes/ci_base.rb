#
# Cookbook Name:: gitlabci
# Recipe:: ci_base
#

gitlabci = node['gitlabci']

# Merge environmental variables
gitlabci = Chef::Mixin::DeepMerge.merge(gitlabci,gitlabci[gitlabci['env']])

# update system
include_recipe "apt" if platform?("ubuntu", "debian")

# install dependencies of gitlab ci
gitlabci['packages'].each do |pkg|
  package pkg
end

# install ruby
include_recipe "ruby_build"

# download and compile
ruby_build_ruby gitlabci['ruby'] do
  prefix_path "/usr/local/"
end

# install bundler gem:
gem_package "bundler" do
  gem_binary "/usr/local/bin/gem"
  options "--no-ri --no-rdoc"
end

# update all gems, is required for ubuntu 13.04 and 13.10
execute "gem update" do
  command <<-EOS
    gem update --system
  EOS
end

# create system user for gitlab ci
user gitlabci['user'] do
  comment "GitLab CI"
  home gitlabci['home']
  shell "/bin/bash"
  supports :manage_home => true
end

user gitlabci['user'] do
  action :lock
end
