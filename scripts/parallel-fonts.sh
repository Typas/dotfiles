#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FONT_DIR="$(cd "$SCRIPT_DIR/../fonts" && pwd)"
scope="${1:-all}"

# shellcheck source=parallel-progress.sh
source "$SCRIPT_DIR/parallel-progress.sh"

REQUIRED=(fira-code juliamono noto-sans-cjk noto-serif-cjk typas-code typas-mono-cjk-tc)
OPTIONAL=(fira-math fira-sans inconsolata lxgw-wenkai-tc)

case "$scope" in
    required) fonts=("${REQUIRED[@]}") ;;
    all)      fonts=("${REQUIRED[@]}" "${OPTIONAL[@]}") ;;
    *)        echo "usage: parallel-fonts.sh [required|all]"; exit 1 ;;
esac

cd "$FONT_DIR"

for name in "${fonts[@]}"; do
    run_parallel "$name" bash "${name}.sh" install
done

wait_parallel || true

echo "updating font cache..."
fc-cache -f
echo "font installation complete"
