# This script runs Terraform commands inside a Docker container.
# 
# Explanation of the command:
# - `docker run`: Runs a Docker container.
# - `-it`: Allocates a pseudo-TTY and keeps the STDIN open, allowing interactive use.
# - `--rm`: Automatically removes the container once it exits, ensuring no leftover containers.
# - `-v $(pwd):/app`: Mounts the current working directory (`$(pwd)`) on the host machine 
#   to the `/app` directory inside the container. This allows Terraform to access the 
#   configuration files in the current directory.
# - `-w /app`: Sets the working directory inside the container to `/app`, where the 
#   Terraform configuration files are expected to be located.
# - `hashicorp/terraform:latest`: Specifies the Docker image to use, in this case, the 
#   latest version of the official HashiCorp Terraform image.
# - `$@`: Passes all arguments provided to this script directly to the `terraform` 
#   command inside the container. For example, if you run `./run_terraform.sh init`, 
#   it will execute `terraform init` inside the container.
#
# Usage:
# - Place this script in the same directory as your Terraform configuration files.
# - Run it with any Terraform command as arguments, e.g., `./run_terraform.sh plan`.
docker run -it --rm -v $(pwd):/app -w /app hashicorp/terraform:latest $@