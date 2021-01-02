variable "company" {
  type        = string
  description = "This variable defines the company name used to build resources"
}

# application name 
variable "appname" {
  type        = string
  description = "This variable defines the application name used to build resources"
}

# environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "north europe"
}

# azure region shortname
variable "region" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "ne"
}

# owner
variable "owner" {
  type        = string
  description = "Specify the owner of the resource"
}

# description
variable "description" {
  type        = string
  description = "Provide a description of the resource"
}