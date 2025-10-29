output "vpc" {
  value = aws_vpc.vpc
}

output "private_subnets" {
  value = tomap({
    for k, v in aws_subnet.private : k => v.id
  })
  description = "The private networks created as a map <zone> => <subnet id>"
}

output "public_subnets" {
  value = tomap({
    for k, v in aws_subnet.public : k => v.id
  })
  description = "The public networks created as a map <zone> => <subnet id>"
}

output "subnets" {
  value = {
    "public"  = aws_subnet.public
    "private" = aws_subnet.private
  }

  description = "The networks created as a map <public|private> => map <zone> => <subnet>"
}
