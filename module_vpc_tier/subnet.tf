##############################################################################
# Prefixes and subnets
#
# Creates a number of address prefixes per zone equal to the subnets per 
# zone times the number of zones
##############################################################################

resource ibm_is_vpc_address_prefix subnet_prefix {
  count = var.subnets_per_zone * var.zones
  name  = "${var.unique_id}-prefix-zone-${(count.index % var.zones) + 1}" 
  zone  = "${var.ibm_region}-${(count.index % var.zones) + 1}"
  vpc   = var.vpc_id
  cidr  = element(var.cidr_blocks, count.index)
}

##############################################################################


##############################################################################
# Create Subnets
#
# Creates a number of subnets per zone equal to the subnets per zone
# time the number of zones
##############################################################################

resource ibm_is_subnet subnet {
  count           = var.subnets_per_zone * var.zones
  name            = "${var.unique_id}-subnet-${count.index + 1}"
  vpc             = var.vpc_id
  zone            = "${var.ibm_region}-${(count.index % var.zones) + 1}"
  ipv4_cidr_block = element(ibm_is_vpc_address_prefix.subnet_prefix.*.cidr, count.index)
  network_acl     = var.enable_acl_id ? var.acl_id : null
  public_gateway  = length(var.public_gateways) > 0 ? element(var.public_gateways, count.index) : null
}

##############################################################################