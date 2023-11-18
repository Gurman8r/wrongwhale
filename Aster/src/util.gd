# util.gd
class_name Util

static func wipe(dir_path: String) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if not dir: return
	if dir:
		dir.list_dir_begin()
		var path = dir.get_next()
		while path != "":
			var sub_path = "%s/%s" % [dir_path, path]
			if dir.current_is_dir():
				wipe(sub_path)
			else:
				DirAccess.remove_absolute(sub_path)
			path = dir.get_next()
	DirAccess.remove_absolute(dir_path)
