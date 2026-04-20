alias podman-socket='podman machine inspect --format "{{.ConnectionInfo.PodmanSocket.Path}}"'
alias lazypodman='DOCKER_HOST=unix://$(podman-socket) lazydocker'
