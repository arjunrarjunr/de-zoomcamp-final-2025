# This script is used to run Terraform commands inside a Docker container.
# It provides a consistent environment for running Terraform without requiring
# Terraform to be installed locally on the host machine.
#
# Key Features:
# - Uses the official HashiCorp Terraform Docker image to run commands.
# - Automatically mounts the current working directory to the container, allowing
#   Terraform to access configuration files and state files.
# - Mounts the local AWS credentials directory to the container, enabling Terraform
#   to authenticate with AWS services.
# - Automatically removes the container after execution to avoid clutter.
#
# Usage:
# - Save this script in the same directory as your Terraform configuration files.
# - Run it with any Terraform command as arguments, e.g., `./run_terraform.sh init`.
# - Example: `./run_terraform.sh plan` will execute `terraform plan` inside the container.
#
# Script Details:
# - `docker run`: Runs a Docker container.
# - `-it`: Allocates a pseudo-TTY and keeps STDIN open for interactive use.
# - `--rm`: Automatically removes the container after it exits.
# - `-v $(pwd):/app`: Mounts the current working directory to `/app` inside the container.
# - `-v /home/arjunr/.aws:/root/.aws`: Mounts the local AWS credentials directory to the container.
# - `-w /app`: Sets the working directory inside the container to `/app`.
# - `hashicorp/terraform:latest`: Specifies the Docker image for Terraform (latest version).
# - `$@`: Passes all arguments provided to this script to the Terraform command inside the container.
docker run -it --rm -v $(pwd):/app -v /home/arjunr/.aws:/root/.aws -w /app hashicorp/terraform:latest $@