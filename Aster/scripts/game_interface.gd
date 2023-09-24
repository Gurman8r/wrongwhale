# game_interface.gd
class_name GameInterface
extends Control

signal toggle_inventory()
signal drop_stack(stack: ItemStack)
signal force_close()

const item_prefab = preload("res://scenes/item_entity.tscn")

@onready var player_inventory: Inventory = $PlayerInventory
@onready var equip_inventory: Inventory = $EquipInventory
@onready var external_inventory: Inventory = $ExternalInventory
@onready var grabbed_slot: InventorySlot = $GrabbedSlot

var grabbed_stack: ItemStack
var external_inventory_owner

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _unhandled_input(_event) -> void:
	if visible \
	and Input.is_action_just_pressed("ui_cancel") \
	or Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		get_viewport().set_input_as_handled()

func _physics_process(_delta) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)
	if external_inventory_owner \
	and external_inventory_owner.global_position.distance_to(Ref.player.global_position) > 4:
		force_close.emit()
	
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func toggle(_external_inventory_owner = null) -> void:
	visible = not visible
	if _external_inventory_owner and visible:
		set_external_inventory_owner(_external_inventory_owner)
	else:
		clear_external_inventory()

func set_player_inventory_data(value: InventoryData) -> void:
	value.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(value)

func set_equip_inventory_data(value: InventoryData) -> void:
	value.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(value)

func set_external_inventory_owner(value) -> void:
	external_inventory_owner = value
	var inventory_data = external_inventory_owner.inventory_data
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_inventory.show()

func clear_external_inventory() -> void:
	if not external_inventory_owner: return
	var inventory_data = external_inventory_owner.inventory_data
	inventory_data.inventory_interact.disconnect(on_inventory_interact)
	external_inventory.clear_inventory_data(inventory_data)
	external_inventory.hide()
	external_inventory_owner = null

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_stack, button]:
		[null, MOUSE_BUTTON_LEFT]: grabbed_stack = inventory_data.grab_stack(index)
		[null, MOUSE_BUTTON_RIGHT]: grabbed_stack = inventory_data.grab_split_stack(index)
		[_, MOUSE_BUTTON_LEFT]: grabbed_stack = inventory_data.drop_stack(grabbed_stack, index)
		[_, MOUSE_BUTTON_RIGHT]: grabbed_stack = inventory_data.drop_single(grabbed_stack, index)
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_stack:
		grabbed_slot.show()
		grabbed_slot.set_stack(grabbed_stack)
	else:
		grabbed_slot.hide()

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

func _on_drop_stack(stack: ItemStack) -> void:
	var drop = item_prefab.instantiate()
	drop.stack = stack
	drop.position = Ref.player.global_position + (-Ref.player.global_transform.basis.z * 2)
	add_child(drop)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and grabbed_stack:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_stack.emit(grabbed_stack)
				grabbed_stack = null
			MOUSE_BUTTON_RIGHT:
				drop_stack.emit(grabbed_stack.create_single_stack())
				if grabbed_stack.quantity < 1:
					grabbed_stack = null
		update_grabbed_slot()

func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Ref.ui.game_overlay.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Ref.ui.game_overlay.show()
		if grabbed_stack:
			drop_stack.emit(grabbed_stack)
			grabbed_stack = null
			update_grabbed_slot()
		get_tree().paused = false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
