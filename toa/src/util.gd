# util.gd
class_name Util

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func make(parent, node, name: String):
	parent.add_child(node)
	node.name = name
	return node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func btos(value: bool, lhs: String = "true", rhs: String = "false") -> String:
	if value: return lhs
	else: return rhs

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func rands(length: int, chars: String) -> String:
	var s: String = ""
	var n: int = chars.length()
	for i in range(length):
		s += chars[randi() % n]
	return s

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func set_recursive(node: Node, name: String, value) -> void:
	assert(node)
	assert(0 < name.length())
	for child in node.get_children(): set_recursive(child, name, value)
	if name in node: node[name] = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func set_active(node: Node, value: bool) -> void:
	assert(node)
	node.set_physics_process(value)
	node.set_physics_process_internal(value)
	node.set_process(value)
	node.set_process_input(value)
	node.set_process_internal(value)
	node.set_process_shortcut_input(value)
	node.set_process_unhandled_input(value)
	node.set_process_unhandled_key_input(value)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func set_enabled(node: Node, value: bool, recursive: bool = true) -> void:
	if !node: return
	if recursive: for child in node.get_children(): set_enabled(child, value)
	set_active(node, value)
	if "visible" in node: node.visible = value
	if "disabled" in node: node.disabled = !value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func read(path: String) -> Resource:
	if !ResourceLoader.exists(path): return null
	else: return ResourceLoader.load(path).duplicate()

static func write(data: Resource, path: String) -> Error:
	assert(data)
	DirAccess.remove_absolute(path)
	return ResourceSaver.save(data, path)

static func wipe_dir(dir_path: String) -> bool:
	var dir: DirAccess = DirAccess.open(dir_path)
	if !dir: return false
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
		dir.list_dir_end()
	DirAccess.remove_absolute(dir_path)
	return true

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

static func load_texture(path: String) -> ImageTexture:
	if Game.is_standalone(): return load(path)
	else: return ImageTexture.create_from_image(Image.load_from_file(path))

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

