extends Node

func cd_execute(path: String, command: String, args: PackedStringArray, output: Array = []) -> int:
	var exit_code: int
	var full_cmd = command + " " + " ".join(args)
	match OS.get_name():
		"Windows":
			print("cmd", ["/C", "cd %s && %s" % [path, full_cmd]])
			exit_code = OS.execute("cmd", ["/C", "cd %s && %s" % [path, full_cmd]], output)
		"Linux", "BSD", "macOS":
			# If you're a macOS user and you're encountering problems because of this, buy a Linux machine
			# Apple can't even stay POSIX-compliant despite building macOS on BSD
			# Yet Linux and BSD are somehow intercompatible without even being related
			exit_code = OS.execute("sh", ["-c", "cd '%s' && %s" % [path, full_cmd]], output)
	return exit_code

func map(array: Array, map: Callable) -> Array:
	for elem in array:
		elem = map.call(elem)
	return array

func filter(array: Array, map: Callable) -> Array:
	var new := []
	for elem in array:
		if map.call(elem):
			new.push_back(elem)
	return new
