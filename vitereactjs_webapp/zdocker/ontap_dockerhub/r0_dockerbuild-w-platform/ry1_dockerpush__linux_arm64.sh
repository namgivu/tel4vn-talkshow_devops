SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`

docker image tag vitereactjs_webapp:linux_amd64  namgivu/vitereactjs_webapp:linux_amd64
docker push                                     namgivu/vitereactjs_webapp:linux_amd64
