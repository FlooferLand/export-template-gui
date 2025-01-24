extends Object
class_name ETG_GodotBuilder

var repo: ETG_GodotRepo
var settings := Dictionary()

func _init(repository: ETG_GodotRepo) -> void:
	repo = repository
	update()

func update() -> void:
	#region Loading available modules
	var out_txt := []
	Util.cd_execute(
		"%s/%s/" % [repo.src_folder, repo.branch],
		"scons", ["--help"],
		out_txt
	)

	var out_joined := '\n'.join(out_txt).strip_edges()
	var out_split := out_joined.split("\r\n\r\n")
	out_split.remove_at(0)
	out_split.remove_at(len(out_split) - 1)

	var out_fuck: Array[PackedStringArray] = []
	for elem in out_split:
		var s := elem.split('\n')
		for x in range(len(s)):
			s[x] = s[x].strip_edges()
		out_fuck.push_back(s)
	out_fuck.remove_at(len(out_split) - 1)

	for line in out_fuck:
		line = line as Array[PackedStringArray]
		var header: PackedStringArray = line[0].split(": ", false, 1)
		var body := {}
		for elem in line.slice(1, len(line)):
			var split = elem.strip_edges().split(": ")
			body[split[0]] = split[1] if len(split) > 1 else ""
		var choice_arr := header[1].rsplit('(', false, 1)
		if len(choice_arr) > 1:
			var choice_str := choice_arr[1].substr(0, len(choice_arr[1]) - 2)
			var choices := choice_str.split('|')
			if header[0].begins_with("module_"):
				var module_name := header[0].replace("module_", "").replace("_enabled", "")
				var module_default := (body["default"] as String).to_lower() in ["true", "1"]
				var modules := ProjectManager.project_data.modules
				modules[module_name] = ETG_Module.new(
					module_name,
					modules[module_name].enabled if modules.has(module_name) else module_default,
					module_default
				)
				ProjectManager.project_data.modules = modules
			else:
				pass  # TODO: Add the settings that aren't module switches
	#endregion
