ARG CONTRAIL_REGISTRY
ARG CONTRAIL_CONTAINER_TAG
ARG CONTAINER_PREFIX
FROM ${CONTRAIL_REGISTRY}/${CONTAINER_PREFIX}-general-base:${CONTRAIL_CONTAINER_TAG}
ARG VENDOR_DOMAIN

ARG CONTAINER_NAME
LABEL name=$CONTAINER_NAME \
      summary="Mellanox plugin for RedHat" \
      description="DPDK Mellanox kernel module for RedHat."

# this copy should be before yum install
COPY *.repo /etc/yum.repos.d/

RUN yum update -y && \
    yum install --downloadonly -y mlnx-ofed-dpdk-upstream-libs

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

LABEL $VENDOR_DOMAIN".container.name"=$CONTAINER_NAME
