# Builder
# https://steele.blue/tiny-github-actions/
FROM dyweb/go-dev:1.13.6 as builder
LABEL maintainer="contact@dongyue.io"

ARG PROJECT_ROOT=/go/src/github.com/dyweb/weekly
ENV WEEKLY_GEN_VERSION=v0.3.5
WORKDIR $PROJECT_ROOT

RUN curl -sSL https://github.com/dyweb/dy-weekly-generator/releases/download/$WEEKLY_GEN_VERSION/dy-weekly-generator-$WEEKLY_GEN_VERSION-x86_64-unknown-linux-gnu.tar.gz \
       | tar -vxz -C /usr/bin
COPY . $PROJECT_ROOT
RUN cd scripts/weekly && go install .

# Runner
FROM ubuntu:18.04
LABEL maintainer="contact@dongyue.io"
# NOTE: libssl is required by weekly-gen
RUN apt update && apt install -y libssl1.0.0

WORKDIR /usr/bin

COPY --from=builder /usr/bin/weekly-gen .
COPY --from=builder /go/bin/weekly .

ENTRYPOINT ["weekly"]
CMD ["help"]