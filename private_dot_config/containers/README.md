# Containers / Podman

## Basic Justfile for app repositories

```just
APP_NAME := "my-app"

# Build the Dockerfile container image using Podman
podman-build:
  podman build --platform linux/amd64 -t {{APP_NAME}}:latest .

# Tag the container image with the short Git commit hash using Podman
podman-tag:
  podman tag {{APP_NAME}}:latest {{APP_NAME}}:sha-$(git rev-parse --short HEAD)
  echo -e "\nTagged container image:\n\n   {{APP_NAME}}:sha-$(git rev-parse --short HEAD)\n"

# Analyze the container image with Podman
podman-history:
  podman history {{APP_NAME}}:latest

# Dive into the Podman container image with Dive
podman-dive:
  dive --source podman {{APP_NAME}}:latest

# Run the container image with Podman
podman-run:
  podman run -it --rm -p 3000:3000 {{APP_NAME}}:latest
```
