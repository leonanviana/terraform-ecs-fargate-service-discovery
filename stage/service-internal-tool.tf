resource "aws_ecs_service" "internal_tool" {
  name                   = "${local.prefix}-internal-tool"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.task_internal_tool.id
  enable_execute_command = true
  desired_count          = var.app_count
  launch_type            = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.internal_tool_sg.id]
    subnets          = [module.vpc.private_subnets[1]]
    assign_public_ip = false
  }

  # ECS Service Connect uses the Cloud Map namespace for service-to-service communication
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.ecs.name
  }

  # Registers this task's IP into Cloud Map DNS
  # Nginx resolves: internal-tool.myapp.internal → task IP
  service_registries {
    registry_arn   = aws_service_discovery_service.internal_tool.arn
    container_name = "myapp-internal-tool"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_controller {
    type = "ECS"
  }

  force_new_deployment = true
}

resource "aws_cloudwatch_log_group" "internal_tool_logs" {
  name              = "/ecs/${local.prefix}/internal-tool"
  retention_in_days = 7
  tags              = local.computed_tags
}
