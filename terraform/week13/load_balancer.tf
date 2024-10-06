resource "aws_lb" "elb-webLB" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_web.id]
  subnets            = [aws_subnet.Public1.id, aws_subnet.Public2.id]

  tags = {
    Name    = "${local.prefix}elb-webLB"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_lb_target_group" "elb-webLB-tg" {
  name        = "itKMITL-elb-webLB-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.testVPC.id

  tags = {
    Name    = "${local.prefix}elb-webLB-tg"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}

resource "aws_lb_target_group_attachment" "elb-webLB-tg-attach-server1" {
  target_group_arn = aws_lb_target_group.elb-webLB-tg.arn
  target_id        = aws_instance.Server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "elb-webLB-tg-attach-server2" {
  target_group_arn = aws_lb_target_group.elb-webLB-tg.arn
  target_id        = aws_instance.Server1.id
  port             = 80
}

resource "aws_lb_listener" "elb-webLB-listener" {
  load_balancer_arn = aws_lb.elb-webLB.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elb-webLB-tg.arn
  }

  tags = {
    Name    = "${local.prefix}elb-webLB-listener"
    itclass = local.itclass
    itgroup = local.itgroup
  }
}
