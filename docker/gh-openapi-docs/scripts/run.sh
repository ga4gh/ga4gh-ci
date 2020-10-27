#!/bin/bash
# run.sh
# to be used as part of a Travis CI build
# runs the gh-openapi-docs tool and pushes built documentation to gh-pages branch

# configure the github account that will push to the gh-pages branch of this repo
function setup_github_account {
    git config user.name $GH_PAGES_NAME
    git config user.email $GH_PAGES_EMAIL
    git config credential.helper "store --file=.git/credentials"
    echo "https://${GH_PAGES_TOKEN}:x-oauth-basic@github.com" > .git/credentials
}

# remove credentials of github account from build
function cleanup_github_account {
  rm .git/credentials
}

# pulls the remote gh-pages branch to local
function setup_github_branch {
    git fetch origin
    git checkout -b gh-pages
    git branch --set-upstream-to=origin/gh-pages
    git config pull.rebase false
    git add preview
    git add docs
    git add openapi.json
    git add openapi.yaml
    git stash save
    git pull
    git checkout stash -- .
}

# commit the outputs from gh-openapi-docs
function commit_gh_openapi_docs_outputs {
    git commit -m "added docs from gh-openapi-docs"
}

# main method
function main {
    if [[ $TRAVIS_PULL_REQUEST == "false" ]]; then
        if [[ $TRAVIS_BRANCH == master || $TRAVIS_BRANCH == develop || $TRAVIS_BRANCH == release/* ]]; then
            echo -e "travis branch: ${TRAVIS_BRANCH}; building documentation"
            echo -e "running gh-openapi-docs"
            gh-openapi-docs
            echo -e "configuring github account to push to gh-pages branch"
            setup_github_account
            echo -e "pulling gh-pages to local and merging local changes"
            setup_github_branch
            commit_gh_openapi_docs_outputs
            echo -e "pushing to remote gh-pages branch"
            git push
            echo -e "cleaning up"
            cleanup_github_account
        else
            echo -e "travis branch: ${TRAVIS_BRANCH}; not building documentation"
        fi
    else
        echo -e "this is a pull request build; not building documentation"
    fi
}

main
exit 0
