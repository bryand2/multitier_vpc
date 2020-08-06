##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable vpc_name {
    description = "Name of the vpc to be created"
    type        = string
}

variable unique_id {
    description = "A unique prefix need to provision resources. Must begin with a letter"
    type        = string
    default     = "multitier"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
    default     = "us-south"
}

variable resource_group {
    description = "Name of resource group to create VPC"
    type        = string
    default     = "bryantech"
}

variable generation {
  description = "generation for VPC"
  type        = number
  default     = 2
}

##############################################################################


##############################################################################
# Network variables
##############################################################################

variable classic_access {
  description = "Enable VPC Classic Access. Note: only one VPC per region can have classic access"
  type        = bool
  default     = false
}


variable enable_public_gateway {
  description = "Enable public gateways, true or false"
  type        = bool
  default     = false
}


variable acl_rules {
  # description = "Access control list rule set"
  # type        = list(string)
  default = [
    {
      name        = "egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
}


variable tier_1_cidr_blocks {
  description = "A list of tier subnet IPs"
  type        = list(string)
  default     = [
    "172.16.10.128/27", 
    "172.16.30.128/27"
  ] 
}

variable tier_2_cidr_blocks {
  description = "A list of tier subnet IPs"
  type        = list(string)
  default     = [
    "172.16.40.0/25", 
    "172.16.20.0/25"
  ]  
}

##############################################################################





#############################################################################
# Subnet variables
##############################################################################

variable subnets_per_zone {
    description = "Number of subnets per zone"
    type        = number
    default     = 1
}

variable zones {
    description = "Number of zones to deploy subnets in"
    type        = number
    default     = 3
}

variable public_gateways {
    description = "List of public gateway ids"
    type        = list(string)
    default     = []
}


##############################################################################