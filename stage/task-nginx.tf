data "template_file" "nginx" {
  template = file("templates/nginx-json.tpl")

  vars = {
    region     = var.region
    app_prefix = local.prefix
  }
}

resource "aws_ecs_task_definition" "task_nginx" {
  family                   = "${local.prefix}-nginx-task"
  task_role_arn            = var.execution_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = data.template_file.nginx.rendered
}
