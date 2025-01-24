extends Control
class_name ETG_ModuleEntry

var module_name: String:
	set(value):
		checkbox.text = value
	get:
		return checkbox.text

var module_enabled: bool:
	set(value):
		checkbox.button_pressed = value
	get:
		return checkbox.button_pressed

var module_description: String:
	set(value):
		description.text = value
	get:
		return description.text

@export_group("Local")
@export var checkbox: CheckBox
@export var description: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
