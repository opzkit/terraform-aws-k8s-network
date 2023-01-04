data "aws_vpc_endpoint_service" "s3" {
  service      = "s3"
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "s3" {
  tags = {
    "Name" = "${var.name}-s3-endpoint"
  }

  count        = var.s3_service_endpoint ? 1 : 0
  service_name = data.aws_vpc_endpoint_service.s3.service_name
  vpc_id       = aws_vpc.vpc.id

  route_table_ids = flatten([
    [aws_route_table.public.id],
    [for k in aws_route_table.private : k.id]
  ])
}
