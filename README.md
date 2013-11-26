GitLab CI Cookbook
===============

Chef to install GitLab CI.

* GitLab CI: 4.0.0
* GitLab CI Runner: 4.0.0

This cookbook is inspired by the excellent [Gitlab Cookbook](https://github.com/ogom/cookbook-gitlab) from oogm and is developed to work well with this cookbook. It will work with others, too. For security reasons we decided to use docker for all gitlab ci runner. This enables us to quickly create and destroy runner. 

## Requirements

* [Berkshelf](http://berkshelf.com/)
* [Vagrant](http://www.vagrantup.com/)

### Vagrant Plugin

* [vagrant-berkshelf](https://github.com/RiotGames/vagrant-berkshelf)
* [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)

### Platform:

#### Gitlab CI
* Ubuntu (12.04, 12.10, 13.04, 13.10)

#### Gitlab CI Runner
* Ubuntu (13.04, 13.10)

## Installation

### Vagrant

#### VirtualBox

```bash
$ gem install berkshelf
$ vagrant plugin install vagrant-berkshelf
$ vagrant plugin install vagrant-omnibus
$ git clone git://github.com/chris-rock/cookbook-gitlabci ./gitlabci
$ cd ./gitlabci
$ vagrant up server
$ vagrant up runner
```

## Usage

Example of node config.

```json
{
  "mysql": {
    "server_root_password": "rootpass",
    "server_repl_password": "replpass",
    "server_debian_password": "debianpass"
  },
  "gitlabci": {
    "database_adapter": "mysql",
    "database_password": "datapass",
    "env" : "production"
  },
  "run_list":[
    "gitlabci::server"
  ]
}
```

## Links

* [GitLab CI Installation](https://github.com/gitlabhq/gitlab-ci/blob/master/doc/installation.md)
* [Gitlab Cookbook](https://github.com/ogom/cookbook-gitlab)

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: Christoph Hartmann

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
