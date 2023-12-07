# util.gd
class_name Util

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func rands(length: int, chars: String) -> String:
	var s: String = ""
	var n: int = chars.length()
	for i in range(length):
		s += chars[randi() % n]
	return s

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func wipe_dir(dir_path: String) -> void:
	var dir: DirAccess = DirAccess.open(dir_path)
	if not dir: return
	if dir:
		dir.list_dir_begin()
		var path = dir.get_next()
		while path != "":
			var sub_path = "%s/%s" % [dir_path, path]
			if dir.current_is_dir():
				wipe_dir(sub_path)
			else:
				DirAccess.remove_absolute(sub_path)
			path = dir.get_next()
	DirAccess.remove_absolute(dir_path)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path: String) -> Resource:
	if not ResourceLoader.exists(path): return null
	else: return ResourceLoader.load(path).duplicate()

static func write(data: Resource, path: String) -> Error:
	assert(data)
	DirAccess.remove_absolute(path)
	return ResourceSaver.save(data, path)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
