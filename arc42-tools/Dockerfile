FROM adorsys/java:8

USER 0

RUN yum -q -y install ruby fontconfig graphviz rubygem-asciidoctor jq && \
    yum -q -y groupinstall "Development Tools" && \
    mkdir /usr/local/share/plantuml && \
    curl -s -L http://sourceforge.net/projects/plantuml/files/plantuml.1.2018.12.jar/download --output /usr/local/share/plantuml/plantuml.jar && \
    yum clean all && rm -rf /var/cache/yum

ADD root /

CMD ["/bin/bash"]

USER 1001
