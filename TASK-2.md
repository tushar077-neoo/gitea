# Task 2 – Automate Local Project Setup

## Objective

Automate the process of building and running Gitea locally using a Bash script instead of executing each command manually.

## What I Did

- Created a `setup.sh` script for the Gitea project.
- Added checks for Git, Go, Node.js, pnpm and Make.
- Displayed dependency versions.
- Verified the Gitea project directory.
- Automated the Gitea build process.
- Verified that `gitea.exe` was created successfully.
- Added a check for port 3000.
- Added error handling for missing tools, build failures, missing binary and an occupied port.
- Automated starting the Gitea web server.
- Displayed the local Gitea URL after startup.

## Testing

The script successfully built and started Gitea at:

http://localhost:3000

I also tested the port-conflict scenario while Gitea was already running. The script correctly detected that port 3000 was occupied and stopped with an error message.

## Result

The entire local setup can now be automated with:

```bash
./setup.sh
