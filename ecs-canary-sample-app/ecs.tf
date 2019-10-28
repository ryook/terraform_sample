# cluster
resource "aws_ecs_cluster" "sample_app_canary_deploy" {
  name = "sample-app_canary-deploy"
}

# task
resource "aws_ecs_task_definition" "task_example" {
  family                   = "sample_app"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["EC2"]
  container_definitions    = "${file("./task_definition.json")}"
}

# servie_blue
resource "aws_ecs_service" "service_blue" {
  name                              = "example"
  cluster                           = "${aws_ecs_cluster.sample_app_canary_deploy.arn}"
  task_definition                   = "${aws_ecs_task_definition.task_example.arn}"
  desired_count                     = 1
  launch_type                       = "EC2" // default: EC2 
  health_check_grace_period_seconds = 1     // defautl:0 task起動に時間がかかると引っかるので0以上にしておく

  load_balancer {
    target_group_arn = "${aws_lb_target_group.green_target}"
    container_name   = "example"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = []
  }
}

# service_green
resource "aws_ecs_service" "service_green" {
  name                              = "example_green"
  cluster                           = "${aws_ecs_cluster.sample_app_canary_deploy.arn}"
  task_definition                   = "${aws_ecs_task_definition.task_example.arn}"
  desired_count                     = 1
  launch_type                       = "EC2" // default: EC2 
  health_check_grace_period_seconds = 1     // defautl:0 task起動に時間がかかると引っかるので0以上にしておく

  load_balancer {
    target_group_arn = "${aws_lb_target_group.example.arn}"
    container_name   = "example"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = []
  }
}
