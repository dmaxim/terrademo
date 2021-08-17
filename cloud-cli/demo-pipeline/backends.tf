terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "devops-pipeline"
    }
  }


}