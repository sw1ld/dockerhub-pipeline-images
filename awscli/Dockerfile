FROM centos:7

ENV PAGER="more"

RUN yum install -y epel-release && \
    yum install -y jq python-pip zip && \
    pip install --no-cache --upgrade awscli

# Expose volume for adding credentials
VOLUME ["~/.aws"]

ENTRYPOINT ["/usr/bin/aws"]
CMD ["--version"]