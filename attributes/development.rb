# user
default['gitlabci']['development']['user'] = "vagrant"
default['gitlabci']['development']['group'] = "vagrant"
default['gitlabci']['development']['home'] = "/home/vagrant"

# git
default['gitlab']['development']['revision'] = "master"
default['gitlab']['development']['path'] = "/vagrant/gitlab"

# setup environments
default['gitlab']['development']['environments'] = %w{development test}

# gitlab server
default['gitlabci']['production']['gitlab']['server'] = %w{http://localhost/}
default['gitlabci']['production']['gitlab']['ssl'] = "false"
