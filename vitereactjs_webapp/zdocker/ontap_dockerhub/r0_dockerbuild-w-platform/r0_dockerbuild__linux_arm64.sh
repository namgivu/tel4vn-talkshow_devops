SH=`cd $(dirname ${BASH_SOURCE:-$0}) && pwd`
cd $SH

# default build
# docker build -t vitereactjs_webapp .


#region multibuilder
_='fix as failed run wh built fr macbook then run on ubuntu server'

builder_name="multi_builder"
if ! docker buildx inspect "$builder_name" >/dev/null 2>&1; then
  docker buildx create --name "$builder_name" --driver docker-container --use
else
  docker buildx use "$builder_name"
fi


docker buildx build \
  --platform           linux/arm64 \
  -t vitereactjs_webapp:linux_arm64 \
  --load "$SH/.."
#endregion multibuilder
