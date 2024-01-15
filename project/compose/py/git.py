import subprocess

def getGitRevisionHash(gitRepoPath, gitObject) -> str:
    return subprocess.check_output(f"git -C \"{gitRepoPath}\" rev-parse {gitObject}").decode('ascii').strip()

def logSHA(sha, remote):
    print(f"Running SHA: \"{sha}\", url: {remote}/commit/{sha}")