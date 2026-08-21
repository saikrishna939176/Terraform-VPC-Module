variable "cidr_block" {
    default = "22.0.0.0/16"
}

variable "project_name" {
    type = string
}

variable "environment" {
    type = string
 #   default = "dev"
}

variable "common_tags" {
    type = map
}

variable "vpc_tags" {
    type = map
    default= {}
}

variable "igw_tags" {
    type = map
    default ={}
}


variable "public_subnet_cidr" {
    type = list

    validation {
        condition = length(var.public_subnet_cidr) ==2
        error_message = "please provide 2 valid public subnet CIDR"
    }
}

variable "public_subnet_cidr_tags" {
    type=map
    default = {}
}

variable "private_subnet_cidr" {
    type = list

    validation {
        condition = length(var.private_subnet_cidr) ==2
        error_message = "please provide 2 valid private subnet CIDR"
    }
}

variable "private_subnet_cidr_tags" {
    type=map
    default = {}
}

variable "database_subnet_cidr" {
    type = list

    validation {
        condition = length(var.database_subnet_cidr) ==2
        error_message = "please provide 2 valid private subnet CIDR"
    }
}

variable "database_subnet_cidr_tags" {
    type=map
    default = {}
}

variable "aws_route_public_table_tags" {
    type = map
    default ={}
}

variable "aws_route_private_table_tags" {
    type = map
    default ={}
}

variable "aws_route_database_table_tags" {
    type = map
    default ={}
}
variable "is_peering_connection" {
    type = bool
    default = false
}

variable "acceptor_vpc_id" {
    type =string
    default = ""
}

variable "vpc_peering_tags" {
    type = map
    default ={}
}
variable "aws_db_subnet_group_tags" {
    type = map
    default ={}
}