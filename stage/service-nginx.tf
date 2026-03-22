resource "aws_ecs_service" "nginx" {
  name                   = "${local.prefix}-nginx"
  cluster                = aws_ecs_cluster.main.id
  task_definition        = aws_ecs_task_definition.task_nginx.id
  enable_execute_command = true
  desired_count          = var.app_count
  launch_type            = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.nginx_ecs_sg.id]
    subnets          = [module.vpc.private_subnets[0]]
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_controller {
    type = "ECS"
  }

  force_new_deployment = true
}

resource "aws_cloudwatch_log_group" "nginx_logs" {
  name              = "/ecs/${local.prefix}/nginx"
  retention_in_days = 7
  tags              = local.computed_tags
}
