#!/usr/bin/env bash
set -euo pipefail
cd "$HOME"

# 1. Node 18 LTS + pnpm -------------------------------------------------------
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
node -v && pnpm -v

# 2. .NET 9.0.4 SDK -----------------------------------------------------------
wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --version 9.0.4 --install-dir "$HOME/.dotnet"
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$PATH"
dotnet --version   # → 9.0.4

# 3. mono-devel ---------------------------------------------------------------
sudo apt update && sudo apt install -y mono-devel ca-certificates-mono

# 4. clone celeste-wasm -------------------------------------------------------
git clone https://github.com/MercuryWorkshop/celeste-wasm.git
cd celeste-wasm

# 5. JS dependencies ----------------------------------------------------------
pnpm i

# 6. .NET workload restore (inside loader/) ----------------------------------
sudo -E dotnet workload restore ./loader   # -E keeps $DOTNET_ROOT

# 7. ready --------------------------------------------------------------------
echo "=== celeste-wasm env ready ==="
echo "Dev server:  make serve"
echo "Release:     make publish"
