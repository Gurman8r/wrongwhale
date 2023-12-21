# player_interface.gd
class_name PlayerInterface
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

enum {
	INVENTORY,
	MAP,
	COLLECTION,
	SKILLS,
	JOURNAL,
	SETTINGS,
	SYSTEM
}

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal drop_stack(stack: ItemStack)
signal force_close()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var grabbed_slot: InventorySlot = $GrabbedSlot

# INVENTORY
@onready var inventory_container: Control = $InventoryContainer
@onready var external_label: Label = $InventoryContainer/VBoxContainer/ExternalLabel
@onready var external_inventory: Inventory = $InventoryContainer/VBoxContainer/ExternalInventory
@onready var internal_label: Label = $InventoryContainer/VBoxContainer/InternalLabel
@onready var internal_inventory: Inventory = $InventoryContainer/VBoxContainer/InternalInventory

# MENU
@onready var menu_container: Control = $MenuContainer
@onready var menu_tab_bar: TabBar = $MenuContainer/VBoxContainer/TabBar
@onready var menu_tab_container: TabContainer = $MenuContainer/VBoxContainer/Tabs

# INVENTORY TAB
@onready var inventory_tab: Control = $MenuContainer/VBoxContainer/Tabs/Inventory
@onready var main_inventory: Inventory = $MenuContainer/VBoxContainer/Tabs/Inventory/MarginContainer/HBoxContainer/MainInventory
@onready var equip_inventory: Inventory = $MenuContainer/VBoxContainer/Tabs/Inventory/MarginContainer/HBoxContainer/EquipInventory

# MAP TAB
@onready var map_tab: Control = $MenuContainer/VBoxContainer/Tabs/Map

# COLLECTION TAB
@onready var collection_tab: Control = $MenuContainer/VBoxContainer/Tabs/Collection

# SKILLS TAB
@onready var skills_tab: Control = $MenuContainer/VBoxContainer/Tabs/Skills

# SETTINGS TAB
@onready var settings_tab: Control = $MenuContainer/VBoxContainer/Tabs/Settings

# SYSTEM TAB
@onready var system_tab: Control = $MenuContainer/VBoxContainer/Tabs/System
@onready var save_button: Button = $MenuContainer/VBoxContainer/Tabs/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/SaveButton
@onready var save_and_quit_to_title_button: Button = $MenuContainer/VBoxContainer/Tabs/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/SaveAndQuitToTitleButton
@onready var save_and_quit_to_desktop_button: Button = $MenuContainer/VBoxContainer/Tabs/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/SaveAndQuitToDesktopButton
@onready var quit_to_title_button: Button = $MenuContainer/VBoxContainer/Tabs/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/QuitToTitleButton
@onready var quit_to_desktop_button: Button = $MenuContainer/VBoxContainer/Tabs/System/MarginContainer/HBoxContainer/LeftPanelContainer/MarginContainer/VBoxContainer/QuitToDesktopButton

var player_data: PlayerData
var grabbed_stack: ItemStack
var external_inventory_owner: Node

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS

