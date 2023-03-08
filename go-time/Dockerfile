# Build stage
# Pin the minor version
FROM golang:1.20-alpine AS build

WORKDIR /app
COPY . /app

# Build the `server` binary
RUN go build server.go

# Final stage
# Pin the minor version
FROM alpine:3.17

# Add the ca-certificates package to the container
RUN apk --no-cache add ca-certificates
# Copy the `server` binary from the build stage
COPY --from=build /app/server /app/server

EXPOSE 8080

CMD ["/app/server"]
