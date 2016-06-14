job "hashiapp" {
  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "30s"
    max_parallel = 1
  }

  group "hashiapp" {
    count = 8

    task "hashiapp" {
      driver = "exec"
      config {
        command = "hashiapp"
      }

      env {
        VAULT_TOKEN = ""
        VAULT_ADDR = ""
        HASHIAPP_DB_HOST = ""
      }

      artifact {
        source = "https://storage.googleapis.com/hashistack/hashiapp/v1.0.0/hashiapp"
        options {
          checksum = "sha256:a58ee8c9eb38f2ce45edfbd71547cc66dcb68464b901fe8c89675ad2e12d2135"
        }
      }

      resources {
        cpu = 500
        memory = 64
        network {
          mbits = 100
          port "http" {}
        }
      }

      service {
        name = "hashiapp"
        tags = ["urlprefix-/hashiapp"]
        port = "http"
        check {
          type = "http"
          name = "healthz"
          interval = "15s"
          timeout = "5s"
          path = "/healthz"
        }
      }
    }
  }
}
