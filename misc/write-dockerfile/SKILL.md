---
name: write-dockerfile
description: Generate or improve a project Dockerfile from verified repository context using modern Docker build practices. Use when the user asks to create, write, update, optimize, or modernize a Dockerfile or container image build.
---

# Write Dockerfile

Produce a small, correct Dockerfile whose every application-specific value comes from repository evidence, never invention.

Contract for every run:

- Inspect the repository before writing anything.
- Generate a Dockerfile when none fits, or improve the selected existing one in place.
- Derive each command, path, port, version, user, and health probe from inspected files.
- Apply an advanced technique only when the project shows a concrete need for it, and record why anything was left out.
- Consult [REFERENCE.md](REFERENCE.md) for official Docker syntax and feature semantics before authoring.

Modern does not mean maximal.
A minimal Dockerfile that omits inapplicable features is the correct result, not an incomplete one.

## Step 1: Resolve the target and inspect context

Find the file to write, then gather the evidence that determines its contents.

Target resolution order:

1. A path the user named explicitly.
2. The root `Dockerfile` when it exists.
3. A single other candidate such as `Dockerfile.dev`, `Dockerfile.prod`, or one under a deploy directory when it clearly matches the request.
4. A new root `Dockerfile` when none exists.

Ask which file to change only when several Dockerfiles serve materially different purposes that the request does not disambiguate.

Inspect, where present:

- Existing `Dockerfile*` files and `.dockerignore`.
- Package manifests and lockfiles, and any runtime version file.
- Build, start, and production scripts, and the application entrypoint.
- Listener and port configuration, and any health endpoint or native health command.
- Native system dependencies the application links against.
- `.env.example` and similar, reading variable names only, never values.
- CI and existing Compose configuration for platform, cache, and secret expectations.

Completion criterion: from evidence you know the dependency-install command, the build command if any, the runtime command, the files each phase needs, the runtime version when the repository pins one, and whether secrets, SSH, multiple target platforms, and a reliable healthcheck genuinely apply.

## Step 2: Decide which techniques apply

Run an explicit applicability pass and write down the verdict for each technique before authoring.

- `# syntax=docker/dockerfile:1` is always the first line, enabling BuildKit mount features.
- Named multi-stage build only when build-time and runtime concerns differ; a single stage stays single when extra stages add no size, isolation, cache, or parallelism benefit.
- Independent parallel stages only when their work is genuinely independent, so BuildKit can build them concurrently.
- Dependency-first layer order always: manifests and lockfiles copied and installed before general source.
- Cache mounts only where repeated downloads or compilation occur, targeting the detected tool's cache path.
- Platform arguments only for a real cross-platform or cross-compilation requirement.
- Build secret or SSH mounts only when the build actually consumes credentials or private access.
- A minimal, non-root runtime image always, unless the verified runtime requires otherwise.
- `HEALTHCHECK` only when a verified probe exists and the final image contains the tool to run it.
- `.dockerignore` is considered on every run.

## Step 3: Author or improve the Dockerfile

Write the resolved techniques as concrete instructions, keeping each one evidence-backed.

Syntax and stages:

- Place `# syntax=docker/dockerfile:1` as the first line.
- Name stages for their role, such as `deps`, `build`, and `runtime`, and copy only the required artifacts forward with `COPY --from`.
- Preserve existing user-defined targets that serve a documented purpose, and avoid serializing stages that could stay independent.

Cache and layer order:

- Copy lockfiles and manifests before source, and install in a cacheable layer using the project's locked or frozen install command when it supports one.
- Mount the package-manager or compiler cache with `RUN --mount=type=cache,target=<tool cache path>`, using `sharing=locked` for caches that need exclusive access such as apt.

Secrets and SSH:

- Pass build credentials through `RUN --mount=type=secret,id=<id>` and private access through `RUN --mount=type=ssh`, matching identifiers to existing build configuration.
- Keep credentials out of `ARG`, `ENV`, and `COPY`, since those persist in the image, `docker history`, and provenance.
- Keep legitimate non-sensitive build arguments as `ARG` when a build-time value is genuinely needed.

Multi-platform, only when needed:

- Pin the build stage native with `FROM --platform=$BUILDPLATFORM ... AS build`, re-declare `ARG TARGETOS` and `ARG TARGETARCH` inside each stage that uses them, and pass them to the compiler to cross-compile.
- Leave platform arguments out of interpreted applications that neither compile platform-specific artifacts nor state a multi-arch requirement.

Runtime safety:

- Select the runtime version from repository evidence and prefer a runtime-only or otherwise minimal supported image.
- Run as a non-root `USER` with ownership suited to the application, and add nothing to the runtime image the application or healthcheck does not need.

Healthcheck:

- Reuse a verified endpoint or native diagnostic command, ensure the probe tool exists in the final image, and never invent a path, port, or command.
- Omit the healthcheck and say so when no reliable probe exists.

`.dockerignore`:

- Preserve an existing `.dockerignore`, including negation patterns, and add exclusions for verified unnecessary context such as version-control metadata, local dependency directories, build outputs, caches, and local secret files.
- Create a minimal `.dockerignore` when one is absent and the context clearly holds unnecessary or sensitive files, keeping files that `COPY` needs available.

Completion criterion: every command, port, path, runtime version, and probe traces to project evidence, each included advanced feature has an identified reason, and inapplicable features are absent.

## Step 4: Validate

Run the strongest checks the environment allows.

- Lint the build with `docker build --check -f Dockerfile .`, then build a local test tag.
- For multi-platform configurations, build with `docker buildx build --platform <verified platforms> -f Dockerfile .` without publishing.

Never invent a registry destination or push an image.

When Docker is unavailable, perform a static review and state plainly which runtime checks did not run.

Completion criterion: the Dockerfile builds or lints cleanly when tooling is present, or the unrun checks are reported.

## Step 5: Report

State whether you created or improved the Dockerfile, any `.dockerignore` change, the validation commands and their results, the key evidence you relied on, and the advanced techniques you left out and why.

Do not paste a full generic Dockerfile template into this skill.
A template invites invented ports, users, and health endpoints, which is exactly the failure this skill exists to prevent.
