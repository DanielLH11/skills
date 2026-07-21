---
name: write-compose
description: Generate or improve minimal Docker Compose configuration from verified repository context using the Compose Specification. Use when the user asks to create, write, update, optimize, or modernize compose.yaml, compose.yml, docker-compose.yaml, or docker-compose.yml.
---

# Write Docker Compose

Produce the smallest Compose file that expresses the project's verified local topology, adding no service or field that evidence does not support.

Contract for every run:

- Inspect the application and its Dockerfile before writing Compose configuration.
- Generate `compose.yaml` only when no Compose file exists, and improve an existing recognized file in place otherwise.
- Use the current Compose Specification with no top-level `version` key.
- Include only services and fields backed by repository evidence or an explicit request.
- Consult [REFERENCE.md](REFERENCE.md) for official Compose field semantics before authoring.

Modern does not mean maximal.
A single-service file with no secrets, healthchecks, or platform fields is the correct result when nothing more is warranted.

## Step 1: Resolve the target and inspect context

Find the file to write, then gather the evidence that determines its contents.

Recognize these filenames: `compose.yaml`, `compose.yml`, `docker-compose.yaml`, `docker-compose.yml`.

Target resolution:

1. A file the user named explicitly.
2. The single existing Compose file, improved in place.
3. A new `compose.yaml` when none exists.

Do not create `compose.yaml` beside an existing `docker-compose.yml` unless the user asks for a migration or a separate configuration.
When several Compose files represent different environments or overrides, infer the target from the request and ask only when changing the wrong one would be harmful.

Inspect, where present:

- Every recognized Compose filename, plus override files and profiles.
- Dockerfiles and their named build stages.
- Package manifests, application scripts, and listener or port configuration.
- `.env.example` and similar, reading variable names only, never values.
- Infrastructure services the application actually connects to, and any existing volumes or data directories.
- Health endpoints or native health commands, and any CI cache or registry configuration.

Completion criterion: from evidence you know which services are actually needed, which build locally versus use a published image, the verified ports and commands, the real dependency relationships, the available health probes, any required named build target, and whether build or runtime secrets and platform fields genuinely apply.

## Step 2: Select the minimum applicable configuration

Decide the smallest configuration that is still correct.

- Omit the top-level `version` key, and remove it when improving a legacy file.
- Include only verified services, and prefer Dockerfile defaults over repeating `command`, `entrypoint`, or ports without need.
- Use `build.target` only when the Dockerfile has a relevant named stage.
- Use `build.platforms` and service `platform` only for a real multi-arch requirement, keeping them consistent with each other and with the Dockerfile's cross-compilation behavior.
- Use `cache_from` and `cache_to` only when a verified CI, registry, or local cache design supplies meaningful locations.
- Grant build `secrets` or `ssh` only when the Dockerfile consumes the matching `--mount`.
- Use runtime `secrets` when a service consumes sensitive data from a file, rather than passing values through environment entries.
- Add a `healthcheck` only when a reliable probe is known, and use long-form `depends_on` with `condition: service_healthy` only when the dependency defines that healthcheck.
- Leave out speculative databases, networks, volumes, profiles, replicas, resource limits, and environment variables.

## Step 3: Author or improve the Compose file

Write the resolved configuration, keeping each field evidence-backed.

Specification and structure:

- Use modern Compose Specification fields with no top-level `version`, and preserve valid existing extensions, profiles, overrides, and project structure.
- Prefer the smallest configuration that expresses the verified topology.

Build configuration, used conditionally:

- Set `context` and `dockerfile` only when defaults do not describe the build, `target` when a relevant named stage exists, and `platforms` only for multi-platform output.
- Set `cache_from` and `cache_to` only with verified cache storage, and add `secrets` or `ssh` only to match the Dockerfile's mounts.
- Pass build `args` only for non-sensitive values the verified Dockerfile requires.

Runtime configuration:

- Declare runtime secrets at the top level and grant them only to the services that consume them, preferring file-based consumption the application supports.
- Declare ports only when host exposure is required, relying on Compose service DNS for internal service-to-service traffic.
- Add volumes only for verified persistence or development bind-mount needs, and set environment variables only when their names and purpose are verified.

Health and startup order:

- Use an endpoint or native command known to work, never an invented one, and write healthcheck commands and variables with the correct Compose interpolation form.
- Use `depends_on` with `condition: service_healthy` only for dependencies that become ready asynchronously and expose a working healthcheck, and use plain startup ordering otherwise.

Platform consistency:

- Keep the service runtime platform compatible with the image being built or pulled, and avoid forcing a host-incompatible platform or adding multi-platform output settings to a normal `docker compose up` workflow.

Completion criterion: every service, port, volume, secret, target, platform, and dependency has repository evidence, health-based dependencies point only to services with working healthchecks, build secret and SSH grants match Dockerfile mounts, and there is no top-level `version` key.

## Step 4: Validate

Run the strongest checks the environment safely allows.

- Resolve the file with `docker compose -f <file> config --quiet`, then inspect the rendered output with `docker compose -f <file> config` when useful.
- In a disposable fixture where startup is safe, continue with `build`, then `up --detach --wait`, then `down`; use `down --volumes` only when deleting fixture data is intended.

Use `up --wait` only when every service can start without unknown credentials, destructive initialization, or external infrastructure.

When runtime startup is unsafe or blocked, validate configuration and builds and report the unrun checks.

Completion criterion: the configuration resolves with no schema or interpolation error, or the unrun checks are reported.

## Step 5: Report

State which Compose file you created or improved, whether a legacy filename was intentionally preserved, the services and relationships you inferred, the checks that ran and their outcomes, and the advanced fields you left out as inapplicable.
