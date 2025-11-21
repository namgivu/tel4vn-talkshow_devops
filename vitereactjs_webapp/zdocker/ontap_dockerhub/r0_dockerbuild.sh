SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`
cd $SH
docker build -t vitereactjs_webapp .

cat << EOT
docker image ls
docker image ls | grep vitereactjs_webapp
docker image ls | grep -E 'vitereactjs_webapp|TAG'

docker run vitereactjs_webapp
docker run -e NAME='tocd07 2025' vitereactjs_webapp

docker run \
  -d --name ontap_dockerhub_c \
  -e NAME='tocd07 2025' vitereactjs_webapp
docker logs ontap_dockerhub_c

docker rm -f ontap_dockerhub_c
EOT
