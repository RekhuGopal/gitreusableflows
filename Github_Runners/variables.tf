variable "ami" {
  description = "The AMI for the GitHub Runner backing EC2 Instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance backing the GitHub Runner"
  type        = string
}

variable "key_name" {
  description = "The KeyPair name for accessing (SSH) into the EC2 instance backing the GitHub Runner"
  type        = string
}

variable "github_repo_url" {
  description = "The GitHub Repo URL for which the GitHub Runner to be registered with"
  type        = string
}

variable "github_repo_pat_token" {
  description = "The GitHub Repo Pat Token that would be used by the GitHub Runner to authenticate with the GitHub Repo"
  type        = string
}

variable "runner_name" {
  description = "The name to give to the GitHub Runner so you can easily identify it"
  type        = string
}


variable "health_check_grace_period" {
  description = "The health check grace period"
  type        = number
  default     = 600
}

variable "desired_capacity" {
  description = "The desired number of EC2 instances in the AutoScaling Group"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "The Minimum number of EC2 instances in the AutoScaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The Maximum number of EC2 instances in the AutoScaling Group"
  type        = number
  default     = 1
}

variable "labels" {
  description = "labels to attach to the runner instance"
  type        = string
}