extends Control

@export_group("Nodes")
@export var build_size_label: Label
@export var project_name_label: Label
@export var project_path_label: Label

var src_folder = "user://godot"
var has_downloaded_source:
	get:
		var user_dir := DirAccess.open(src_folder.get_base_dir())
		return user_dir.dir_exists(src_folder.get_file())

func _ready() -> void:
	project_name_label.text = ProjectManager.project_info.name
	project_path_label.text = ProjectManager.project_info.path

func _on_build_pressed() -> void:
	# Checking hard dependencies
	# TODO: Install a portable version of these into user:// if not found
	if OS.execute("git", ["--version"]) != 0:
		OS.alert("Please install Git!\nIt can be aquired from\nhttps://git-scm.com/downloads/")
		return
	if OS.execute("scons", ["--version"]) != 0:
		OS.alert("Please install Scons!\nYou can install it through your package manager (ex: scoop), or by installing Python and running \"python -m pip install scons\"")
		return

	# Downloading the source
	if not has_downloaded_source:
		pass

	# Compiling the source
	# [..]
