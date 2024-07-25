#!/bin/bash

# Ensure that the commit message and remote URLs are provided as arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <commit_message> <github_remote_url> <gitea_remote_url>"
    exit 1
fi

COMMIT_MESSAGE=$1
GITHUB_REMOTE_URL=$2
GITEA_REMOTE_URL=$3

# Define remote names
GITHUB_REMOTE_NAME="github"
GITEA_REMOTE_NAME="gitea"

# Add the GitHub remote if it doesn't already exist
if ! git remote get-url $GITHUB_REMOTE_NAME &>/dev/null; then
    echo "Adding GitHub remote..."
    git remote add $GITHUB_REMOTE_NAME $GITHUB_REMOTE_URL
else
    echo "GitHub remote already exists."
fi

# Add the Gitea remote if it doesn't already exist
if ! git remote get-url $GITEA_REMOTE_NAME &>/dev/null; then
    echo "Adding Gitea remote..."
    git remote add $GITEA_REMOTE_NAME $GITEA_REMOTE_URL
else
    echo "Gitea remote already exists."
fi

# Determine the current branch
CURRENT_BRANCH=$(git branch --show-current)

if [ -z "$CURRENT_BRANCH" ]; then
    echo "No current branch found. Ensure you are on a valid branch."
    exit 1
fi

# Add all changes
echo "Staging changes..."
git add .

# Commit changes with the provided commit message
echo "Committing changes..."
git commit -m "$COMMIT_MESSAGE"

# Push to both remotes
echo "Pushing to GitHub..."
git push $GITHUB_REMOTE_NAME $CURRENT_BRANCH

echo "Pushing to Gitea..."
git push $GITEA_REMOTE_NAME $CURRENT_BRANCH

echo "All done!"

