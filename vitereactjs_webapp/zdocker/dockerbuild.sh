#!/usr/bin/env bash
set -eu

SH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AH="$(cd "$SH/.." && pwd)"

platform=${1:-${platform:='linux/amd64'}}
#       =${1:-${platform:='linux/arm64'}}

set -x
cd "$AH"
docker build --platform "$platform" -t 'vitereactjs_webapp' -f "$SH/Dockerfile" .  # .dockerignore is implied to be stored at this dot . context folder

cat <<'EOT'
docker image ls | grep -E 'TAG|vitereactjs_webapp'

c=vitereactjs_webapp_c ; docker rm -f $c ; docker run --name $c -p88:80 -d vitereactjs_webapp ; echo;docker ps | grep $c

open web browser
http://localhost:88
EOT
