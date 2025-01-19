extends Control
class_name ETG_ProjectTemplate

# Should be set by the project manager scene
var info := ETG_ProjectInfo.new()

# Current scene nodes
@export_group("Local/Nodes")
@export var icon: TextureRect
@export var fav_icon: TextureRect
@export var folder_button: TextureButton
@export var button_highlight: ColorRect
@export var name_label: Label
@export var path_label: Label
@export var meta_version: Label
@export var meta_date: Label

# Current scene references
@export_group("Local/Resources")
@export var tex_favourited: Texture2D
@export var tex_unfavourited: Texture2D

var root: ETG_ProjectScreen

func _ready() -> void:
	root = get_tree().current_scene

	# Displaying the project info
	name_label.text = info.name
	path_label.text = info.path
	fav_icon.texture = tex_favourited if info.favourite else tex_unfavourited
	meta_version.text = info.version
	meta_date.text = info.date
	icon.texture = info.icon

	# Folder browse button
	folder_button.modulate = Color.BLACK.lerp(Color.WHITE, 0.5)
	folder_button.pressed.connect(func(): OS.shell_open(info.path))
	folder_button.mouse_entered.connect(func():
		folder_button.modulate = Color.BLACK.lerp(Color.WHITE, 1.0)
	)
	folder_button.mouse_exited.connect(func():
		folder_button.modulate = Color.BLACK.lerp(Color.WHITE, 0.5)
	)

func _on_button_pressed() -> void:
	# Double click workaround
	if root.selected == self:
		ProjectManager.load_project(info)
	else:
		if is_instance_valid(root.selected):
			root.selected.button_highlight.color = Color.TRANSPARENT
		root.selected = self

		var brightness := 0.15 if (root.selected == self) else 0.0
		button_highlight.color = Color.TRANSPARENT.lerp(Color.WHITE, brightness)
