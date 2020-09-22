provider "kubernetes" {
 config_context_cluster = "minikube"
}
resource "kubernetes_deployment" "wordpress01" {
 metadata {
  name = "wordpress01"
 }
 spec {
  replicas = 1
  selector {
   match_labels = {
    env = "dev"
    region = "IN"
    App = "wordpress01"
   }
  }
  template {
   metadata {
    labels = {
     env = "dev"
     region = "IN"
     App = "wordpress01"
    }
   }
   spec {
    container {
    image = "wordpress:4.8-apache"
    name = "mywordpressdb"
    }
   }
  }
 }
}
resource "kubernetes_service" "wordpress01" {
 metadata {
  name = "wordpress01"
 } 
 spec {
  selector = {
   App = kubernetes_deployment.wordpress01.spec.0.template.0.metadata[0].labels.App
  }
  port {
  node_port=32123
  port = 80
  target_port = 80
  }
  type ="NodePort"
 }
}
