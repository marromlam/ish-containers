mkdir -p builds
IMAGE_NUMBER=$(ls builds | wc -l | tr -d ' ')
# increment by 1
IMAGE_NUMBER=$((IMAGE_NUMBER + 1))
IMAGE_NAME="x86-ish-alpine-$IMAGE_NUMBER"
# add 1 to IMAGE_NUMBER
#
# IMAGE_NUMBER="3"

docker build --no-cache -t $IMAGE_NAME .

docker rm test
docker run --privileged --name test $IMAGE_NAME sh
docker cp test:/tmp/ish-fs.tar.gz "builds/ish-fs-$IMAGE_NUMBER.tar.gz"
