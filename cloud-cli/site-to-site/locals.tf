locals {
  sql_databases = {
    network_demo = {
      name              = "NetworkDemo",
      service_objective = "S0"
    }
  }
  asb_topics = {
    demo_event = {
      name = "mxdemoevent"
    }
  }
  topic_subscriptions = {
    demo_one = {
      topic_name = "network.ui~network.ui.messaging.demoevent"
      queue_name = "demoevent"
    }
  }
}