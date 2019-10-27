resource "aws_lb" "alb_sample" {
  name                       = "ecs-sample-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false
  subnets = [
    "subnet-871b10ce",
    "subnet-ad682df6",
    "subnet-681b0640"
  ]
  security_groups = [
    "sg-b47d57cc"
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_sample.arn
  port              == "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "test"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "example" {
  name        = "ecs-sample-lb-target"
  vpc_id      = "vpc-994c0efe"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  depends_on  = [aws_lb.example]
}


resource "aws_lb_listener_rule" "example" {
  listener_arn = aws_lb_listener.http.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}
