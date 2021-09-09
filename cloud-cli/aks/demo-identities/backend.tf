terraform {
  backend "remote" {
      organization = "mxinfo-demo"

      workspaces {
          name = "demo-worker"
      }
  }
}