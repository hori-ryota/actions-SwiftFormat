ARG SWIFT_VERSION='5.1'

FROM swift:$SWIFT_VERSION as builder
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
      && apt-get -y install wget --no-install-recommends \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

ARG SWIFTFORMAT_VERSION='0.40.14'

RUN wget -qO - "https://github.com/nicklockwood/SwiftFormat/archive/${SWIFTFORMAT_VERSION}.tar.gz" | tar xz
RUN mv SwiftFormat-${SWIFTFORMAT_VERSION} SwiftFormat

RUN cd SwiftFormat && swift build -c release

FROM swift:$SWIFT_VERSION

COPY --from=builder SwiftFormat/.build/release/swiftformat /usr/local/bin/
ENTRYPOINT ["swiftformat"]
