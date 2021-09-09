resource "kubernetes_namespace" "keda" {
  metadata {
    name = var.keda-namespace
    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "helm_release" "keda" {
  name = "keda"

  repository = "kedacore"
  chart      = "kedacore/keda"
  namespace  = var.keda-namespace

}