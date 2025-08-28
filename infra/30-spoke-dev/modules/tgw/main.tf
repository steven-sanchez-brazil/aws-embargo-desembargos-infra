# TGW attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  transit_gateway_id = var.tgw_id

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["project"]}-${var.tags["env"]}-tgw-attachment"
    }
  )
}

# Rutas desde privadas hacia on-prem por TGW
resource "aws_route" "private_to_onprem" {
  for_each               = toset(var.onprem_cidrs)
  route_table_id         = var.private_route_table_ids[0]
  destination_cidr_block = each.value
  transit_gateway_id     = var.tgw_id
}

# Rutas desde subredes DB hacia on-prem por TGW
resource "aws_route" "db_to_onprem" {
  for_each               = toset(var.onprem_cidrs)
  route_table_id         = var.database_route_table_ids[0]
  destination_cidr_block = each.value
  transit_gateway_id     = var.tgw_id
}
