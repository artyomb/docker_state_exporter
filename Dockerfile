FROM golang:1.24.1-alpine AS builder
RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /go/bin/docker_state_exporter

FROM alpine:3.21
RUN apk add --no-cache ca-certificates
COPY --from=builder /go/bin/docker_state_exporter /usr/local/bin/docker_state_exporter
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/docker_state_exporter"]
CMD ["-listen-address=:8080"]
