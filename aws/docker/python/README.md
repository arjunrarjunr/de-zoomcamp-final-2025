# LAMBDA IMAGE
## Prerequisites
* [Docker Installed](https://www.docker.com/get-started/)
* Create ECR
```go
resource "aws_ecr_repository" "my_ecr_repo" {
  name  = var.docker_repo
  tags = {
    Name        = var.docker_repo
    Environment = "dev"
  }
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
```

## Steps

### Step-1
```bash
docker build -t lambda-ingestion:latest .
```

### Step-2
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 314146310890.dkr.ecr.us-east-1.amazonaws.com
```

### Step-3
```bash
docker tag lambda-ingestion:latest 314146310890.dkr.ecr.us-east-1.amazonaws.com/lambda-ingestion:latest
```

### Step-4
```bash
docker push 314146310890.dkr.ecr.us-east-1.amazonaws.com/lambda-ingestion:latest
```