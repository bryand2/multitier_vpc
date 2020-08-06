##############################################################################
# This file creates the VPC, Zones, subnets and public gateway for the VPC
# a separate file sets up the load balancers, listeners, pools and members
##############################################################################


##############################################################################
# Create a VPC
##############################################################################

resource ibm_is_vpc vpc {
  name           = "${var.vpc_name}"
  resource_group = data.ibm_resource_group.resource_group.id
  classic_access = var.classic_access
}

##############################################################################


##############################################################################
# Public Gateways (Optional)
##############################################################################

resource ibm_is_public_gateway multi_tier_gateway {
  count = var.enable_public_gateway ? 2 : 0
  name  = "${var.unique_id}-gateway-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = "${var.ibm_region}-${count.index + 1}"
}

##############################################################################



##############################################################################
# Creates addresses prefixes for VPC
##############################################################################

resource ibm_is_vpc_address_prefix zone1_addr_prefix1 {
  name  = "${var.unique_id}-zone1_addr_prefix1" 
  zone  = "${var.ibm_region}-1"
  vpc   = ibm_is_vpc.vpc.id
  cidr  = element(var.tier_1_cidr_blocks, count.index)
}

resource ibm_is_vpc_address_prefix zone2_addr_prefix1 {
  name  = "${var.unique_id}-zone2_addr_prefix1" 
  zone  = "${var.ibm_region}-2"
  vpc   = ibm_is_vpc.vpc.id
  cidr  = element(var.tier_1_cidr_blocks, count.index)
}

resource ibm_is_vpc_address_prefix zone3_addr_prefix1 {
  name  = "${var.unique_id}-zone2_addr_prefix1" 
  zone  = "${var.ibm_region}-3"
  vpc   = ibm_is_vpc.vpc.id
  cidr  = element(var.tier_1_cidr_blocks, count.index)
}

##############################################################################




