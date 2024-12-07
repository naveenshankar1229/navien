resource "aws_subnet" "public" {
    vpc_id = aws_vpc.test.id
    count = 3
    cidr_block = element(var.cidr_block_public,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.vpc_name}-public${count.index+1}"
    }
}