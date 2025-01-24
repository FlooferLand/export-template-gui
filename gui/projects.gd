extends Control
class_name ETG_ProjectScreen

@export_group("Nodes")
@export var project_container: BoxContainer
@export var open_data_button: TextureButton

@export_group("References")
@export var project_template: PackedScene
@export var default_icon: Texture2D

var selected: ETG_ProjectTemplate = null

func _ready() -> void:
	# TODO: Make sure the path is correct
	var projects_cfg := OS.get_user_data_dir().get_base_dir().get_base_dir() + "/projects.cfg"

	# Creating projects.cfg reader
	var config := ConfigFile.new()
	if config.load(projects_cfg) != OK:
		var error_label := Label.new()
		error_label.text = "No project found.\nMake sure you already have scanned projects in the Godot project manager!"
		project_container.add_child(error_label)
		return

	# Reading the projects
	# TODO: Add sorting, and always sort favourites to be at the top
	for path in config.get_sections():
		# Reading additional project data
		var additional := ConfigFile.new()
		if additional.load(path + "/project.godot") != OK:
			pass  # CHECK: Should be okay to continue like this? Only the path is really necessary

		# TODO: HOW ON EARTH DO WE GET THE OTHER INFORMATION?? (starred, etc
		var project_name: String = additional.get_value("application", "config/name", path.split("/")[-1])
		var project_icon := Image.new()
		if project_icon.load((additional.get_value("application", "config/icon", default_icon) as String).replace("res://", path + "/")) != OK:
			project_icon = default_icon.get_image()

		# Creating the project entry
		var entry: ETG_ProjectTemplate = project_template.instantiate()
		entry.info.path = path
		entry.info.name = project_name
		entry.info.icon = ImageTexture.create_from_image(project_icon)
		entry.info.favourite = config.get_value(path, "favorite", false)
		entry.info.date = "??-??-????"   # ??
		entry.info.version = "4.x"       # ??
		entry.data = ETG_ProjectData.new(entry.info)
		project_container.add_child(entry)

	# Check if the user has installed stuff
	ProjectManager.check_installed_necessary_things()

func _on_edit_pressed() -> void:
	ProjectManager.load_project(selected.info)

func _on_data_folder_button_pressed() -> void:
	OS.shell_show_in_file_manager(ETG_GodotRepo.new("", "").src_folder)
