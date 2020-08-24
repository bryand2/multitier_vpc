##############################################################################
# VPC GUID
##############################################################################

output vpc_id {
  description = "ID of VPC created"
  value       = ibm_is_vpc.vpc.id
}

output vpc_name {
  description = "Name of VPC created"
  value       = ibm_is_vpc.vpc.name
}

output public_gateways {
    description = "Public gateways"
    value = ibm_is_public_gateway.public_gateway.*
}

output test {
    description = "test"
    #value = ibm_is_public_gateway.public_gateway[index(ibm_is_public_gateway.public_gateway[*].zone, "us-south-1")]
    #value = values(ibm_is_public_gateway.public_gateway)[*].id
    #value =  index ( values(ibm_is_public_gateway.public_gateway)[*].zone, "us-south-2" ) 
    value = ibm_is_public_gateway.public_gateway["1"]
}

#output subnet_names {
#  description = "Names of subnets created for this tier"
#  value       = ibm_is_subnet.subnet.*.name
#}  

#output cidr_blocks {
#  value       = ibm_is_subnet.subnet.*.ipv4_cidr_block
#}

##############################################################################