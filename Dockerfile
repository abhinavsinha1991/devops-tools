FROM alpine:3.9 AS build

WORKDIR /

RUN apk add --update -t deps openssl curl wget tar gzip bash

RUN curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/$(curl -fsS https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && mv ./kubectl /usr/local/bin/kubectl

RUN curl -fsS https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh && chmod u+x install-helm.sh && ./install-helm.sh

FROM alpine:3.9

RUN apk add --update --no-cache git ca-certificates wget RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk

RUN apk add glibc-2.29-r0.apk

RUN apk add ansible

COPY --from=build /usr/local/bin/helm /bin/helm
COPY --from=build /usr/local/bin/tiller /bin/tiller 
COPY --from=build /usr/local/bin/kubectl /bin/kubectl
COPY --from=build /usr/local/bin/ansible /bin/ansible
COPY --from=build /usr/local/bin/ansible-galaxy /bin/ansible-galaxy
COPY --from=build /usr/local/bin/ansible-playbook /bin/ansible-playbook
