name             'gitlabci'
maintainer       'Christoph Hartmann'
maintainer_email 'chris@lollyrock.com'
license          'Apache 2'
description      'Installs/Configures GitLab CI'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "gitlabci::install", "Installation"
recipe "gitlabci::runner", "Installation of a runner"

%w{git docker mysql postgresql apt ruby_build nginx database phantomjs}.each do |dep|
  depends dep
end

%w{ubuntu}.each do |os|
  supports os
end
