terraform {
  backend "remote" {
    organization = "seti-demo"
    
    workspaces {
      name = "demo-app-service"
    }
  }


}