#
# Cookbook Name:: gitlabci
# Recipe:: runner
#

# install docker
include_recipe "docker"
include_recipe "git"

# we expect the fo
gitlabci = node['gitlabci']
runner = gitlabci['runner']

# iterate over images and download
runner['images'].each do |image|

  if image.attribute?('image_url') 
    # we need to build it
    docker_image "#{image.name}" do
      image_url "#{image.image_url}"
      cmd_timeout 600 # max 10 min
      action :build
    end
  else 
    # otherwise download it from docker index
    docker_image "#{image.name}"
  end

end

# start the runner
runner['images'].each do |image|
  docker_container "#{image.name}" do
     detach true
     action :start
     env ["CI_SERVER_URL=#{runner['ciserver']}", "REGISTRATION_TOKEN=#{runner['ciregistrationtoken']}" , "HOME=/root"]
  end
end

#docker run 
#-e CI_SERVER_URL=https://ci.example.com 
#-e REGISTRATION_TOKEN=replaceme 
#-e HOME=/root 
#-i -t 
#gitlabhq/gitlab-ci-runner:latest 
#/bin/bash

# start images
#docker_image "busybox"

#docker_container "busybox" do
#  command "sleep 9999"
#  detach true
#end

# install standard gitlab runner
#docker_image "gitlabhq/gitlab-ci-runner" do
#  image_url "github.com/gitlabhq/gitlab-ci-runner"
#  action :build
#end

#docker_container "gitlabhq/gitlab-ci-runner" do
#   detach true
#   command "/bin/bash"
#   action :start
#end

# install coding force kitchen runner
#docker_image "codingforce/gitlab-ci-runner-testkitchen" do
#  repository "codingforce/gitlab-ci-runner-testkitchen"
#  action :import
#end

#docker_container "codingforce/gitlab-ci-runner-testkitchen" do
#   detach true
#   command "/bin/bash"
#   action :start
#end