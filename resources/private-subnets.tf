resource "aws_eip" "nat" {
  vpc = true

  tags = merge({
    Name = "eip-nat-${terraform.workspace}"
  }, local.tags)
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id

  tags = merge({
    Name = "natgateway-${terraform.workspace}"
  }, local.tags)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_subnet" "private" {
  for_each = {
    for i, az in data.aws_availability_zones.available.names: az => i
    if i < local.count_subnets
  }

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr_block, local.len_subnets, each.value + 10)

  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = merge({
    Name = "subnet-private_${each.value + 1}-${terraform.workspace}"
  }, local.tags)
}

resource "aws_route_table_association" "private" {
  for_each = {
    for i, az in data.aws_availability_zones.available.names: az => i
    if i < local.count_subnets
  }

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}
