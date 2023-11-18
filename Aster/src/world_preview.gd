# world_preview.gd
class_name WorldPreview
extends PanelContainer

@onready var label_name = $MarginContainer/HBoxContainer/PanelContainer/MarginContainer/LabelName
@onready var button_play = $MarginContainer/HBoxContainer/ButtonPlay
@onready var button_delete = $MarginContainer/HBoxContainer/ButtonDelete

@onready var label_delete_confirmation = $MarginContainer/HBoxContainer/LabelDeleteConfirmation
@onready var button_confirm_delete = $MarginContainer/HBoxContainer/ButtonConfirmDelete
@onready var button_cancel_delete = $MarginContainer/HBoxContainer/ButtonCancelDelete

func _ready() -> void:
	button_delete.pressed.connect(func():
		button_play.hide()
		button_delete.hide()
		label_delete_confirmation.show()
		button_confirm_delete.show()
		button_cancel_delete.show())
	button_cancel_delete.pressed.connect(func():
		button_play.show()
		button_delete.show()
		label_delete_confirmation.hide()
		button_confirm_delete.hide()
		button_cancel_delete.hide())
