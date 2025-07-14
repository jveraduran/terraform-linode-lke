module "lke" {
  source               = "./modules/lke"
  region               = var.region
  nodes_count          = var.nodes_count
  k8s_version          = var.k8s_version
  label                = substr("${var.label}-${replace(timestamp(), ":", "-")}", 0, 32)
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
  image_id        = length(data.linode_images.bastion.images) > 0 ? data.linode_images.bastion.images[0].id : var.image_id
  authorized_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXcjdW6/fLSzQnRCUDoDEz6jasL9i3u5fP/Li1oqZF6sDKbe7hsBaLhOk4IaPbGIhXtIN2QPR1S7/3NpSQZtv8Z5FgE9CnVR/woVDUm9/mk2AfhlTvYQAeg2avRsPeVjmKN13acKrTWAbtXngHRne22TKiXAYU//S+pkA9dxlSxhEnFFsVJbYWiKTIaZpMnPfTbwBZRFzQBEOqFYN7HSaf5aqcHeLnnZbErMtDlPifcgyuzfXUp1cRo15MktkglIgRxGR9va0OcPRcjyLV3IZASRX8/qxAUf9KVpMG+jSUU3ftYRx5mflpC8QBOvo1Esx1X3QD/UsNuXzWLFUZ1zjeO/1vuLOR8kq+fRnGMa5Zzm/v0bo1iUVjP2i7gNR47JRxbrbNpOCBxTAwdJmg516a6lCiKsMn5eKO++jPJ2QCyCNShFx11QoY6a/sEVJY3SPQ0fUgLIbEDUHjkshdAG20fZa67BmEf256hpZbCClqi7Q1K5wtl9oOQOPuJKWJC8GnLSbiNDtxGTLtNt8OWqwDCOMBym0CAQtNY/0xtjSSRGwyhZjarMm2kfo7/7HkjPIWASitPdz4oTY+PlRjvu8AeDtPl1XuHVDIt62JfRbqlJRAZA5JOb4ANgxUyN51KNvZLzxCvQkOMrBTFm8cS57VN/TA5q/2Z9NDwaloFafWQQ=="]
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
# module "delegate" {
#   depends_on = [
#     module.lke, local_file.kubeconfig
#   ]
#   source  = "harness/harness-delegate/kubernetes"
#   version = "0.1.8"

#   account_id       = var.harness_account_id
#   delegate_token   = var.harness_delegate_token
#   delegate_name    = "harness-ce-candidate"
#   deploy_mode      = "KUBERNETES"
#   namespace        = "harness-delegate-ng"
#   manager_endpoint = var.harness_manager_endpoint
#   delegate_image   = "harness/delegate:24.09.83900" # https://hub.docker.com/r/harness/delegate
#   replicas         = 1
#   upgrader_enabled = true
# }

# https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_project
# resource "harness_platform_project" "harness_se_lab" {
#   depends_on = [
#     module.delegate
#   ]
#   identifier = "harnessselab"
#   name       = "Harness SE Lab"
#   org_id     = "default"
#   color      = "#FFC0CB"
# }

# https://registry.terraform.io/providers/harness/harness/latest/docs/resources/platform_pipeline
/* resource "harness_platform_pipeline" "harness_se_lab" {
  identifier = "name"
  org_id     = "default"
  project_id = "harnessselab"
  name       = "name"
} */

# resource "harness_platform_template" "pipeline_template_remote" {
#   identifier    = "harnesssebuildtemplate"
#   org_id        = harness_platform_project.harness_se_lab.org_id
#   project_id    = harness_platform_project.harness_se_lab.id
#   name          = "harness-se-build-template"
#   version       = "1.0"
#   is_stable     = true
#   template_yaml = <<-EOT
# template:
#   name: harness-se-build-template
#   type: Stage
#   projectIdentifier: harnessselab
#   orgIdentifier: default
#   spec:
#     type: CI
#     spec:
#       cloneCodebase: true
#       infrastructure:
#         type: KubernetesDirect
#         spec:
#           connectorRef: harnessselabs
#           namespace: <+input>
#           automountServiceAccountToken: true
#           nodeSelector: {}
#           os: Linux
#       execution:
#         steps:
#           - step:
#               type: BuildAndPushDockerRegistry
#               name: BuildAndPushDockerRegistry_1
#               identifier: BuildAndPushDockerRegistry_1
#               spec:
#                 connectorRef: dockerhub
#                 repo: <+input>
#                 tags:
#                   - <+pipeline.identifier>-<+pipeline.sequenceId>
#   identifier: harnesssebuildtemplate
#   versionLabel: "1.0"
#   EOT
# }

# resource "harness_platform_pipeline" "example" {
#   identifier = "harnesssecilab"
#   org_id     = harness_platform_project.harness_se_lab.org_id
#   project_id = harness_platform_project.harness_se_lab.id
#   name       = "harness-se-ci-lab"
#   yaml       = <<-EOT
# pipeline:
#   name: harness-se-ci-lab
#   identifier: harnesssecilab
#   projectIdentifier: harnessselab
#   orgIdentifier: default
#   tags: {}
#   properties:
#     ci:
#       codebase:
#         connectorRef: Github
#         repoName: <+input>
#         build: <+input>
#   stages:
#     - stage:
#         name: Build
#         identifier: Build
#         template:
#           templateRef: harnesssebuildtemplate
#           versionLabel: "1.0"
#           templateInputs:
#             type: CI
#             spec:
#               infrastructure:
#                 type: KubernetesDirect
#                 spec:
#                   namespace: <+input>
#               execution:
#                 steps:
#                   - step:
#                       identifier: BuildAndPushDockerRegistry_1
#                       type: BuildAndPushDockerRegistry
#                       spec:
#                         repo: <+input>
#   EOT
# }