
tdGitPullAll() {
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git fetch --all
    git pull --all
}

tdGitIgnore() {
    wget "https://github.com/github/gitignore/blob/master/$1.gitignore"
    git add .
    git rm -r --cached .
    git add .
    git commit -m ".gitignore fix"
}

tdGitIgnoreAndroid() {
    tdGitIgnore Android
}

tdGitIgnoreIOS() {
    tdGitIgnore Swift
}

tdGitBranches() {
    git branch -a
}

tdGitCurrentBranch() {
    tdGitBranches | grep "*" | sed 's/* //g'
}

tdGitStatus() {
    git status
}

tdGitCommit() {
    git commit -m "$1"
}

tdGitAdd() {
    git add "$1"
}

tdGitAddAll() {
    tdGitAdd .
    tdGitStatus
}

tdGitPushCustomer() {
  	git push customer "$1"
}

tdGitPushOrigin() {
  	git push origin "$1"
}

tdGitPushCustomerCurrentBranch() {
  	tdGitPushCustomer $(tdGitCurrentBranch)
}

tdGitPushOriginCurrentBranch() {
  	tdGitPushOrigin $(tdGitCurrentBranch)
}

tdGitPushAll() {
    tdGitPushCustomerCurrentBranch
    tdGitPushOriginCurrentBranch
}

tdGitLog() {
    git log
}

tdGitLogGraph() {
    git log --graph
}

tdGitMerge() {
    git merge "$1"
}

tdGitMergeDevelop() {
    tdGitMerge develop
}

tdGitDiff() {
    git diff
}

tdGitReset() {
    git reset --hard HEAD
}

tdToolFolder() {
    cd ~/artstools
}

tdToolEdit() {
    subl ~/artstools/git.sh
}
