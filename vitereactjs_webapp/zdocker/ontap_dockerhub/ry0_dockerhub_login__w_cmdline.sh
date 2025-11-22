SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`

[[ -z $u ]] && (echo 'Envvar $u is required'; kill $$)
[[ -z $p ]] && (echo 'Envvar $p is required'; kill $$)

docker  logout
#docker logout index.docker.io
#docker logout https://index.docker.io/v1/
#    eg logout https://index.docker.io/v1/ for docker hub
#    eg logout registry.gitlab.com for gitlab docker registry

#     $p password           $u user
echo "$p" | docker login -u $u --password-stdin
