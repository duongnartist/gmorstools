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
	git commit "$1"
}

tdGitAdd() {
	git add "$1"
}

tdGitAddAll() {
	tdGitAdd .
}

tdGitPushOrigin() {
  	git push origin "$1"
}

tdGitPushOriginCurrentBranch() {
  	tdGitPushOrigin $(tdGitCurrentBranch)
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


