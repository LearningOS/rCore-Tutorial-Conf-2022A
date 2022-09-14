ARG BASE_IMG=ubuntu:20.04
FROM ${BASE_IMG}

ARG DESKTOP_MACHINE=no
ARG QEMU_VER=7.0.0
ARG CARGO_HOME="/usr/local/cargo"
ARG RUSTUP_HOME="/usr/local/rustup"

COPY scripts /tmp/

RUN echo ipv4 >> ~/.curlrc \
    && /bin/bash "tmp/base.sh" \
    && /bin/bash "tmp/apply-qemu.sh" \
    && /bin/bash "tmp/apply-rust.sh" \
    && apt clean autoclean \
    && apt autoremove --purge -y \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="${PATH}:${CARGO_HOME}/bin:/usr/local/share" CARGO_HOME="${CARGO_HOME}" RUSTUP_HOME="${RUSTUP_HOME}"