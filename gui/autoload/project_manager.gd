extends Node

var project_info: ETG_ProjectInfo = null
var project_data: ETG_ProjectData = null

func load_project(info: ETG_ProjectInfo) -> void:
	if check_installed_necessary_things():
		project_info = info
		project_data = ETG_ProjectData.new(info)
		project_data.load()
		get_tree().change_scene_to_file("res://gui/builder.tscn")

func save_project() -> void:
	project_data.save()

## Checking hard dependencies
## TODO: Install a portable version of these into user:// if not found
func check_installed_necessary_things() -> bool:
	if OS.execute("git", ["--version"]) != 0:
		OS.alert("Please install Git!\nIt can be aquired from\nhttps://git-scm.com/downloads/")
		return false
	if OS.execute("scons", ["--version"]) != 0:
		OS.alert("Please install Scons!\nYou can install it through your package manager (ex: scoop), or by installing Python and running \"python -m pip install scons\"")
		return false
	return true
