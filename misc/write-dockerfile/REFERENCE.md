# Dockerfile reference index

Official Docker documentation is the source of truth.
Consult the relevant link before authoring the matching part of the Dockerfile, and follow the current syntax there rather than any remembered form.

- [Dockerfile reference](https://docs.docker.com/reference/dockerfile/) - the `# syntax` directive, `ARG` versus `ENV` scope, `USER`, `HEALTHCHECK` options and defaults, and `RUN --mount` syntax.
- [Multi-stage builds](https://docs.docker.com/build/building/multi-stage/) - named stages, `COPY --from`, `--target`, and BuildKit skipping and parallelizing independent stages.
- [Optimize cache usage](https://docs.docker.com/build/cache/optimize/) - dependency-first layer order, `.dockerignore`, bind mounts, and `RUN --mount=type=cache` targets per ecosystem including apt `sharing=locked`.
- [Build secrets](https://docs.docker.com/build/building/secrets/) - `--mount=type=secret` and `--mount=type=ssh`, default mount paths, and why secrets must never enter `ARG`, `ENV`, or `COPY`.
- [Multi-platform builds](https://docs.docker.com/build/building/multi-platform/) - `--platform`, the `BUILDPLATFORM` and `TARGET*` automatic arguments, and native-build plus cross-compile to avoid slow emulation.
- [Build best practices](https://docs.docker.com/build/building/best-practices/) - stage design, base image selection, image size, non-root runtime, and rebuild behavior.
