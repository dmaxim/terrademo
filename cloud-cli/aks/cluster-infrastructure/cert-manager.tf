resource "kubernetes_namespace" "cert_ns" {
  metadata {
    name = var.cert_manager_namespace
    labels = {
      istio-injection = "disabled"
    }
  }
}


resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = var.cert_manager_namespace

  set {
    name  = "installCRDs"
    value = "true"
  }

}