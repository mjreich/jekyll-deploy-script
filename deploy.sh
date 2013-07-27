#!/bin/bash
set -e

if [[ -z $1 ]]
then
    echo "Usage: $0 'commit message' [env]"
    exit 0
fi

ghbranch=`git rev-parse --abbrev-ref HEAD`

### Config ###
# Jekyll destination directory, usually _sites
sitesDir='source'

# Use custom domain?
customDomain=true

# The url of your production site
prodUrl="production.url"

# The url of your dev/staging site
devUrl="staging.url"

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

echo "Deploying to $repo"

# Clean up the sites dir, pull any outstanding changes
echo "Updating sites with remote changes"
cd ./$sitesDir 
git checkout ./
git pull $repo $ghPagesBranch

# Build latest 
echo "Building jekyll"
cd ..
jekyll build

# Build the correct CNAME file for the env
cd ./$sitesDir

if [ $customDomain == true ]
then
  echo "Generating CNAME"
  if [ $env == 'dev' ]; then
    echo $devUrl > CNAME
  else
    echo $prodUrl > CNAME
  fi
fi

# Commit and push the changes to the sites dir
echo "Adding and committing destination files"
if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
then
  git add ./ 
  git commit -a -m "$message"
else
  echo "Nothing to commit"
fi
git push $repo $ghPagesBranch

# Commit and push the changes to the source dir
echo "Adding and committing source files"
cd ..
if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
then
  git add ./
  git commit -a -m "$message"
else
  echo "Nothing to commit"  
fi
git push origin $branch