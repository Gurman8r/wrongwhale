# ui_title_loadgame.gd
class_name UI_TitleLoadGame
extends Control

const world_preview_prefab = preload("res://assets/scenes/world_preview.tscn")

@onready var preview_root = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer

var path_list: Array[String]

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()

func _on_visibility_changed() -> void:
	if not visible:
		path_list.clear()
		for child in preview_root.get_children():
			child.queue_free()
	else:
		path_list = WorldData.list()
		for i in range(0, path_list.size()):
			var path: String = path_list[i]
			var world_preview: WorldPreview = world_preview_prefab.instantiate()
			preview_root.add_child(world_preview)
			var world_data = WorldData.read(path)
			world_preview.label_name.text = world_data.name
			world_preview.button_play.pressed.connect(func():
				Ref.main.load_world_from_file(path))
			world_preview.button_confirm_delete.pressed.connect(func():
				var dir_path = WorldData.get_dir_path(path)
				Util.wipe(dir_path)
				world_preview.queue_free())

func _on_button_back_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.main
