#!/bin/bash
# kkesselman/sample-go-app:1.0.1

# dockerfile - automatic image tagging
builder_image="golang"
version="1.19"
alpine_version="3.14"
repo_name=$1
image_name=$2
cat <<EOF > Dockerfile
FROM $builder_image:$version as builder
WORKDIR \$GOPATH/src
EXPOSE 8080

# Copy source code
ADD . .
COPY /dockerize/src ./src

RUN go env -GO111MODULE=off
RUN go env -d github.com/go-sql-driver/mysql
RUN go build o -webserver ./dockerize/webserver.go
CMD ["./webserver"]
EOF
echo "Dockerfile created. Contents below:"
cat Dockerfile
echo "Using image name: $image_name"
full_image_name="$image_name:`date +%`"
echo "Repo name: $repo_name"
echo "Full image name: $full_image_name"
echo "Running: docker build -t $full_image_name"
cd ..
docker build -t $full_image_name -f ./linux/Dockerfile .
cd ./linux
cat script.yml | sed "s/MY_NEW_IMAGE/$repo_name\/$full_image_name/g" > new-app.yaml
kubectl diff -f new-app.yaml
