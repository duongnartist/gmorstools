import os
import sys
import subprocess

class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)
        # output = subprocess.call(["sudo", "chmod", "-R", "777"])
        # print(output)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)


def handle_branches(old_branches):
    new_branches = []
    for branch in old_branches:
        if ("feature" in branch or "update" in branch) and "remotes" not in branch and "origin" not in branch:
            new_branches.append(branch.replace("*", "").strip())
    return new_branches

def checkout_pull(branch):
    try:
        out_remove_log = str(subprocess.call(["rm", ".git/index.lock"]))
        print(out_remove_log)
        out_reset = str(subprocess.call(["git", "reset", "--hard", "HEAD"]))
        print(out_reset)
        out_clean = str(subprocess.call(["git", "clean", "-d", "-x", "-f"]))
        print(out_clean)
        out_checkout = str(subprocess.check_output(["git", "checkout", branch]))
        print(out_checkout)
        out_pull = str(subprocess.check_output(["git", "pull"]))
        print(out_pull)
    except subprocess.CalledProcessError as e:
        print("error: {}".format(e.output))


def get_git_log(file_name):
    out_log = str(subprocess.check_output(["git", "log", "--pretty=format:%ct,%ci,%h,%ae,%s"]))
    # print(out_log)
    file_path = "{}{}".format(file_name, ".csv")
    fo = open(file_path, "wb")
    fo.write(out_log.encode('utf8'))
    fo.close()
    return out_log

args = sys.argv

project_path = args[-1]

print("welcome to {}".format(project_path))

with cd(project_path):
    subprocess.call(["git", "fetch"])
    git_branch_a = str(subprocess.check_output(["git", "branch", "-a"]))
    old_branches = git_branch_a.split("\\n")
    new_branches = handle_branches(old_branches)
    print("branches = {}".format(len(new_branches)))
    for branch in new_branches:
        print(" -> {}\n".format(branch))
        checkout_pull(branch)
    # get_git_log(branch)
