# ui_title_loadgame.gd
class_name UI_TitleLoadGame
extends Control

const world_preview_prefab = preload("res://assets/scenes/world_preview.tscn")

@onready var preview_root = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer
@onready var empty_label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/EmptyLabel

var path_list: Array[String]
var previews: Array[WorldPreview]

func _ready() -> void:
	visibility_changed.connect(func():
		if not visible: clear()
		else: refresh())

func clear() -> void:
	for preview in previews: preview.queue_free()
	path_list.clear()
	previews.clear()

func refresh() -> void:
	path_list = WorldData.list()
	previews = []
	empty_label.visible = path_list.is_empty()
	for i in range(0, path_list.size()):
		var path: String = path_list[i]
		var world_preview: WorldPreview = world_preview_prefab.instantiate()
		previews.append(world_preview)
		preview_root.add_child(world_preview)
		world_preview.set_world_data(WorldData.read(path))

func _on_button_back_pressed() -> void:
	Ref.ui.title.current_menu = Ref.ui.title.main
