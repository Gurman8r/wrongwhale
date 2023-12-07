# world_loader.gd
class_name WorldLoader
extends PanelContainer

@onready var back_button = $MarginContainer/VBoxContainer/BackButton
@onready var preview_root = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer
@onready var empty_label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/EmptyLabel

func _ready() -> void:
	back_button.pressed.connect(func():
		Game.ui.title.current = Game.ui.title.home)
	visibility_changed.connect(func():
		if visible: _reset())

func _reset() -> void:
	for child in preview_root.get_children():
		if child is WorldPreview:
			child.queue_free()
	DirAccess.make_dir_absolute(WorldData.DIR_NAME)
	var saves_dir = DirAccess.open(WorldData.DIR_NAME)
	if not saves_dir: return
	saves_dir.list_dir_begin()
	var path = saves_dir.get_next()
	empty_label.visible = path.is_empty()
	while  path != "":
		if saves_dir.current_is_dir():
			var world_dir = DirAccess.open(WorldData.get_dir_path(path))
			if not world_dir: continue
			world_dir.list_dir_begin()
			if world_dir.file_exists("world.tres"):
				var preview: WorldPreview = preload("res://assets/scenes/world_preview.tscn").instantiate()
				preview_root.add_child(preview)
				preview.set_world_data(WorldData.read(path))
		path = saves_dir.get_next()
