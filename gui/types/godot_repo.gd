extends Object
class_name ETG_GodotRepo

var working_folder = OS.get_user_data_dir()
var src_folder = working_folder + "/godot"

var id: String
var branch: String

func _init(repo: String, branch: String) -> void:
	self.id = repo
	self.branch = branch
	DirAccess.make_dir_recursive_absolute(src_folder)

func change_branch(new_branch: String):
	branch = new_branch.split(" ")[0]

func has_downloaded() -> bool:
	var src_dir := DirAccess.open(src_folder)
	if src_dir == null:
		return false
	return src_dir.dir_exists(branch)

func install_branch_if_not_present() -> void:
	if not has_downloaded():
		DirAccess.make_dir_recursive_absolute(src_folder)
		Util.cd_execute(src_folder, "git", ["clone", "https://github.com/godotengine/godot.git", branch, "--depth=1", "--branch="+branch])
