FROM golang:1.10
ENV CGO_ENABLED=0
WORKDIR /go/src/copy-docker-image
RUN go get -u github.com/golang/dep/cmd/dep
RUN git clone https://github.com/adorsys/copy-docker-image . && rm copy-docker-image
RUN dep ensure
RUN go build

FROM alpine:latest
COPY --from=0 /go/src/copy-docker-image/copy-docker-image /usr/local/bin/copy-docker-image
CMD ["/usr/local/bin/copy-docker-image"]