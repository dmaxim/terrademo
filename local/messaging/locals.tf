locals {
    event_hubs = {
        hub_one = {
            name = join("",  ["eh", var.hubname, "1"])
            partition_count = 1
            message_retention = 7
        }
        hub_two = {
            name = join("", ["eh", var.hubname, "2"])
            partition_count = 2
            message_retention = 7
        }
    }
}