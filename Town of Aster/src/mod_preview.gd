# mod_preview.gd
class_name ModPreview
extends Control

@onready var bg: PanelContainer = $bg
@onready var icon: TextureRect = $bg/MarginContainer/HBoxContainer/IconContainer/icon
@onready var name_label: Label = $bg/MarginContainer/HBoxContainer/LabelsContainer/VBoxContainer/name
@onready var version_label: Label = $bg/MarginContainer/HBoxContainer/LabelsContainer/VBoxContainer/version
@onready var tagline_label: Label = $bg/MarginContainer/HBoxContainer/LabelsContainer/VBoxContainer/tagline
@onready var enabled_button: CheckButton = $bg/MarginContainer/HBoxContainer/ButtonsContainer/VBoxContainer/enabled
@onready var reload_button: Button = $bg/MarginContainer/HBoxContainer/ButtonsContainer/VBoxContainer/reload
