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
   tags = var.tags
}


##############################################################################
# Creates addresses prefixes for VPC
##############################################################################

resource ibm_is_vpc_address_prefix address_prefix {
   for_each = var.address_prefixes
   name  = each.value["name"]
   zone  = format("%s-%s", var.ibm_region, each.value["zone"])
   cidr  = each.value["cidr"]
   vpc   = ibm_is_vpc.vpc.id
}


##############################################################################
# Create Subnets
##############################################################################

resource ibm_is_subnet subnet {
    for_each = var.subnets
    name            = each.value["name"]
    zone            = format("%s-%s", var.ibm_region, each.value["zone"])
    ipv4_cidr_block = each.value["cidr"]
    vpc             = ibm_is_vpc.vpc.id 
    resource_group  = data.ibm_resource_group.resource_group.id
#   public_gateway  = var.enable_public_gateway ? element( ibm_is_public_gateway.public_gateway.*.id , count.index) : null
#   public_gateway  = each.value["pubgw"] ? element( ibm_is_public_gateway.public_gateway.*.id , each.value["zone"]) : null
#   public_gateway  = each.value["pubgw"] ? lookup(var.public_gateways, "zone", each.value["zone"])
    depends_on = [ibm_is_vpc_address_prefix.address_prefix, ibm_is_public_gateway.public_gateway]
}





##############################################################################
# Enable public gateway if needed
##############################################################################

resource ibm_is_public_gateway public_gateway {
   for_each = var.public_gateways
   name  = each.value["name"]
   vpc   = ibm_is_vpc.vpc.id
   resource_group = data.ibm_resource_group.resource_group.id
   zone  = format("%s-%s", var.ibm_region, each.value["zone"])
   tags = var.tags
}


locals {
  public_gateway_ids = [
    for i in ibm_is_public_gateway.public_gateway: i.id 
  ]
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

resource ibm_is_security_group_rule allow_ssh {
   count     = var.allow_ssh == true ? 1 : 0
   group     = ibm_is_vpc.vpc.default_security_group
   direction = "inbound"
   remote    = "0.0.0.0/0"
   tcp {
      port_min = 22
      port_max = 22
   }
}

resource ibm_is_security_group_rule allow_ping {
   count     = var.allow_ping == true ? 1 : 0
   group     = ibm_is_vpc.vpc.default_security_group
   direction = "inbound"
   remote    = "0.0.0.0/0"
   icmp {
        type = 8
    }
}


