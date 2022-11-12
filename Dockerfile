FROM  golang:1.19 as builder

WORKDIR $GOPATH/src
EXPOSE 8080

# Copy source code
ADD . .
COPY /dockerize/src ./src

RUN go env -w GO111MODULE=off
RUN go get -d github.com/go-sql-driver/mysql
RUN go build -o webserver ./dockerize/webserver.go

#Alpine is the smallest image
 FROM alpine:3.14 

 WORKDIR /

# Preguntar: Porque no reconoce la primera ruta
COPY --from=builder ./src ./dockerize/webserver
CMD ["./webserver"]
#CMD ["sleep","9000"]
