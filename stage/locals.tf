locals {

  prefix = "myapp"

  computed_tags = merge(
    var.tags,
    {
      "Created With" = "Terraform"
      "Application"  = "myapp"
      "Env"          = "Stage"
    }
  )
}
