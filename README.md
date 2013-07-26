Jekyll Deploy Script
====================

A deploy script for Jekyll that supports deploying to different GH page environments.

## The problem

There is no obvious way to support a staging and production environment from a single GH Pages Jekyll repository. GH Pages doesn't support multiple domains from a single repo.

## The deploy script

The shell script gives you the option to have multiple environments (at this point, two) and chose which one you want to deploy to.

## How it works

We use a submodule inside the jekyll source directory that is the deploy target repo. Within the deploy target, we specify two remotes (origin and another called 'dev'). Origin is the production repo, 'dev' is the development repo. Depending on which environment you want to deploy to, the script generates the appropriate CNAME file for GH pages and pushes the changes to the correct repository.

## Examples

1. Push changes to staging

    ./deploy.sh "A new blog post"

1. Push changes to production

    ./deploy.sh "A new blog post ready for prod" prod

## Setup

The shell script assumes you have a Jekyll directory setup with a submodule that points to your GH pages repo. See the blog post [here](http://indelible.io/blog/2013/07/14/jekyll-plugins-and-github-pages.html) about how to set this up.

Next, create a repository that will be your staging environment. Add this as a new remote in the source submodule.

    git remote add <remote url> <remote name>

Finally, set up the `./deploy.sh` script with the configuration you want.