locals {
  event_hubs = {
    hub_one = {
      name              = join("", ["eh", var.hub-name, "1"])
      partition_count   = 1
      message_retention = 7
    }
    hub_two = {
      name              = join("", ["eh", var.hub-name, "2"])
      partition_count   = 2
      message_retention = 7
    }
  }
}

locals {
  relay_namespaces = {
    namespace_one = {
      name            = join("-", ["rn", var.namespace, var.environment, "01"])
      connection_name = join("-", ["hc", var.namespace, var.environment, "01"])
      metadata = {
        key   = "endpoint"
        value = "someendpoint:1433"
      }
    }
    namespace_two = {
      name            = join("-", ["rn", var.namespace, var.environment, "02"])
      connection_name = join("-", ["hc", var.namespace, var.environment, "02"])
      metadata = {
        key   = "endpoint"
        value = "otherendpoint:1433"
      }
    }
  }
}