func _ready():
	force_close.connect(toggle_inventory)
	
	drop_stack.connect(func(stack: ItemStack) -> void:
		var drop = Prefabs.ITEM_ENTITY.instantiate()
		drop.stack = stack
		World.cell.add(drop, Player.character.get_drop_position()))
	
	gui_input.connect(func(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.is_pressed() and grabbed_stack:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					drop_stack.emit(grabbed_stack)
					grabbed_stack = null
				MOUSE_BUTTON_RIGHT:
					drop_stack.emit(grabbed_stack.create_single_stack())
					if grabbed_stack.quantity < 1:
						grabbed_stack = null
			update_grabbed_slot())
	
	visibility_changed.connect(func():
		if not visible:
			menu_container.hide())
	
	menu_tab_bar.tab_changed.connect(func(tab: int):
		menu_tab_container.current_tab = tab)
	
	save_button.pressed.connect(Game.save)
	save_and_quit_to_title_button.pressed.connect(Game.save_and_quit_to_title)
	save_and_quit_to_desktop_button.pressed.connect(Game.save_and_quit_to_desktop)
	quit_to_title_button.pressed.connect(Game.quit_to_title)
	quit_to_desktop_button.pressed.connect(Game.quit_to_desktop)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("toggle_inventory") \
	or Input.is_action_just_pressed("toggle_pause"):
		if inventory_container.visible or menu_container.visible:
			force_close.emit()
			get_viewport().set_input_as_handled()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _physics_process(_delta) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)
	if external_inventory_owner \
	and external_inventory_owner.global_position.distance_to(Player.character.global_position) > 4:
		force_close.emit()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_player_data(value: PlayerData) -> void:
	if player_data == value: return
	player_data = value
	player_data.inventory.inventory_interact.connect(on_inventory_interact)
	player_data.equip["0"].inventory_interact.connect(on_inventory_interact)
	internal_inventory.set_inventory_data(player_data.inventory)
	main_inventory.set_inventory_data(player_data.inventory)
	equip_inventory.set_inventory_data(player_data.equip["0"])
	internal_label.text = "%s:" % [player_data.name]

func clear_player_data() -> void:
	if not player_data: return
	player_data.inventory.inventory_interact.disconnect(on_inventory_interact)
	player_data.equip["0"].inventory_interact.disconnect(on_inventory_interact)
	internal_inventory.clear_inventory_data(player_data.inventory)
	main_inventory.clear_inventory_data(player_data.inventory)
	equip_inventory.clear_inventory_data(player_data.equip["0"])
	internal_label.text = ""
	player_data = null

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func get_current_tab() -> int:
	return menu_tab_bar.current_tab

func set_current_tab(tab: int) -> void:
	if tab < 0:
		menu_container.hide()
	else:
		menu_tab_bar.current_tab = tab
		menu_container.show()
	update_internal()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func toggle_inventory(value: Node = null) -> void:
	if value: set_external_inventory_owner(value)
	elif inventory_container.visible: clear_external_inventory()
	elif not menu_container.visible: set_current_tab(0)
	else: set_current_tab(-1)

func set_external_inventory_owner(value: Node) -> void:
	external_inventory_owner = value
	var inventory_data = external_inventory_owner.data.inventory
	if not inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	external_label.text = "%s:" % [value.data.name]
	inventory_container.show()
	update_internal()

func clear_external_inventory() -> void:
	if not external_inventory_owner: return
	var inventory_data = external_inventory_owner.data.inventory
	if inventory_data.inventory_interact.is_connected(on_inventory_interact):
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
	external_inventory.clear_inventory_data(inventory_data)
	inventory_container.hide()
	external_label.text = ""
	external_inventory_owner = null
	update_internal()

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_stack, button]:
		[null, MOUSE_BUTTON_LEFT]: grabbed_stack = inventory_data.grab_stack(index)
		[null, MOUSE_BUTTON_RIGHT]: grabbed_stack = inventory_data.grab_split_stack(index)
		[_, MOUSE_BUTTON_LEFT]: grabbed_stack = inventory_data.drop_stack(grabbed_stack, index)
		[_, MOUSE_BUTTON_RIGHT]: grabbed_stack = inventory_data.drop_single(grabbed_stack, index)
	update_grabbed_slot()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func update_grabbed_slot() -> void:
	if grabbed_stack:
		grabbed_slot.show()
		grabbed_slot.set_stack(grabbed_stack)
	else:
		grabbed_slot.hide()

func update_internal() -> void:
	if menu_container.visible \
	or inventory_container.visible:
		Game.pause()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Player.hud.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Player.hud.show()
		if grabbed_stack:
			drop_stack.emit(grabbed_stack)
			grabbed_stack = null
			update_grabbed_slot()
		Game.unpause()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
