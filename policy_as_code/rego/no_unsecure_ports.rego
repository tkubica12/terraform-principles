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

