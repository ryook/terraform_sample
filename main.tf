provider "aws" {
  region     = "ap-northeast-1"
  access_key = ""
  secret_key = ""
}


# # serivce2
# resource "aws_ecs_service" "service_example2" {
#   name                              = "example2"
#   cluster                           = aws_ecs_cluster.sample_canary_deploy.arn
#   task_definition                   = aws_ecs_task_definition.task_example.arn
#   desired_count                     = 2
#   launch_type                       = "EC2" // default: EC2 
#   health_check_grace_period_seconds = 3     // defautl:0 task起動に時間がかかると引っかるので0以上にしておく
#   load_balancer {
#     target_group_arn = aws_lb_target_group.example2.arn
#     container_name   = "example"
#     container_port   = 80
#   }
#   lifecycle {
#     ignore_changes = []
#   }
# }
# resource "aws_lb" "example2" {
#   name                       = "ecs-sample-alb2"
#   load_balancer_type         = "application"
#   internal                   = false
#   idle_timeout               = 60
#   enable_deletion_protection = false
#   subnets = [
#     "subnet-871b10ce",
#     "subnet-ad682df6",
#     "subnet-681b0640"
#   ]
#   security_groups = [
#     "sg-b47d57cc"
#   ]
# }
# resource "aws_lb_listener" "http2" {
#   load_balancer_arn = aws_lb.example2.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "test"
#       status_code  = "200"
#     }
#   }
# }
# resource "aws_lb_target_group" "example2" {
#   name        = "ecs-sample-lb-target2"
#   vpc_id      = "vpc-994c0efe"
#   target_type = "instance"
#   port        = 80
#   protocol    = "HTTP"
#   depends_on = [aws_lb.example2]
# }
# resource "aws_lb_listener_rule" "example2" {
#   listener_arn = aws_lb_listener.http2.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.example2.arn
#   }
#   condition {
#     field  = "path-pattern"
#     values = ["/*"]
#   }
# }
