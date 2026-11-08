# Jenkins with R installed, so pipeline steps can call Rscript directly.
# Once this works, swap "lts-jdk17" for a specific version tag so every
# rebuild produces the same image.
FROM jenkins/jenkins:lts-jdk17

USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      r-base-core \
      r-cran-testthat \
      r-cran-pkgload \
      r-cran-xml2 \
 && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

USER jenkins
