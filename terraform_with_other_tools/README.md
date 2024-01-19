# Terraform together with other tools
Terraform is great tool for desired state provisioning of cloud resources. However, it is not the only tool that is needed to build a complete solution. In this section we will look at how Terraform can be used together with other tools.

## Where is Terraform not the best fit
- Imperative glue (workflow) - any procedural logic, integration of different tools. Example: backup/restore procedures, application deployment, DB tables provisioning
- Configuration management - Terraform is not a configuration management tool. It is not designed to install software, configure OS, etc. Example: installing Oracle DB on VM
- Kubernetes deployment - Terraform can do this, but there are better tools such as ArgoCD
- Application deployment - There are many ways to get from code to running application and Terraform does not play a role here
- Preparation of golden images - automated builds

## Few recommendations
- Do not use Terraform os orchestration tool
- Whenever possible, use systems that autoconverge to desired state by themselves, are totally idempotent and declaratively driven - great example is ArgoCD with GitOps
- To glue operations do not abuse one of the tools, but rather go to orchestration system - I would use GitHub Actions for most things and something bigger for huge efforts such as automated DR (which is risky and should be done with care)
- Use right tool for a job:
  - Infrastructure provisioning and cloud resources - Terraform (or Bicep, Pulumi, Crossplane)
  - Configuration management - Ansible (or Chef, Puppet, Salt)
  - Kubernetes deployment - ArgoCD (or Flux, pure Helm, Kustomize)
  - Application deployment - Docker+Kubernetes+Helm (or language specific tools such as npm, pip or OS specific tools such as apt, yum)
  - Golden images - Packer (tradeoff between deployment speed and flexibility, you can use mix -> base image built with Packer and then rest with Ansible after deployment)
- You can export information from tool to another to streamline deployment, eg. Terraform can create inventory files for Ansible
- You can create create your own level of abstraction manifest that is source of truth and can be consumed by different tools (example: you need Terraform to configure AKS and ArgoCD to install your)

## Example - Terraform and ArgoCD
[https://github.com/tkubica12/aks-as-a-service](https://github.com/tkubica12/aks-as-a-service)