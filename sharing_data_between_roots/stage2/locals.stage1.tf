data "github_repository" "tkubica12" {
  full_name = "tkubica12/terraform-principles"
}

data "github_repository_file" "stage1_runtime" {
  repository          = github_repository.tkubica12.name
  branch              = "main"
  file                = "shareing_data_between_roots/stage1/stage1_runtime.yaml"
}

locals {
  stage1_runtime = yamldecode(data.github_repository_file.stage1_runtime.content)
}