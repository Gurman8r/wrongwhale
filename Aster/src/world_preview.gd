# world_preview.gd
class_name WorldPreview
extends PanelContainer

@onready var name_panel = $MarginContainer/HBoxContainer/NamePanel
@onready var name_label = $MarginContainer/HBoxContainer/NamePanel/MarginContainer/NameLabel
@onready var name_edit = $MarginContainer/HBoxContainer/NamePanel/MarginContainer/NameEdit
@onready var play_button = $MarginContainer/HBoxContainer/PlayButton
@onready var delete_button = $MarginContainer/HBoxContainer/DeleteButton
@onready var edit_button = $MarginContainer/HBoxContainer/EditButton
@onready var delete_confirm_panel = $MarginContainer/HBoxContainer/DeleteConfirmPanel
@onready var delete_confirm_label = $MarginContainer/HBoxContainer/DeleteConfirmPanel/MarginContainer/VBoxContainer/DeleteConfirmLabel
@onready var delete_accept_button = $MarginContainer/HBoxContainer/DeleteConfirmPanel/MarginContainer/VBoxContainer/HBoxContainer/DeleteAcceptButton
@onready var delete_cancel_button = $MarginContainer/HBoxContainer/DeleteConfirmPanel/MarginContainer/VBoxContainer/HBoxContainer/DeleteCancelButton

func set_world_data(world_data: WorldData):
	name_label.text = world_data.name
	
	play_button.pressed.connect(func():
		Ref.main.load_world_from_memory(world_data))
	
	delete_button.pressed.connect(func():
		name_label.hide()
		play_button.hide()
		delete_button.hide()
		edit_button.hide()
		delete_confirm_label.text = "Are you sure you want to delete \'%s\'?" % [world_data.name]
		delete_confirm_panel.show())
	
	edit_button.pressed.connect(func():
		if not name_edit.visible:
			name_label.hide()
			play_button.hide()
			delete_button.hide()
			name_edit.placeholder_text = world_data.name
			name_edit.show()
		else:
			name_edit.hide()
			name_label.show()
			play_button.show()
			delete_button.show()
		edit_button.release_focus())
	
	name_edit.text_submitted.connect(func(new_text: String):
		name_edit.hide()
		if world_data.name != new_text:
			Util.wipe(WorldData.get_dir_path(world_data.guid))
			world_data.guid = new_text.replace(" ", "_")
			world_data.name = new_text
			name_label.text = new_text
			WorldData.write(world_data)
		name_label.show()
		play_button.show()
		delete_button.show())
	
	delete_accept_button.pressed.connect(func():
		Ref.ui.title.loadgame.refresh()
		queue_free())
	
	delete_cancel_button.pressed.connect(func():
		name_label.show()
		play_button.show()
		delete_button.show()
		edit_button.show()
		delete_confirm_panel.hide())
