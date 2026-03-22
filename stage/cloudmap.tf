resource "aws_service_discovery_private_dns_namespace" "ecs" {
  name        = "myapp.internal"
  vpc         = module.vpc.vpc_id
  description = "Private DNS namespace for myapp ECS services"
}

resource "aws_service_discovery_service" "internal_tool" {
  name = "internal-tool"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {}
}
