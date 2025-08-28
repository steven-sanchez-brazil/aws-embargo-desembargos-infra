variable "aws_region" {
  description = "AWS region donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "172.24.188.0/22"
}

variable "azs" {
  description = "Lista de availability zones donde se desplegarán las subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "tgw_id" {
  description = "ID del Transit Gateway al que se conectará la VPC"
  type        = string
}

variable "onprem_cidrs" {
  description = "Lista de CIDRs de las redes on-premises que se conectarán a través del Transit Gateway"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "create_nat_per_az" {
  description = "Si es true, se creará un NAT Gateway por AZ. Si es false, se creará un único NAT Gateway"
  type        = bool
  default     = false
}
