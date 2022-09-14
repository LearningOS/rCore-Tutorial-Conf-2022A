ARG USER_BASE_IMG=rCore-Tutorial:base
FROM ${USER_BASE_IMG}

ARG UID
ARG UNAME
ARG GID
ARG GROUP

RUN apt update -q \
    && apt install -y --no-install-recommends \
    # Add more dependencies here
    sudo \
    # end of list
    && /bin/bash /tmp/utils/user.sh

VOLUME /home/${UNAME}