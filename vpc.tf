resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block

  tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = "${local.resource_name}-Vpc"
        }
    )
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            Name = "${local.resource_name}-Igw"
        }
    )
}


resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidr)
  availability_zone = local.az_name[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  map_public_ip_on_launch = true

 tags = merge(
        var.public_subnet_cidr_tags,
        {
           Name = "${local.resource_name}-${local.az_name[count.index]}- public"
        }
    )
}

resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidr)
  availability_zone = local.az_name[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  

 tags = merge(
        var.private_subnet_cidr_tags,
        {
           Name = "${local.resource_name}-${local.az_name[count.index]}-private"
        }
    )
}

resource "aws_subnet" "database" {

  count = length(var.database_subnet_cidr)
  availability_zone = local.az_name[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.database_subnet_cidr[count.index]

 tags = merge(
        var.database_subnet_cidr_tags,
        {
           Name = "${local.resource_name}-${local.az_name[count.index]}-private"
        }
    )
}

resource "aws_db_subnet_group" "default" {
  name        = "${local.resource_name}"
  # A list of VPC subnet IDs spanning multiple Availability Zones
  subnet_ids  = aws_subnet.database[*].id
  tags = merge(
        var.common_tags,
        var.aws_db_subnet_group_tags,
        {
           Name = "${local.resource_name}"
        }
    )
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.aws_route_public_table_tags,
        {
            Name = "${local.resource_name}-Public"
        }
    )
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.aws_route_private_table_tags,
        {
            Name = "${local.resource_name}-private"
        }
    )
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.aws_route_database_table_tags,
        {
            Name = "${local.resource_name}-database"
        }
    )
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}
# if we use any NAT, ingrere we use below code for privates
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
# }

# resource "aws_route" "database_route" {
#   route_table_id         = aws_route_table.database.id
#   destination_cidr_block = "0.0.0.0/0"
# }


resource "aws_route53_zone" "route53_zone" {
  name = var.aws_route53_zone # Replace with your domain
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}