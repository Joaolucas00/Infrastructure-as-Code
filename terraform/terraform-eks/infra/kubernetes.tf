resource "kubernetes_deployment" "Django-API" {
  metadata {
    name = "django-api"
    labels = {
      nome = "django"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        nome = "django"
      }
    }

    template {
      metadata {
        labels = {
          nome = "django"
        }
      }

      spec {
        container {
          image = "962752222089.dkr.ecr.us-west-2.amazonaws.com/producao:v1"
          name  = "django"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/clientes/"
              port = 8000
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "load_balancer" {
  metadata {
    name = "loadbalancer-django-api"
  }

  spec {
    selector = {
        nome = "django"
    }
    port {
        port = 8080
        target_port = 80
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "IP_loadbalancer_dns" {
  metadata {
    name = "loadbalancer-django-api"
  }
}

output "IP_loadbalancer" {
  value = data.kubernetes_service.IP_loadbalancer_dns.status
}