# terraform-ecs-fargate-service-discovery

> [Português](#português) | [English](#english)

---

## Português

Exemplo em Terraform demonstrando o uso do **AWS Cloud Map Service Discovery** com **ECS Fargate**.

Todos os serviços rodam em subnets privadas, sem IP público. O serviço interno se registra em um namespace DNS privado do Cloud Map (`myapp.internal`), e o Nginx resolve esse nome via `proxy_pass` para rotear o tráfego internamente na VPC.

### Arquitetura

```
VPC (privada)
    │
    ▼
 [Nginx - ECS Fargate]  ← subnet privada, sem IP público
    │
    │  proxy_pass via DNS do Cloud Map
    └──► internal-tool.myapp.internal → [Internal Tool - ECS Fargate]
```

### Estrutura

```
stage/
├── main.tf                    # Providers Terraform, backend, módulo VPC
├── locals.tf                  # Prefixo e tags comuns
├── variables.tf               # Todas as variáveis de entrada
├── cloudmap.tf                # Namespace Cloud Map + registros de service discovery
├── cluster.tf                 # Cluster ECS
├── cluster-sg.tf              # Security groups e regras
├── service-nginx.tf           # ECS service do Nginx + CloudWatch log group
├── task-nginx.tf              # Task definition do Nginx
├── service-internal-tool.tf   # ECS service da ferramenta interna + registro no Cloud Map
├── task-internal-tool.tf      # Task definition da ferramenta interna
└── templates/
    ├── nginx-json.tpl          # Definição do container Nginx
    └── internal-tool-json.tpl # Definição do container da ferramenta interna
```

### Conceitos principais

#### Namespace DNS privado do Cloud Map

Cria uma zona DNS `myapp.internal` privada à VPC:

```hcl
resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name = "myapp.internal"
  vpc  = module.vpc.vpc_id
}
```

#### Registro de Service Discovery

Cada serviço interno registra os IPs de suas tasks no Cloud Map:

```hcl
service_registries {
  registry_arn   = aws_service_discovery_service.internal_tool.arn
  container_name = "myapp-internal-tool"
}
```

Após o registro, `internal-tool.myapp.internal` resolve automaticamente para o IP da task ativa a cada deploy ou evento de escalonamento.

#### Service Connect

Habilita o sidecar proxy do ECS para tráfego entre serviços, com métricas embutidas:

```hcl
service_connect_configuration {
  enabled   = true
  namespace = aws_service_discovery_private_dns_namespace.ecs.name
}
```

### Pré-requisitos

- Conta AWS com permissões para ECS, ECR e VPC
- Bucket S3 para o estado remoto do Terraform
- IAM role `ecsTaskExecutionRole` com as managed policies do ECS

### Como usar

1. Copie `terraform.tfvars.example` para `terraform.tfvars` e preencha os valores
2. Atualize o nome do bucket no backend em `main.tf`
3. Execute a partir do diretório `stage/`:

```bash
terraform init
terraform plan
terraform apply
```

### Variáveis

| Variável | Descrição |
|---|---|
| `region` | Região AWS |
| `app_image` | URI da imagem ECR da ferramenta interna |
| `execution_role_arn` | ARN da IAM role para execução das tasks ECS |

---

## English

Terraform example demonstrating **AWS Cloud Map Service Discovery** with **ECS Fargate**.

All services run in private subnets without public IPs. The internal tool registers itself in a Cloud Map private DNS namespace (`myapp.internal`), and Nginx resolves it via `proxy_pass` to route traffic internally within the VPC.

### Architecture

```
VPC (private)
    │
    ▼
 [Nginx - ECS Fargate]  ← private subnet, no public IP
    │
    │  proxy_pass via Cloud Map DNS
    └──► internal-tool.myapp.internal → [Internal Tool - ECS Fargate]
```

### Structure

```
stage/
├── main.tf                    # Terraform providers, backend, VPC module
├── locals.tf                  # Prefix and common tags
├── variables.tf               # All input variables
├── cloudmap.tf                # Cloud Map namespace + service discovery records
├── cluster.tf                 # ECS cluster
├── cluster-sg.tf              # Security groups and rules
├── service-nginx.tf           # Nginx ECS service + CloudWatch log group
├── task-nginx.tf              # Nginx task definition
├── service-internal-tool.tf   # Internal tool ECS service + Cloud Map registration
├── task-internal-tool.tf      # Internal tool task definition
└── templates/
    ├── nginx-json.tpl          # Nginx container definition
    └── internal-tool-json.tpl # Internal tool container definition
```

### Key Concepts

#### Cloud Map Private DNS Namespace

Creates a DNS zone `myapp.internal` private to the VPC:

```hcl
resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name = "myapp.internal"
  vpc  = module.vpc.vpc_id
}
```

#### Service Discovery Registration

Each internal service registers its task IPs into Cloud Map:

```hcl
service_registries {
  registry_arn   = aws_service_discovery_service.internal_tool.arn
  container_name = "myapp-internal-tool"
}
```

After registration, `internal-tool.myapp.internal` resolves to the active task IP automatically on every deploy or scale event.

#### Service Connect

Enables the ECS proxy sidecar for inter-service traffic with built-in metrics:

```hcl
service_connect_configuration {
  enabled   = true
  namespace = aws_service_discovery_private_dns_namespace.ecs.name
}
```

### Prerequisites

- AWS account with ECS, ECR, and VPC permissions
- S3 bucket for Terraform remote state
- IAM role `ecsTaskExecutionRole` with ECS managed policies

### Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in values
2. Update `main.tf` backend bucket name
3. Run from the `stage/` directory:

```bash
terraform init
terraform plan
terraform apply
```

### Variables

| Variable | Description |
|---|---|
| `region` | AWS region |
| `app_image` | ECR image URI for the internal tool |
| `execution_role_arn` | IAM role ARN for ECS task execution |
