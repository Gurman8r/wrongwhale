# pack_preview.gd
class_name PackPreview
extends PanelContainer

@onready var icon: TextureRect = $MarginContainer/HBoxContainer/IconContainer/icon
@onready var name_label: Label = $MarginContainer/HBoxContainer/LabelsContainer/VBoxContainer/name
@onready var version_label: Label = $MarginContainer/HBoxContainer/LabelsContainer/VBoxContainer/version
@onready var tagline_label: Label = $MarginContainer/HBoxContainer/LabelsContainer/VBoxContainer/tagline

var pack_info: Dictionary

func set_pack_info(value: Dictionary) -> void:
	assert(value)
	pack_info = value
	name_label.text = pack_info.name
	version_label.text = "%s (%s)" % [pack_info.version, "debug" if Game.is_debug() else "release"]
	tagline_label.text = pack_info.description
