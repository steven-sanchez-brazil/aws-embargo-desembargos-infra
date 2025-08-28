variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for TGW attachment"
  type        = list(string)
}

variable "tgw_id" {
  description = "ID of the Transit Gateway"
  type        = string
}

variable "onprem_cidrs" {
  description = "List of on-premise CIDR blocks"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of private route table IDs"
  type        = list(string)
}

variable "database_route_table_ids" {
  description = "List of database route table IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
