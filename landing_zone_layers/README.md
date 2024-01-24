# Landing zone layers
There is no single method, approaches differ, nevertheless based on Cloud Adoption Framework we can identify following common layers:

## 0. Deployment environment
You must be able to deploy foundational infrastructure even when it does not exist or is corrupted. Eg. having strong dependency on some jump server or Github Enterprise running inside Azure does not comply with this.

Good example is to leverage GitHub to store foundational infrastructure code and use GitHub Actions with hosted agents to deploy it. Other alternatives might include Azure DevOps, Terraform Cloud or some tooling hosted outside of foundational infrastructure (eg. on-prem instance of GitHub Enterprise).

## 1. Foundational infrastructure
There are few distinct components in foundational layer. This can be deployed as single Terraform root module or split into multiple modules. 

### 1.1. Core
This layer typically defines Management Groups, custom RBAC roles, custom policies, policy initiatives, assignments of RBAC and policies on MGs.

### 1.2. Management
This layer usually includes Log Analytics Workspace for logs, dashboards, Alerts, Automation resources, Backup resources and 1st and 3rd party deployment and management systems such as GitHub worker nodes, compliance tools, scanners, etc.

### 1.3. Connectivity
Typically central networking components including hub networks or vHubs in vWAN, ExpressRoute, VPN, DNS, etc. 

Sometimes you might want to split this into multiple root modules based on functionality:
- Core Networking (connections, segmentation, firewalls, VNETs)
- DNS infrastructure
- DMZ network services (WAFs, proxies, etc.)

In complex environments splitting root modules by region dimension might be also useful.

### 1.4. Identity
This can include configuration of Entra ID (if in scope of automation project), but also instances of Domain Controllers or other tools including 3rd parties (eg. CyberArk).

## 2. Landing Zones
Each subscription is landing zone for certain project or workload (or multiple smaller workloads) and typically will consist of:
- VNET and connection to cetral hub
- Per-subscription assignment of RBAC roles (team members) or policies (eg. exceptions for whatever is not applied via Management Group)
- Budget and cost management alerts
- Activity Log configuration (send logs to central location)
- Some "batteries included" resources might be created - starting Resource Group, preconfigured managed identity, Key Vault for secrets, Backup Vault, etc.

This is usually implemented as different modules, but orchestrated from single root module per subscription.

It is advised to keep every subscription as separate root module so there are no interdependencies between projects. Use techniques described earlier to maintain your code DRY (eg. nested super-module or Terragrunt tools). W

## 3. Workloads
Everything that is specific to workload is different layer, often managed by different team and might not even use the same tooling (it is for team to decide whether they want to use Terraform, Bicep, Pulumi, Crossplane or ClickOps). This usually consist of:

- Base application infrastructure layer (AKS, Azure SQL, Azure Functions, ...)
- Monitoring and deployment layers (Application Insights, Grafana, Prometheus, GitHub runners)
- Application deployment (eg. ArgoCD system using Helm and GitOps or push to via GitHub Actions)
- Integration layers (API Management, Event Grid, etc.)