default['gitlabci']['runner']['ciserver'] = "https://ci.example.com"
default['gitlabci']['runner']['ciregistrationtoken'] = "replaceme"

# setup environments
default['gitlabci']['runner']['images'] = [
    {
        "name" => "gitlabhq/gitlab-ci-runner", 
        "image_url" => "github.com/gitlabhq/gitlab-ci-runner"
    }
    #, {
    #    "name" => "codingforce/gitlab-ci-runner-testkitchen"
    #}
]