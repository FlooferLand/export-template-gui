extends Object
class_name ETG_Module

var name: String
var enabled: bool
var default: bool

func _init(_name: String, _enabled: bool, _default: bool):
	name = _name
	enabled = _enabled
	default = _default

func _to_string() -> String:
	return "%s = %s (default=%s)" % [name, enabled, default]
