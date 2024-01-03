package firewall

import future.keywords.contains
import future.keywords.if

violation contains msg if {
    ports := split(input.group_rules[rule].destination_ports[_], "-")
	(to_number(ports[1]) - to_number(ports[0]) > 5000)
	msg := sprintf("Port ranges should not be too big, found violation in '%v' rule of '%v'.", [rule, input.name])
}

