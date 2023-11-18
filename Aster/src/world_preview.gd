# world_preview.gd
class_name WorldPreview
extends PanelContainer

@onready var name_panel = $MarginContainer/HBoxContainer/NamePanel
@onready var name_label = $MarginContainer/HBoxContainer/NamePanel/MarginContainer/NameLabel
@onready var buttons_panel = $MarginContainer/HBoxContainer/ButtonsPanel
@onready var play_button = $MarginContainer/HBoxContainer/ButtonsPanel/MarginContainer/HBoxContainer/PlayButton
@onready var delete_button = $MarginContainer/HBoxContainer/ButtonsPanel/MarginContainer/HBoxContainer/DeleteButton
@onready var edit_button = $MarginContainer/HBoxContainer/ButtonsPanel/MarginContainer/HBoxContainer/EditButton
@onready var delete_confirmation_panel = $MarginContainer/HBoxContainer/DeleteConfirmationPanel
@onready var delete_message_label = $MarginContainer/HBoxContainer/DeleteConfirmationPanel/MarginContainer/HBoxContainer/DeleteMessageLabel
@onready var delete_confirm_button = $MarginContainer/HBoxContainer/DeleteConfirmationPanel/MarginContainer/HBoxContainer/DeleteConfirmButton
@onready var delete_cancel_button = $MarginContainer/HBoxContainer/DeleteConfirmationPanel/MarginContainer/HBoxContainer/DeleteCancelButton

func set_world_data(world_data: WorldData):
	name_label.text = world_data.name
	play_button.pressed.connect(func():
		Ref.main.load_world_from_file(world_data.guid))
	delete_button.pressed.connect(func():
		name_label.hide()
		buttons_panel.hide()
		delete_confirmation_panel.show()
		delete_message_label.text = "Are you sure you want to delete %s?" % [world_data.name])
	delete_confirm_button.pressed.connect(func():
		Util.wipe(WorldData.get_dir_path(world_data.guid))
		Ref.ui.title.loadgame.refresh()
		queue_free())
	delete_cancel_button.pressed.connect(func():
		name_label.show()
		buttons_panel.show()
		delete_confirmation_panel.hide())
