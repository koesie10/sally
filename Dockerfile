FROM golang:1.9.2 as builder

WORKDIR /go/src/go.uber.org/sally
COPY . .
RUN go get -v github.com/Masterminds/glide && glide install
RUN CGO_ENABLED=0 GOOS=linux go install

FROM alpine
RUN apk --update add ca-certificates
RUN mkdir /app
WORKDIR /app
COPY --from=builder /go/bin/sally /bin/sally
RUN mkdir /sally
WORKDIR /sally
ENTRYPOINT ["/bin/sally"]
