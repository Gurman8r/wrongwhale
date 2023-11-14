# item_slot.gd
class_name ItemSlot
extends PanelContainer

signal clicked(index: int, button_index: int)

@export var selected: bool = false : set = set_selected

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var selected_rect: TextureRect = $MarginContainer/SelectedRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var quantity_label: Label = $QuantityLabel

func _ready():
	selected_rect.visible = false
	set_durability(100.0)

func set_stack(stack: ItemStack) -> void:
	var item_data = stack.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	if stack.quantity > 1:
		quantity_label.text = "(%s)" % [stack.quantity]
		quantity_label.show()
	else:
		quantity_label.hide()
	set_durability(stack.item_data.durability)

func set_selected(value: bool):
	selected = value
	selected_rect.visible = value

func set_durability(value: float):
	progress_bar.visible = value != 100.0
	progress_bar.value = value

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and (event.button_index == MOUSE_BUTTON_LEFT \
	or event.button_index == MOUSE_BUTTON_RIGHT) \
	and event.is_pressed():
		clicked.emit(get_index(), event.button_index)
