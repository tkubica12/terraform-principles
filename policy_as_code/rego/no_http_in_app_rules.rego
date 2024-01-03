package firewall

import future.keywords.contains
import future.keywords.if

violation contains msg if {
	input.rules[rule].protocols.Http
	msg := sprintf("Http protocol should not be used, found one in '%v' rule of '%v'.", [rule, input.name])
}
