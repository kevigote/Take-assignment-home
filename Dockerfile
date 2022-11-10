FROM  golang:1.19 as builder

WORKDIR $GOPATH/src
EXPOSE 8080

# copy source code
ADD . .
COPY /dockerize/src ./src
# Retrieve application dependencies.
#RUN go mod init dockerize
#RUN go get

RUN go env -w GO111MODULE=off
RUN go get -d github.com/go-sql-driver/mysql
RUN go build -o webserver ./dockerize/webserver.go

CMD ["./webserver"]
#CMD ["sleep","9000"]

