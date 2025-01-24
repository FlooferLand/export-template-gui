extends Control

@export_group("Nodes")
@export var build_size_label: Label
@export var project_name_label: Label
@export var project_path_label: Label
@export var project_branch_picker: OptionButton
@export var project_repo_edit: LineEdit
@export var module_list: BoxContainer

@export_group("Resources")
@export var module_template: PackedScene

var repo: ETG_GodotRepo
var builder: ETG_GodotBuilder

func _ready() -> void:
	project_name_label.text = ProjectManager.project_info.name
	project_path_label.text = ProjectManager.project_info.path

	# Default repo
	update_repo()

func update_repo() -> void:
	if project_repo_edit.text.is_empty():
		project_repo_edit.text = "https://github.com/godotengine/godot"
	if project_repo_edit.text.begins_with("https://github.com/"):
		project_repo_edit.text = project_repo_edit.text.replace("https://github.com/", "")
	repo = ETG_GodotRepo.new(
		project_repo_edit.text,
		project_branch_picker.get_item_text(project_branch_picker.selected)
	)
	builder = ETG_GodotBuilder.new(repo)

	# Updating the version picker
	var req := AwaitableHTTPRequest.new()
	add_child(req)
	var resp := await req.async_request("https://api.github.com/repos/{repo}/branches".format({ "repo": repo.id }))
	if resp.success() and resp.status_ok():
		var branches = (resp.body_as_json() as Array)
		branches.sort_custom(func(a_dict, b_dict):
			var a: String = a_dict["name"]
			var b: String = b_dict["name"]
			if a.is_valid_float() and b.is_valid_float():
				return float(a) > float(b)
			return false
		)

		project_branch_picker.clear()
		for branch in branches:
			var branch_name: String = branch["name"]
			if branch_name.is_valid_float():
				if float(branch_name) < 3.0:
					branch_name = "%s (might break)" % branch_name
			project_branch_picker.add_item(branch_name)
	else:
		OS.alert("Failed to fetch GitHub repository at '%s'" % repo.id)
		return

func _on_build_pressed() -> void:
	# Downloading the source
	repo.install_branch_if_not_present()

	# Compiling the source
	# [..]

func _on_version_item_selected(index: int) -> void:
	repo.change_branch(project_branch_picker.get_item_text(index))

func _on_repo_text_focus_exited() -> void:
	update_repo()

# TODO: Make the save button not required; auto-save when stuff changes
func _on_save_button_pressed() -> void:
	ProjectManager.save_project()
