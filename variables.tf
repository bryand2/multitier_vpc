##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
}

variable resource_group {
    description = "Name of resource group to create VPC."
    type        = string
    default     = "bryantech"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed."
    type        = string
    default     = "us-south"
}

variable tags {
    description = "Enter any tags that you want to associate with VPC and associated resources."
    type        = list(string)
    default     = [
      "aa-app-id:7129011",
      "aa-application:travel",
      "aa-costcenter:0900-1992",
      "directlink:true",
      "env:test"
    ]
}


##############################################################################
# VPC variables.
##############################################################################

variable vpc_name {
    description = "Name of the vpc to be created"
    type        = string
}

variable unique_id {
    description = "A unique short prefix. This will be used to name other related resources. Must begin with a letter"
    type        = string
    default     = "vpc"
}


variable classic_access {
  description = "Enable VPC Classic Access. Note: only one VPC per region can have classic access"
  type        = bool
  default     = false
}

variable address_prefixes {
    type = map(object({
        name = string
        cidr = string
        zone = number
    }))
    default = {
        prefix-1 = { name="address-prefix-1", cidr="172.16.10.128/27", zone="1"},
        prefix-2 = { name="address-prefix-2", cidr="172.16.20.128/27", zone="2"},
        prefix-3 = { name="address-prefix-3", cidr="172.16.30.128/27", zone="3"}
    }
}

variable subnets {
    type = map(object({
        name = string
        cidr = string
        zone = number
        pubgw = bool
    }))
    default = {
        subnet-1a = {name="subnet-1a", cidr="172.16.10.128/29", zone="1", pubgw="false"},
        subnet-1b = {name="subnet-1b", cidr="172.16.10.136/29", zone="1", pubgw="false"},
        subnet-2 = {name="subnet-2", cidr="172.16.20.128/27", zone="2", pubgw="false"},
        subnet-3 = {name="subnet-3", cidr="172.16.30.128/27", zone="3", pubgw="false"}
    }
}


variable public_gateways {
    type = map(object({
        name = string
        zone = number
    }))
    default = {
        publicgw-1 = {name="publicgw-1", zone="1"}
    }
}



variable allow_iks_worker_node_ports {
  description = "In Gen2 the default security group denies all inbound traffic. If you are planning to deploy IKS into this VPC set this value to true so communication to the IKS worker node ports are allowed."
  type        = bool
  default     = true
}

variable allow_ssh {
  description = "Set to true if the VPC's default security group should allow inbound SSH traffic."
  type        = bool
  default     = true
}

variable allow_ping {
  description = "Set to true if the VPC's default security group should allow ICMP/Ping traffic."
  type        = bool
  default     = true
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

