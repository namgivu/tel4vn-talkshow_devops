SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`

cat << EOT
#       run image
#       run registry/image_tag
#       run registry/i_name:i_revision

docker  run namgivu/vitereactjs_webapp
docker  run namgivu/vitereactjs_webapp:latest

docker  run namgivu/vitereactjs_webapp:linux_amd64
docker  run namgivu/vitereactjs_webapp:linux_arm64
EOT
