# content_menu.gd
class_name ContentMenu
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var back_button = $MarginContainer/VBoxContainer/BackButton
@onready var preview_root = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer
@onready var empty_label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/EmptyLabel

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	visibility_changed.connect(func():
		if visible: reset())
	
	back_button.pressed.connect(func():
		Title.interface.menu = Title.interface.home)

func reset() -> void:
	for child in preview_root.get_children(): if child is PackPreview: child.queue_free()
	empty_label.visible = Content.pack_info.is_empty()
	for guid in Content.pack_info:
		var info = Content.pack_info[guid]
		var preview = Prefabs.PACK_PREVIEW.instantiate()
		preview_root.add_child(preview)
		preview.set_pack_info(info)
