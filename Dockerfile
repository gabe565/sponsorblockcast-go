FROM golang:1.21-alpine as go-builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
COPY internal/ internal/

RUN --mount=type=cache,target=/root/.cache \
    go build -ldflags="-w -s" -trimpath


FROM alpine:3.18
WORKDIR /app

ARG USERNAME=sponsorblockcast
ARG UID=1000
ARG GID=$UID
RUN addgroup -g "$GID" "$USERNAME" \
    && adduser -S -u "$UID" -G "$USERNAME" "$USERNAME"

COPY --from=go-builder /app/sponsorblockcast ./

USER $UID
CMD ["./sponsorblockcast"]
