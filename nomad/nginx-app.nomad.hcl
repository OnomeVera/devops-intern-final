
variable "image_tag" {
  description = "Docker image tag to deploy from GHCR"
  type        = string
  default     = "latest"
}

job "nginx-app" {

  datacenters = ["dc1"]

  type = "service"

  group "web" {

    count = 1

    update {
      max_parallel      = 1
      min_healthy_time  = "10s"
      healthy_deadline  = "2m"
      auto_revert       = true
    }

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name     = "nginx-app"
      provider = "consul"
      port     = "http"

      check {
        name     = "nginx-http-health"
        type     = "http"
        path     = "/healthz"
        interval = "10s"
        timeout  = "2s"
      }
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "15s"
      mode     = "fail"
    }

    reschedule {
      attempts       = 3
      interval       = "1h"
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "5m"
      unlimited      = false
    }

    task "nginx" {

      driver = "docker"

      config {
        image      = "ghcr.io/onomevera/devops-intern-final:${var.image_tag}"
        ports      = ["http"]
        force_pull = true
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
