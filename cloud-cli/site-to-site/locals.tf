locals {
  sql_databases = {
    network_demo = {
      name              = "NetworkDemo",
      service_objective = "S0"
    }
  }
  asb_topics = {
    demo_event = {
      name = "demoevent"
    }
  }
}