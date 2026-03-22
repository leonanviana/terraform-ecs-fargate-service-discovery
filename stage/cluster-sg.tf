#### SECURITY GROUPS ####

resource "aws_security_group" "nginx_ecs_sg" {
  name   = "${local.prefix}-nginx-ecs-sg"
  vpc_id = module.vpc.vpc_id
  tags   = { Name = "${local.prefix}-nginx-ecs-sg" }
}

resource "aws_security_group" "internal_tool_sg" {
  name   = "${local.prefix}-internal-tool-sg"
  vpc_id = module.vpc.vpc_id
  tags   = { Name = "${local.prefix}-internal-tool-sg" }
}


#### NGINX ECS RULES ####

resource "aws_vpc_security_group_egress_rule" "nginx_egress_ipv4" {
  security_group_id = aws_security_group.nginx_ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "nginx_egress_ipv6" {
  security_group_id = aws_security_group.nginx_ecs_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "nginx_ingress_80" {
  security_group_id = aws_security_group.nginx_ecs_sg.id
  cidr_ipv4         = "10.0.0.0/23"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}


#### INTERNAL TOOL RULES ####

resource "aws_vpc_security_group_egress_rule" "internal_tool_egress_ipv4" {
  security_group_id = aws_security_group.internal_tool_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "internal_tool_egress_ipv6" {
  security_group_id = aws_security_group.internal_tool_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

# Only accepts traffic from within the VPC (nginx proxy)
resource "aws_vpc_security_group_ingress_rule" "internal_tool_ingress_http" {
  security_group_id = aws_security_group.internal_tool_sg.id
  cidr_ipv4         = "10.0.0.0/23"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
