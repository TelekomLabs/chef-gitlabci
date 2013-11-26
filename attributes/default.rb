# Package
if platform_family?("ubuntu")
  packages = %w{
   wget curl gcc checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libreadline6-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev openssh-server git-core libyaml-dev postfix libpq-dev libicu-dev redis-server
  }
else
  # not yet implemented
  packages = %w{    
  }
end

default['gitlabci']['packages'] = packages
default['gitlabci']['ruby'] = "2.0.0-p247"
default['gitlabci']['env'] = "production"

default['gitlabci']['host'] = "localhost"
default['gitlabci']['port'] = "80"


# GitLab CI Repo
default['gitlabci']['repository'] = "https://github.com/gitlabhq/gitlab-ci.git"

# Gems
default['gitlabci']['bundle_install'] = "bundle install --path=.bundle --deployment"