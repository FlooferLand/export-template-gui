extends Object
class_name ETG_ProjectData

var modules := Dictionary()

var save_path: String

func _init(info: ETG_ProjectInfo) -> void:
	save_path = info.path + "/build.godot"

func load() -> void:
	# If the file doesn't exist..
	if not FileAccess.file_exists(save_path):
		print("Failed to find existing project data for '%s', creating new data.." % save_path)
		save()

	# Config
	var config := ConfigFile.new()
	if config.load(save_path) != OK:
		push_error("Error reading project data for '%s'" % save_path)
		return

	# Loading saved module values
	for key in config.get_section_keys("modules"):
		var value: bool = config.get_value("modules", key)
		var module: ETG_Module = modules.get(key)
		if module == null:
			printerr("Module \"%s\" not found" % key)
			continue
		module.enabled = value

func save() -> void:
	var config := ConfigFile.new()
	for module in modules.values():
		module = module as ETG_Module
		config.set_value("modules", module.name, module.enabled)

	# Writing the file
	var text := """
		; export-template-gui configuration file.
		; It's best edited using the editor UI and not directly,
		; since the parameters that go here are not all obvious.
		;
		; Format:
		;   [section]     ; section goes between []
		;   param=value   ; assign values to parameters
	""".replace('\t', '').strip_edges() + '\n' + config.encode_to_text()
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(text)
	file.close()
