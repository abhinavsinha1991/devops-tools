FROM alpine:3.9 AS build

WORKDIR /

RUN apk add --update -t deps openssl curl wget tar gzip bash

RUN curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/$(curl -fsS https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && mv ./kubectl /usr/local/bin/kubectl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod u+x get_helm.sh && ./get_helm.sh

FROM alpine:3.9

RUN apk add --update --no-cache git ca-certificates wget 

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub 

RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk

RUN apk add glibc-2.29-r0.apk

RUN apk add ansible

RUN apk add bash py-pip
RUN apk add gcc libffi-dev musl-dev openssl-dev python-dev make
RUN pip install azure-cli

COPY --from=build /usr/local/bin/helm /bin/helm
COPY --from=build /usr/local/bin/kubectl /bin/kubectl

RUN chmod +x /bin/helm && chmod +x /bin/kubectl
