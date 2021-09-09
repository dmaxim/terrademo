variable "ingress_namespace" {
  type        = string
  description = "Namespace for the Nginx ingress controller"
  default     = "seti-ingress"
}

variable "kube_config_path" {
  type        = string
  description = "Path to the kube config file to use when deploying to the cluster"
  default     = "~/.kube/config"
}

variable "kube_config_context" {
  type        = string
  description = "Context name from the kube config file for deploying to the cluster"
  default     = "aks-seti-k8s-poc-admin"
}

variable "cert_manager_namespace" {
  type        = string
  description = "Namespace for the cert-manager resources"
  default     = "cert-manager"
}


variable "security_namespace" {
  type        = string
  description = "Namespace for the security related resources"
  default     = "seti-kube-sec"
}

variable "keda-namespace" {
  type        = string
  description = "Namespace for deploying KEDA"
  default     = "seti-keda"
}