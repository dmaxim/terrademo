resource "kubernetes_namespace" "nginx_ns" {
  metadata {
    name = var.ingress_namespace
    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.ingress_namespace

  set {
    name  = "controller.enableTLSPassThrough"
    value = "true"
  }

  set {
    name  = "controller.replicaCount"
    value = 2

  }
}

# Note:  Update NGINX Ingress config map to add
# data:
#  proxy-buffer-size: "8k"
#  proxy-body-size: "25M"