SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`

docker  logout
#docker logout index.docker.io
#docker logout https://index.docker.io/v1/
#    eg logout https://index.docker.io/v1/ for docker hub
#    eg logout registry.gitlab.com for gitlab docker registry

docker login
_=`cat<<EOT
Your one-time device confirmation code is: SVKT-BGRP
Press ENTER to open your browser or submit your device code here: https://login.docker.com/activate

Waiting for authentication in the browser…

Login Succeeded
EOT`
