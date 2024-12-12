resource "aws_subnet" "private" {
  vpc_id = aws_vpc.test.id
  count=4
   cidr_block = element(var.cidr_block_private,count.index)
    availability_zone = element(var.azs,count.index)
    tags = {
        Name = "${var.vpc_name}-private${count.index+1}"
    }
}
resource "aws_eip" "eip" {
  tags = {
    Name = "my-nat-eip"
  }
}
resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "my-nat-gateway"
  }
}
resource "aws_route_table" "privatert" {
    vpc_id = aws_vpc.test.id
    route {
        gateway_id = aws_nat_gateway.natgateway.id
        cidr_block = "0.0.0.0/0"
    }
    tags = {
        Name = "${var.vpc_name}-privatert"
    }
  

}

resource "aws_route_table_association" "privateassociation" {
    count = 4
    route_table_id = aws_route_table.privatert.id
    subnet_id = element(aws_subnet.private[*].id,count.index)
}