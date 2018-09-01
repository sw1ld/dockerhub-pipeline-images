FROM centos:7

RUN yum install -y epel-release \
    && yum install -y openssh-clients git ansible python-six python-passlib python-lxml pyOpenSSL python-cryptography \
        patch httpd-tools java-1.8.0-openjdk-headless python-boto python-boto3 \
    && rm -rf /var/cache/yum

ENTRYPOINT ["/usr/bin/ansible-playbook"]