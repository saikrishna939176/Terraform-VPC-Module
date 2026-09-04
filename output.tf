output "vpc_id" {
    value = aws_vpc.main.id
}
output "public_subnets_id" {
    value = aws_subnet.public[*].id
}

output "private_subnets_id" {
    value = aws_subnet.private[*].id
}

output "database_subnets_id" {
    value = aws_subnet.database[*].id
}

output "database_subent_group_id" {
    value = aws_db_subnet_group.default.id
}

output "database_subent_group_name" {
    value = aws_db_subnet_group.default.name
}

output "igw_id" {
    value = aws_internet_gateway.gw.id
}
output "route_53_zone_id" {
    value = aws_route53_zone.route53_zone.id
}
