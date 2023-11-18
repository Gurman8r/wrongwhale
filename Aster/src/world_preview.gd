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

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(name_edit.global_position, name_edit.size).has_point(evLocal.position):
			name_edit.release_focus()

func set_world_data(world_data: WorldData):
	name_label.text = "%s Farm" % [world_data.name]
	
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
		if new_text == "": return
		name_edit.hide()
		if world_data.name != new_text:
			var old_guid = world_data.guid
			world_data.guid = new_text.replace(" ", "_")
			world_data.name = new_text
			name_label.text = new_text
			WorldData.write(world_data)
			Util.wipe(WorldData.get_dir_path(old_guid))
		name_label.show()
		play_button.show()
		delete_button.show())
	
	delete_accept_button.pressed.connect(func():
		Util.wipe(WorldData.get_dir_path(world_data.guid))
		Ref.ui.title.world_loader.refresh()
		queue_free())
	
	delete_cancel_button.pressed.connect(func():
		name_label.show()
		play_button.show()
		delete_button.show()
		edit_button.show()
		delete_confirm_panel.hide())
