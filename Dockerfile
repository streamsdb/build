FROM golang:1.11
ENV CGO_ENABLED 1
ENV GOOS linux
ENV GOARCH amd64

# Install git.
# Git is required for fetching the dependencies.
RUN apt update -y -q \
 && apt install -y -q git mono-devel m4 dnsutils \
 && wget https://www.foundationdb.org/downloads/6.0.15/ubuntu/installers/foundationdb-clients_6.0.15-1_amd64.deb \
 && dpkg -i foundationdb-clients_6.0.15-1_amd64.deb \
 && rm foundationdb-clients_6.0.15-1_amd64.deb \
 && git clone https://github.com/apple/foundationdb.git $GOPATH/src/github.com/apple/foundationdb \
 && cd /go/src/github.com/apple/foundationdb/bindings/go \
 && git reset --hard origin/release-6.0 \
 && ./fdb-go-install.sh localinstall

ADD https://raw.githubusercontent.com/apple/foundationdb/master/packaging/docker/create_cluster_file.bash /scripts/create_cluster_file.bash
RUN chmod +x /scripts/create_cluster_file.bash
