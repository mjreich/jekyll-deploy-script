#!/bin/bash
set -e

if [ ! $1 ]
then
    echo "Usage: $0 'commit message' [env]"
    exit 0
fi

ghbranch=`git rev-parse --abbrev-ref HEAD`

### Config ###
# Jekyll destination directory, usually _sites
sitesDir='source'

# The url of your production site
prodUrl="indelible.io"

# The url of your dev/staging site
devUrl="staging.indelible.io"

# The name of the development git remote
devRemote="dev"

# The name of the prod git remote
prodRemote="origin"

# The name of the branch used by GH pages (probably gh-pages)
ghPagesBranch="gh-pages"

### Command line opts ###
message=$1 #commit message
env=${2-dev} # Environment: options are 'dev' and 'prod'. Defaults to 'dev'
branch=$3 # Branch to commit to - will default to the current working branch

if  [[ -z "$banch" ]]; then
  branch=$ghbranch
fi

if [ $env == 'dev' ]; then
  repo=$devRemote
else
  repo=$prodRemote
fi

# Clean up the sites dir, pull any outstanding changes
cd ./$sitesDir 
git checkout ./
git pull $repo $ghPagesBranch

# Build latest 
cd ..
jekyll build

# Build the correct CNAME file for the env
cd ./$sitesDir
if [ $env == 'dev' ]; then
  echo $devUrl > CNAME
else
  echo $prodUrl > CNAME
fi

# Commit and push the changes to the sites dir
git add ./ 
git commit -a -m "$message"
git push $repo $ghPagesBranch

# Commit and push the changes to the source dir
cd ..
git add ./
git commit -a -m "$message"
git push origin $branch
