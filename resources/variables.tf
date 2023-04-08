variable "project_name" {
  description = "Project Name"
  default = "Project_3"
}

variable "instance_key" {
  description = "Instance Key"
  default = "terraform"
}

variable "instance_front" {
  description = "Frontend Instances"
  default = 5
}

variable "instance_back" {
  description = "Backend Instances"
  default = 5
}

variable "public_subnet_count" {
  description = "Public Subnet Count"
  default = 3
}

variable "private_subnet_count" {
  description = "Private Subnet Count"
  default = 3
}