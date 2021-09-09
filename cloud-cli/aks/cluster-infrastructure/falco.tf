resource "kubernetes_namespace" "kube_sec" {
  metadata {
    name = var.security_namespace
    labels = {
      istio-injection = "disabled"
    }
  }
}


resource "helm_release" "falco" {
  name = "falco"

  repository = "https://falcosecurity.github.io/charts"
  chart      = "falco"
  namespace  = var.security_namespace

}