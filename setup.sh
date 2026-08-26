#!/bin/bash

echo "================================"
echo "       Gitea Local Setup"
echo "================================"

# Check required tools
echo
echo "Checking required tools..."

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: Git is not installed or not available."
    exit 1
fi

if ! command -v go >/dev/null 2>&1; then
    echo "ERROR: Go is not installed or not available."
    exit 1
fi

if ! command -v node >/dev/null 2>&1; then
    echo "ERROR: Node.js is not installed or not available."
    exit 1
fi

if ! corepack pnpm --version >/dev/null 2>&1; then
    echo "ERROR: pnpm is not available through Corepack."
    exit 1
fi

if ! command -v mingw32-make >/dev/null 2>&1; then
    echo "ERROR: Make is not installed or not available."
    exit 1
fi

echo "All required tools are available."

# Display dependency versions
echo
echo "Dependency versions:"
echo "Git: $(git --version)"
echo "Go: $(go version)"
echo "Node.js: $(node --version)"
echo "pnpm: $(corepack pnpm --version)"
echo "Make: $(mingw32-make --version | head -n 1)"

# Move to the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Verify Gitea project directory
echo
echo "Checking project directory..."

if [ ! -f "go.mod" ] || [ ! -f "Makefile" ]; then
    echo "ERROR: This does not appear to be the Gitea project directory."
    echo "Please place the script inside the Gitea project folder."
    exit 1
fi

echo "Project directory verified."

# Build Gitea
echo
echo "Building Gitea from source..."

if ! mingw32-make build; then
    echo "ERROR: Gitea build failed."
    exit 1
fi

echo "Gitea build completed successfully."

# Verify the generated binary
echo
echo "Checking Gitea binary..."

if [ ! -f "gitea.exe" ]; then
    echo "ERROR: gitea.exe was not created."
    exit 1
fi

echo "Gitea binary created successfully."
ls -lh gitea.exe

# Check port 3000
echo
echo "Checking port 3000..."

if netstat -ano | grep -q ":3000"; then
    echo "ERROR: Port 3000 is already in use."
    echo "Please stop the process using port 3000 and run the script again."
    exit 1
fi

echo "Port 3000 is available."

# Start Gitea
echo
echo "Starting Gitea web server..."

./gitea.exe web &
GITEA_PID=$!

sleep 5

if ! kill -0 "$GITEA_PID" 2>/dev/null; then
    echo "ERROR: Gitea failed to start."
    exit 1
fi

echo "Gitea started successfully."
echo "Local URL: http://localhost:3000"
echo
echo "Gitea is now running."