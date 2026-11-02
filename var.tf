variable "ami_id" {
  default = "ami-01f03776cf27d7305"
  type    = string
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "instance_name" {
  default = "Rishi"
  type    = string
}
variable "key_name" {
  default = "Vijaya"
  type    = string
}
