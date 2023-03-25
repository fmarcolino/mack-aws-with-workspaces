resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  for_each = {
    for i, az in data.aws_availability_zones.available.names: az => i
    if i < local.count_subnets
  }

  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr_block, local.len_subnets, each.value)

  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public_${each.value + 1}-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = {
    for i, az in data.aws_availability_zones.available.names: az => i
    if i < local.count_subnets
  }

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
