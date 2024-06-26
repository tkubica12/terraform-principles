data "github_repository" "tkubica12" {
  full_name = "tkubica12/terraform-principles"
}

data "github_repository_file" "stage1_runtime" {
  repository          = data.github_repository.tkubica12.name
  branch              = "main"
  file                = var.stage1_runtime_yaml
}

locals {
  stage1_runtime = yamldecode(data.github_repository_file.stage1_runtime.content)
}