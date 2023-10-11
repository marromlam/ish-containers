IMAGE_NAME="x86-ish-alpine"

mkdir -p builds
IMAGE_NUMBER=`ls builds | wc -l`
# add 1 to IMAGE_NUMBER
#
IMAGE_NUMBER="3"

docker build --no-cache -t x86-ish-alpine .

docker rm test; docker run --privileged --name test x86-ish-alpine sh
docker cp test:/tmp/ish-fs.tar.gz "builds/ish-fs-$IMAGE_NUMBER.tar.gz"
