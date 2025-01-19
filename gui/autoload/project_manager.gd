extends Node

var project_info: ETG_ProjectInfo = null

func load_project(info: ETG_ProjectInfo) -> void:
	project_info = info
	get_tree().change_scene_to_file("res://gui/builder.tscn")
