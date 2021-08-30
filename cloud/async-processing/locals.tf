
locals {
  asb_topics = {
    dialer_result = {
      name = "dialerresult"
    }
  }
  sql_databases = {
    messaging_demo = {
      name              = "DartMessagingDemo",
      service_objective = "S1"

    }
  }
  app_service_plans = {
    webjobs = {
      name = join("-", ["plan", "jobs", var.namespace, var.environment]),
      tier = var.webjob_app_service_plan_tier
      size = var.webjob_app_service_plan_size
    }
  }
  function_apps = {
    main = {
      name = join("-", ["xoc", var.namespace, var.environment])
    }
  }
}

