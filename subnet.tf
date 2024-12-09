resource "aws_subnet" "public" {
    vpc_id = aws_vpc.test.id
    count = 4
    cidr_block = element(var.cidr_block_public,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.vpc_name}-public${count.index+1}"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.test.id
    route {
        gateway_id = aws_internet_gateway.igw.id
        cidr_block = "0.0.0.0/0"
   }
   tags = {
    Name = "${var.vpc_name}-rt"
   }
  
}

resource "aws_route_table_association" "associate" {
    count = 4
    route_table_id = aws_route_table.rt.id
    subnet_id = element(aws_subnet.public[*].id,count.index)
  
}