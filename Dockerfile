FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        curl \
        gnupg

# Add TensorFlow Serving repo

RUN echo "deb [arch=amd64] http://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal" | tee /etc/apt/sources.list.d/tensorflow-serving.list
# Ignore the warning about using apt-key output - we are not
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN curl -s https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | apt-key add -

# Get the model-server, use tensorflow-model-server-universal for older hardware
RUN apt-get update && apt-get install -y \
        tensorflow-model-server

# Cleanup to reduce the size of the image
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run
RUN  apt-get clean && \
        rm -rf /var/lib/apt/lists/*

ENV TINI_VERSION v0.17.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

RUN chmod +x /tini

ENTRYPOINT ["/tini", "--"]
