
locals {
  asb_topics = {
    resource_added = {
      name = "resourceadded"
    },
    resource_deleted = {
      name = "resourcedeleted"
    },
    demo_topic = {
      name = "demotopic"
    }
  }
}