SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`
cd $SH
docker compose -f "$SH/docker-compose.yml"  up -d --build --remove-orphans

echo
cat <<'EOT'
--- whatsnext cmd hint
docker ps | grep vitereactjs_webapp

open web browser
http://localhost:8000
EOT
