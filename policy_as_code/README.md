# Policy as Code

## Linting - pre-built Terraform policies
In this demo we will use [TFLint](https://github.com/terraform-linters/tflint).

Here is [list of AzureRM rules](https://github.com/terraform-linters/tflint-ruleset-azurerm/blob/master/docs/README.md)

```
tflint --init

tflint

2 issue(s) found:

Warning: terraform "required_version" attribute is required (terraform_required_version)

  on  line 0:
   (source code not available)

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.5.0/docs/rules/terraform_required_version.md

Error: "Warm" is an invalid value as access_tier (azurerm_storage_account_invalid_access_tier)

  on storage.tf line 7:
   7:   access_tier              = "Warm"

Reference: https://github.com/terraform-linters/tflint-ruleset-azurerm/blob/v0.25.1/docs/rules/azurerm_storage_account_invalid_access_tier.md
```

## Terrascan - pre-built cloud security policies
In this demo we will use [Terrascan](https://runterrascan.io/docs/getting-started/)

Here is [list of Azure rules](https://runterrascan.io/docs/policies/azure/)

```
terrascan init
terrascan scan

...

Violation Details -

        Description    :        Ensure that Azure Virtual Network subnet is configured with a Network Security Group
        File           :        networking.vnet.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        8
        Severity       :        MEDIUM
        -----------------------------------------------------------------------

        Description    :        Ensure that logging for Azure KeyVault is 'Enabled'
        File           :        keyvault.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        9
        Severity       :        HIGH
        -----------------------------------------------------------------------

        Description    :        Ensure that Azure Resource Group has resource lock enabled
        File           :        main.tf
        Module Name    :        root
        Plan Root      :        ./
        Line           :        1
        Severity       :        LOW
        -----------------------------------------------------------------------


Scan Summary -

        File/Folder         :   /mnt/c/Users/tokubica/OneDrive - Microsoft/git/terraform-principles/policy_as_code
        IaC Type            :   terraform
        Scanned At          :   2024-01-03 19:50:00.325487433 +0000 UTC
        Policies Validated  :   11
        Violated Policies   :   3
        Low                 :   1
        Medium              :   1
        High                :   1
```

## Open Policy Agent - custom policies
Advanced solutions often use [Open Policy Agent](https://www.openpolicyagent.org/) and Rego language. This applies often to Kubernetes policies (Azure Policy for Kubernetes, Palo Alto Prisma), but pretty much for anything else including Terraform, YAML or JSON files. Terrascan policies are also written in Rego.

Here is my example from abstraction that is using YAML files to configure firewall rules on Azure firewall (source is [here](https://github.com/tkubica12/tf-azure-firewall-rules.git)). We will create Rego policies on top of YAML files. Here is one example - rule can contain single port range and we need to identify those ranges, that include specific unsecured ports. Eg. if rule range is 76-92 it should be triggered because it contains port 80.

```
package firewall

import future.keywords.contains
import future.keywords.if

violation contains msg if {
    ports := split(input.group_rules[rule].destination_ports[range], "-")
	(to_number(ports[0]) < 21) == (to_number(ports[1]) > 21)
    (to_number(ports[0]) < 23) == (to_number(ports[1]) > 23)
    (to_number(ports[0]) < 25) == (to_number(ports[1]) > 25)
    (to_number(ports[0]) < 80) == (to_number(ports[1]) > 80)
    (to_number(ports[0]) < 389) == (to_number(ports[1]) > 389)
    (to_number(ports[0]) < 8080) == (to_number(ports[1]) > 8080)
	msg := sprintf("Unsecured ports should not be allowed including 21, 23, 25, 80, 389, 8080, found '%v' in '%v' rule of '%v'.", [range, rule, input.name])
}
```

To check rules we can run Open Policy Agent.

```bash
for file in  $(find ./rules -name *.yaml)
  do
      echo ">>> Evaluating $file <<<"
      result=$(./opa eval -i $file -d ./rego -f pretty data.firewall.violation)
      echo $result | jq .[] --raw-output
      if [ "$result" != "[]" ]; then
          exit=1
      fi
      echo
  done

>>> Evaluating ./rules/crm/net-management.yaml <<<

>>> Evaluating ./rules/erp/net-management.yaml <<<

>>> Evaluating ./rules/erp/net-sap_apis.yaml <<<
Ports of group_rules should not contain wildcards, found '*' in 'sap_apis' rule of 'SAP APIs'.

>>> Evaluating ./rules/global/app-best_blogs.yaml <<<
Http protocol should not be used, found one in 'community' rule of 'Best blogs'.

>>> Evaluating ./rules/global/app-microsoft_services.yaml <<<

>>> Evaluating ./rules/global/app-update_services.yaml <<<
Http protocol should not be used, found one in 'microsoft' rule of 'Azure services'.
Http protocol should not be used, found one in 'ubuntu' rule of 'Azure services'.

>>> Evaluating ./rules/metadata.yaml <<<

>>> Evaluating ./rules/shared_services/net-ad.yaml <<<
Port ranges should not be too big, found violation in 'ad_services_groups' rule of 'Active Directory services'.

>>> Evaluating ./rules/shared_services/net-dns.yaml <<<

>>> Evaluating ./rules/website/app-api_services.yaml <<<

>>> Evaluating ./rules/website/net-management.yaml <<<
```


