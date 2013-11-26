#
# Cookbook Name:: gitlabci
# Recipe:: runner
#

# install docker
include_recipe "docker"
include_recipe "git"

# install standard gitlab runner

docker_image "gitlabhq/gitlab-ci-runner" do
  dockerfile "github.com/gitlabhq/gitlab-ci-runner"
  action :build
end

docker_container "gitlabhq/gitlab-ci-runner" do
   detach true
   command "/bin/bash"
   action :start
end

# install coding force kitchen runner
docker_image "codingforce/gitlab-ci-runner-testkitchen" do
  repository "codingforce/gitlab-ci-runner-testkitchen"
  action :import
end

docker_container "codingforce/gitlab-ci-runner-testkitchen" do
   detach true
   command "/bin/bash"
   action :start
end