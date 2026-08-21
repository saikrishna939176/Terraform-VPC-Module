resource "aws_vpc_peering_connection" "vpc_pair" {
    count = var.is_peering_connection && var.acceptor_vpc_id =="" ?1:0
  peer_vpc_id   = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id :var.acceptor_vpc_id
  vpc_id        = aws_vpc.main.id
  auto_accept = var.acceptor_vpc_id == "" ? true:false

  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
        Name = "${local.resource_name}"
    }
  )
}

#count is required to control when resource is required.
resource "aws_route" "public_peering" {
   count = var.is_peering_connection && var.acceptor_vpc_id =="" ?1:0
   route_table_id = aws_route_table.public.id
   destination_cidr_block = data.aws_vpc.default.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.vpc_pair[0].id
}

resource "aws_route" "private_peering" {
   count = var.is_peering_connection && var.acceptor_vpc_id =="" ?1:0
   route_table_id = aws_route_table.private.id
   destination_cidr_block = data.aws_vpc.default.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.vpc_pair[0].id
}


resource "aws_route" "database_peering" {
   count = var.is_peering_connection && var.acceptor_vpc_id =="" ?1:0
   route_table_id = aws_route_table.database.id
   destination_cidr_block = data.aws_vpc.default.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.vpc_pair[0].id
}

resource "aws_route" "default" {
   count = var.is_peering_connection && var.acceptor_vpc_id =="" ?1:0
   route_table_id = data.aws_route_table.main.id
   destination_cidr_block = var.cidr_block
   vpc_peering_connection_id = aws_vpc_peering_connection.vpc_pair[0].id
}
