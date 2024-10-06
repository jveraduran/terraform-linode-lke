module "lke" {
  source               = "./modules/lke"
  region               = var.region
  nodes_count          = var.nodes_count
  k8s_version          = var.k8s_version
  label                = var.label
  tags                 = var.tags
  client_conn_throttle = var.client_conn_throttle
  pool                 = var.pool
}

resource "local_file" "kubeconfig" {
  depends_on = [
    module.lke
  ]
  content  = base64decode(module.lke.kubeconfig)
  filename = "cluster.yaml"
}

module "bastion" {
  source          = "./modules/bastion"
  image_id        = length(data.linode_images.bastion.images) > 0 ? data.linode_images.bastion.images[0].id : null
  authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC14w4MzeV/v1qrKLtxD7XeLIIGzrPdYj1poYxtgyjiqco5u4Lh9oiYuz2m7qGQW+ZqBdZIvmP+msGorD8fM+tWQSZuk4PxLGEDoRJ1+cEVLjanNPDEm68vgK18lyKr1lPkyM64R3TssoCy26NbOrU/pdM9txVx9o0pynypx2lFsUYrnE+LEM8kmpJjdFZvh0onHC17io5y/aZcw6q+e0xcs2J390sjtUcBJ0GB6lUmlEwB6Y2pRPMPJdDTF1gxSmZFEVl1EIlAQTHtYQmKc8D55AU8Gbe4AoWIIeh5Ei8HQfj+HxkOVX5jxcHtTpan/O61vg66FFJShZiQrZ+CbcGx"]
  region          = var.region
  type            = "g6-standard-1"
  label           = "bastion"
  swap_size       = 256
  tags            = var.tags
  private_ip      = true
  booted          = true
}

resource "null_resource" "bastion" {
  depends_on = [
    module.lke, local_file.kubeconfig, module.bastion
  ]
  provisioner "remote-exec" {
    inline = ["mkdir .kube"]
    connection {
      host        = module.bastion.ip_address
      type        = "ssh"
      user        = "root"
      private_key = file("./id_rsa")
    }
  }
  provisioner "file" {
    source      = "./cluster.yaml"
    destination = ".kube/config"

    connection {
      host        = module.bastion.ip_address
      type        = "ssh"
      user        = "root"
      private_key = file("./id_rsa")
    }
  }
}

# https://developer.harness.io/docs/platform/get-started/tutorials/install-delegate/
module "delegate" {
  depends_on = [
    module.lke, local_file.kubeconfig
  ]
  source  = "harness/harness-delegate/kubernetes"
  version = "0.1.8"

  account_id       = var.harness_account_id
  delegate_token   = var.harness_delegate_token
  delegate_name    = "harness-ce-candidate"
  deploy_mode      = "KUBERNETES"
  namespace        = "harness-delegate-ng"
  manager_endpoint = var.harness_manager_endpoint
  delegate_image   = "harness/delegate:24.09.83900" # https://hub.docker.com/r/harness/delegate
  replicas         = 1
  upgrader_enabled = true
}

# https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_project
resource "harness_platform_project" "harness_se_lab" {
  depends_on = [
    module.delegate
  ]
  identifier = "harnessselab"
  name       = "Harness SE Lab"
  org_id     = "default"
  color      = "#FFC0CB"
}

# https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_pipeline
/* resource "harness_platform_pipeline" "harness_se_lab" {
  identifier = "name"
  org_id     = "default"
  project_id = "harnessselab"
  name       = "name"
} */

resource "harness_platform_template" "pipeline_template_remote" {
  identifier    = "harnesssebuildtemplate"
  org_id        = harness_platform_project.harness_se_lab.org_id
  project_id    = harness_platform_project.harness_se_lab.id
  name          = "harness-se-build-template"
  version       = "1.0"
  is_stable     = true
  template_yaml = <<-EOT
template:
  name: harness-se-build-template
  type: Stage
  projectIdentifier: harnessselab
  orgIdentifier: default
  spec:
    type: CI
    spec:
      cloneCodebase: true
      infrastructure:
        type: KubernetesDirect
        spec:
          connectorRef: harnessselabs
          namespace: <+input>
          automountServiceAccountToken: true
          nodeSelector: {}
          os: Linux
      execution:
        steps:
          - step:
              type: BuildAndPushDockerRegistry
              name: BuildAndPushDockerRegistry_1
              identifier: BuildAndPushDockerRegistry_1
              spec:
                connectorRef: dockerhub
                repo: <+input>
                tags:
                  - <+pipeline.identifier>-<+pipeline.sequenceId>
  identifier: harnesssebuildtemplate
  versionLabel: "1.0"
  EOT
}

resource "harness_platform_pipeline" "example" {
  identifier = "harnesssecilab"
  org_id     = harness_platform_project.harness_se_lab.org_id
  project_id = harness_platform_project.harness_se_lab.id
  name       = "harness-se-ci-lab"
  yaml = <<-EOT
pipeline:
  name: harness-se-ci-lab
  identifier: harnesssecilab
  projectIdentifier: harnessselab
  orgIdentifier: default
  tags: {}
  properties:
    ci:
      codebase:
        connectorRef: Github
        repoName: <+input>
        build: <+input>
  stages:
    - stage:
        name: Build
        identifier: Build
        template:
          templateRef: harnesssebuildtemplate
          versionLabel: "1.0"
          templateInputs:
            type: CI
            spec:
              infrastructure:
                type: KubernetesDirect
                spec:
                  namespace: <+input>
              execution:
                steps:
                  - step:
                      identifier: BuildAndPushDockerRegistry_1
                      type: BuildAndPushDockerRegistry
                      spec:
                        repo: <+input>
  EOT
}