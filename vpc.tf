##############################################################################
# This file creates the VPC, Zones, subnets and public gateway for the VPC
# a separate file sets up the load balancers, listeners, pools and members
##############################################################################


##############################################################################
# Create a VPC
#
# address_prefix_management set to "manual" because we do not want to auto
# create default address prefixes when VPC is created. We will add our own.
##############################################################################

resource ibm_is_vpc vpc {
  name           = var.vpc_name
  resource_group = data.ibm_resource_group.resource_group.id
  classic_access = var.classic_access
  address_prefix_management = "manual" 
}

##############################################################################


##############################################################################
# Public Gateways (Optional)
##############################################################################

#resource ibm_is_public_gateway multi_tier_gateway {
#  count = var.enable_public_gateway ? 2 : 0
#  name  = "${var.unique_id}-gateway-${count.index + 1}"
#  vpc   = ibm_is_vpc.vpc.id
#  zone  = "${var.ibm_region}-${count.index + 1}"
#}

##############################################################################



##############################################################################
# Creates addresses prefixes for VPC
##############################################################################

resource ibm_is_vpc_address_prefix address_prefixes {
  count = var.zones * var.subnets_per_zone
  name  = "${var.unique_id}-prefix-zone-${(count.index % var.zones) + 1}" 
  zone  = "${var.ibm_region}-${(count.index % var.zones) + 1}"
  vpc   = ibm_is_vpc.vpc.id
  cidr  = element(var.tier_1_cidr_blocks, count.index)
}

##############################################################################




