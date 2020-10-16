FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3-pip \
    git

COPY setup.py cfg.production.toml /src/
COPY homu/ /src/homu/

# Homu needs to be installed in "editable mode" (-e): when pip installs an
# application it resets the permissions of all source files to 644, but
# homu/git_helper.py needs to be executable (755). Installing in editable mode
# works around the issue since pip just symlinks the package to the source
# directory.
RUN pip3 install -e /src/

# Allow logs to show up timely on CloudWatch.
ENV PYTHONUNBUFFERED=1

CMD ["homu", "--verbose", "--config", "/src/cfg.production.toml"]