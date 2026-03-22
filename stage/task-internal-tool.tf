data "template_file" "internal_tool" {
  template = file("templates/internal-tool-json.tpl")

  vars = {
    app_image  = var.app_image
    cpu        = var.fargate_cpu
    memory     = var.fargate_memory
    port       = var.app_port_app
    region     = var.region
    app_prefix = local.prefix
  }
}

resource "aws_ecs_task_definition" "task_internal_tool" {
  family                   = "${local.prefix}-internal-tool-task"
  task_role_arn            = var.execution_role_arn
  execution_role_arn       = var.execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.internal_tool.rendered
}
