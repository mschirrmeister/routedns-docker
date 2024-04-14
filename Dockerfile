FROM golang:1.22 as builder

ENV APP_USER app
ENV APP_HOME /app
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME/build && chown -R $APP_USER:$APP_USER $APP_HOME
WORKDIR $APP_HOME/build
USER $APP_USER

ARG TARGETOS
ARG TARGETARCH
ARG CGO_ENABLED=0

# build master branch
# RUN git clone https://github.com/folbricht/routedns .

# build stable release
# RUN git clone https://github.com/folbricht/routedns . \
#     && git checkout tags/v0.1.51 -b v0.1.51
# or
# RUN git clone --depth 1 -b v0.1.51 https://github.com/folbricht/routedns .
# or
# RUN git clone https://github.com/folbricht/routedns --branch v0.1.51 .

# build specific commit
RUN git clone https://github.com/folbricht/routedns . \
    && git checkout c4fb53f6148751ad1982a74a262d6896725e4e1b && git reset --hard

WORKDIR $APP_HOME/build/cmd/routedns

# https://opensource.com/article/22/4/go-build-options
RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go clean \
    && go build -ldflags="-s -w" \
    && cp -p routedns $APP_HOME/

WORKDIR $APP_HOME

RUN rm -rf build

FROM alpine:3.19.1

ENV APP_HOME /app
WORKDIR $APP_HOME

ENV LOCAL_PORT 53

COPY --chown=0:0 --from=builder $APP_HOME/routedns $APP_HOME

ADD routedns.toml /app/routedns.toml
ADD server.key /app/server.key
ADD server.crt /app/server.crt

EXPOSE $LOCAL_PORT/tcp $LOCAL_PORT/udp

ENTRYPOINT ["./routedns"]

CMD ["/app/routedns.toml", "--log-level", "4"]
