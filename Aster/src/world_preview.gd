# world_preview.gd
class_name WorldPreview
extends PanelContainer

@onready var farm_name_panel = $MarginContainer/VBoxContainer/HBoxContainer/FarmNamePanel
@onready var farm_name_label = $MarginContainer/VBoxContainer/HBoxContainer/FarmNamePanel/MarginContainer/FarmNameLabel
@onready var farm_name_edit = $MarginContainer/VBoxContainer/HBoxContainer/FarmNamePanel/MarginContainer/FarmNameEdit

@onready var button_root = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer
@onready var play_button = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/PlayButton
@onready var delete_button = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/DeleteButton
@onready var edit_button = $MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/EditButton

@onready var delete_confirm_panel = $MarginContainer/VBoxContainer/DeleteConfirmPanel
@onready var delete_confirm_label = $MarginContainer/VBoxContainer/DeleteConfirmPanel/MarginContainer/VBoxContainer/DeleteConfirmLabel
@onready var delete_accept_button = $MarginContainer/VBoxContainer/DeleteConfirmPanel/MarginContainer/VBoxContainer/HBoxContainer/DeleteAcceptButton
@onready var delete_cancel_button = $MarginContainer/VBoxContainer/DeleteConfirmPanel/MarginContainer/VBoxContainer/HBoxContainer/DeleteCancelButton

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == 1:
		var evLocal = make_input_local(event)
		if !Rect2(farm_name_edit.global_position, farm_name_edit.size).has_point(evLocal.position):
			farm_name_edit.release_focus()

func set_world_data(world_data: WorldData):
	farm_name_label.text = "%s Farm" % [world_data.farm_data.name]
	
	play_button.pressed.connect(func():
		G.main.load_world_from_memory(world_data))
	
	delete_button.pressed.connect(func():
		farm_name_label.hide()
		button_root.hide()
		delete_confirm_label.text = "Delete \'%s Farm\'?" % [world_data.farm_data.name]
		delete_confirm_panel.show())
	
	edit_button.pressed.connect(func():
		if not farm_name_edit.visible:
			farm_name_label.hide()
			play_button.hide()
			delete_button.hide()
			farm_name_edit.placeholder_text = "%s" % [world_data.farm_data.name]
			farm_name_edit.show()
		else:
			farm_name_edit.hide()
			farm_name_label.show()
			play_button.show()
			delete_button.show()
		edit_button.release_focus())
	
	farm_name_edit.text_submitted.connect(func(new_text: String):
		if new_text == "": return
		farm_name_edit.hide()
		farm_name_edit.text = ""
		if world_data.name != new_text:
			var old_guid = world_data.guid
			world_data.farm_data.name = new_text
			world_data.guid = new_text.replace(" ", "_")
			world_data.name = new_text
			farm_name_label.text = new_text
			WorldData.write(world_data)
			Util.wipe_dir(WorldData.get_dir_path(old_guid))
		farm_name_label.text = "%s Farm" % [new_text]
		farm_name_label.show()
		play_button.show()
		delete_button.show())
	
	delete_accept_button.pressed.connect(func():
		Util.wipe_dir(WorldData.get_dir_path(world_data.guid))
		G.ui.title.world_loader._reset()
		queue_free())
	
	delete_cancel_button.pressed.connect(func():
		farm_name_label.show()
		button_root.show()
		delete_confirm_panel.hide())
