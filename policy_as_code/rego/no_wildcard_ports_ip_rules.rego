package firewall

import future.keywords.contains
import future.keywords.if

violation contains msg if {
	value := input.ip_rules[rule].destination_ports[port]
	contains(value, "*")
	msg := sprintf("Ports of ip_rules should not contain wildcards, found '%v' in '%v' rule of '%v'.", [value, rule, input.name])
}
