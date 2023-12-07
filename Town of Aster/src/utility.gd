# util.gd
class_name Utility

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func rands(length: int, chars: String) -> String:
	var s: String = ""
	var n: int = chars.length()
	for i in range(length):
		s += chars[randi() % n]
	return s

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func set_enabled(node: Node, value: bool) -> void:
	if not node: return
	for child in node.get_children(): set_enabled(child, value)
	node.set_physics_process(value)
	node.set_physics_process_internal(value)
	node.set_process(value)
	node.set_process_input(value)
	node.set_process_internal(value)
	node.set_process_shortcut_input(value)
	node.set_process_unhandled_input(value)
	node.set_process_unhandled_key_input(value)
	if "visible" in node: node.visible = value
	if "disabled" in node: node.disabled = not value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path: String) -> Resource:
	if not ResourceLoader.exists(path): return null
	else: return ResourceLoader.load(path).duplicate()

static func write(data: Resource, path: String) -> Error:
	assert(data)
	DirAccess.remove_absolute(path)
	return ResourceSaver.save(data, path)

static func wipe(dir_path: String) -> bool:
	var dir: DirAccess = DirAccess.open(dir_path)
	if not dir: return false
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
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
