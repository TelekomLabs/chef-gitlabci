# user
default['gitlabci']['production']['user'] = "gitlab_ci"
default['gitlabci']['production']['group'] = "gitlab_ci"
default['gitlabci']['production']['home'] = "/home/gitlab_ci"

# git
default['gitlabci']['production']['revision'] = "4-0-stable"
default['gitlabci']['production']['path'] = "/home/gitlab_ci/gitlab-ci"

# setup environments
default['gitlabci']['production']['environments'] = %w{production}

# gitlab server
default['gitlabci']['production']['gitlab']['server'] = %w{https://dev.gitlab.org/ https://staging.gitlab.org/}
default['gitlabci']['production']['gitlab']['ssl'] = "true"