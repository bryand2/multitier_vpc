##############################################################################
# This file creates the VPC, Zones, subnets and public gateway for the VPC
##############################################################################


##############################################################################
# Create a VPC
# Address_prefix_management set to "manual" because we do not want to auto
# create default address prefixes when VPC is created. We will add our own.
##############################################################################

resource ibm_is_vpc vpc {
   name           = var.vpc_name
   resource_group = data.ibm_resource_group.resource_group.id
   classic_access = var.classic_access
   address_prefix_management = "manual" 
   tags = var.tags2
}



##############################################################################
# Creates addresses prefixes for VPC
##############################################################################

resource ibm_is_vpc_address_prefix address_prefix {
   count = length(var.cidr_blocks)
   name  = "${var.unique_id}-prefix-zone-${count.index + 1}" 
   zone  = "${var.ibm_region}-${count.index + 1}"
   vpc   = ibm_is_vpc.vpc.id
   cidr  = element(var.cidr_blocks, count.index)
}



##############################################################################
# Create Subnets
##############################################################################

resource ibm_is_subnet subnet {
   count           = length(var.cidr_blocks)
   name            = "${var.unique_id}-subnet-${count.index + 1}"
   resource_group  = data.ibm_resource_group.resource_group.id
   vpc             = ibm_is_vpc.vpc.id
   zone            = "${var.ibm_region}-${count.index + 1}"
   ipv4_cidr_block = element(ibm_is_vpc_address_prefix.address_prefix.*.cidr, count.index)
   #network_acl    = var.enable_acl_id ? var.acl_id : null
   #public_gateway = length( ibm_is_public_gateway.public_gateway.*.id ) > 0 ? element( ibm_is_public_gateway.public_gateway.*.id , count.index) : null
   public_gateway = var.enable_public_gateway ? element( ibm_is_public_gateway.public_gateway.*.id , count.index) : null
}



##############################################################################
# Update default security group
##############################################################################

resource ibm_is_security_group_rule allow_iks_worker_node_ports {
   count     = var.allow_iks_worker_node_ports == true ? 1 : 0
   group     = ibm_is_vpc.vpc.default_security_group
   direction = "inbound"
   remote    = "0.0.0.0/0"
   tcp {
      port_min = 30000
      port_max = 32767
   }
}


##############################################################################
# Enable public gateway if needed
##############################################################################

resource ibm_is_public_gateway public_gateway {
   count = var.enable_public_gateway ? length(var.cidr_blocks) : 0
   name  = "${var.unique_id}-pubgw-${count.index + 1}"
   vpc   = ibm_is_vpc.vpc.id
   resource_group = data.ibm_resource_group.resource_group.id
   zone  = "${var.ibm_region}-${count.index + 1}"
   tags = var.tags2
}

