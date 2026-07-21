# Docker Compose reference index

Official Docker documentation is the source of truth.
Consult the relevant link before authoring the matching part of the Compose file, and follow the current field semantics there rather than any remembered form.

- [Compose file reference](https://docs.docker.com/reference/compose-file/) - the current Compose Specification entry point, including the absence of a top-level `version` key.
- [Compose Build Specification](https://docs.docker.com/reference/compose-file/build/) - `context`, `dockerfile`, `target`, `platforms`, `cache_from`, `cache_to`, build `secrets`, and `ssh`.
- [Compose services reference](https://docs.docker.com/reference/compose-file/services/) - service `platform`, `healthcheck`, `depends_on` conditions, `environment`, `ports`, and `volumes`.
- [Compose secrets reference](https://docs.docker.com/reference/compose-file/secrets/) - top-level secret sources such as `file` and `external`, and how services reference them.
- [Use secrets in Compose](https://docs.docker.com/compose/how-tos/use-secrets/) - granting secrets to services and consuming them from `/run/secrets/<name>`.
- [Control startup and shutdown order](https://docs.docker.com/compose/how-tos/startup-order/) - `depends_on` with `service_started`, `service_healthy`, and `service_completed_successfully`.
