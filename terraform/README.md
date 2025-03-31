# Terraform
[Terraform](https://developer.hashicorp.com/terraform/tutorials) is an open-source Infrastructure as Code (IaC) tool that allows you to define and provision infrastructure using a declarative configuration language. It enables you to manage resources across various cloud providers and on-premises environments in a consistent and repeatable manner.

With Terraform, you can:

- Define infrastructure in code, making it version-controlled and shareable.
- Automate the provisioning and management of resources.
- Use a single workflow to manage multiple cloud providers.
- Plan and preview changes before applying them to ensure accuracy.

Terraform's state management and modular approach make it a powerful tool for building and scaling infrastructure efficiently.

## Docker
[Docker](https://www.docker.com/get-started/) is an open-source platform designed to automate the deployment of applications inside lightweight, portable containers. Containers package an application and its dependencies together, ensuring consistency across development, testing, and production environments.

With Docker, you can:

- Build, ship, and run applications in isolated environments.
- Simplify application deployment and scaling.
- Use pre-built images from Docker Hub or create custom ones.
- Ensure compatibility across different systems by standardizing the runtime environment.

Docker's containerization approach enhances efficiency, reduces overhead, and accelerates software delivery.

### Terraform Docker Image
The [Terraform Docker image](https://hub.docker.com/r/hashicorp/terraform) is a pre-configured container that includes all the necessary dependencies to run Terraform. By using this image, you can avoid installing Terraform directly on your local machine, ensuring a consistent and isolated environment for managing infrastructure.

This approach simplifies the setup process and allows you to leverage Docker's portability to run Terraform commands seamlessly. The image can be pulled from a container registry or built locally, depending on your requirements.

To simplify running commands, I created a bash script named `run_terraform.sh`.

## Example Commands

Here are some sample commands to use with the `run_terraform.sh` script:

```bash
# Initialize Terraform
./run_terraform.sh init

# Plan the infrastructure changes
./run_terraform.sh plan

# Apply the infrastructure changes
./run_terraform.sh apply

# Destroy the infrastructure
./run_terraform.sh destroy
```


