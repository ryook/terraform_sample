resource "aws_lb" "alb_sample" {
  name                       = "ecs-sample-alb"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  enable_deletion_protection = false
  subnets = [
    "subnet-a",
    "subnet-b",
    "subnet-c"
  ]
  security_groups = [
    "sg-1"
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.alb_sample.arn}"
  port              = "80"
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

resource "aws_lb_target_group" "blue_target" {
  name        = "ecs-sample_blue-lb-target"
  vpc_id      = "vpc-a"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  depends_on  = ["${aws_lb.example}"]
}

resource "aws_lb_target_group" "green_target" {
  name        = "ecs-sample_green-lb-target"
  vpc_id      = "vpc-a"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  depends_on  = ["${aws_lb.example}"]
}


resource "aws_lb_listener_rule" "listener_blue" {
  listener_arn = "${aws_lb_listener.http.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.blue_target.arn}"
  }
  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}


resource "aws_lb_listener_rule" "listener_green" {
  listener_arn = "${aws_lb_listener.http.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.green_target.arn}"
  }
  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}
