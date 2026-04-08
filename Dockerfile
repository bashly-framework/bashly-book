FROM node:latest

# Create and set working directory
WORKDIR /app

# Ensure bash is available (it already is in Debian-based images, but explicit is fine)
SHELL ["/bin/bash", "-c"]

# Default entrypoint: interactive bash
ENTRYPOINT ["/bin/bash"]
