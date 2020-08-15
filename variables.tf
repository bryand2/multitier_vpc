##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable resource_group {
    description = "Name of resource group to create VPC"
    type        = string
    default     = "bryantech"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed."
}

variable tags2 {
    description = "Enter any tags that you want to associate with VPC and associated resources"
    type        = list(string)
    default     = [
      "aa-app-id:7129011",
      "aa-application:travel",
      "aa-costcenter:0900-1992",
      "directlink:true",
      "env:test"
    ]
}
