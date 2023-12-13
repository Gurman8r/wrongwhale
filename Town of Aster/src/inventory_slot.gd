# inventory_slot.gd
class_name InventorySlot
extends PanelContainer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

signal clicked(index: int, button_index: int)

@export var index: int = 0

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var highlighted_rect: TextureRect = $MarginContainer/SelectedRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var quantity_label: Label = $QuantityLabel

var highlighted: bool = false : set = set_highlighted
var durability: float = -1 : set = set_durability

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready():
	highlighted_rect.visible = false
	progress_bar.visible = false
	progress_bar.value = durability
	
	gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton \
		and (event.button_index == MOUSE_BUTTON_LEFT \
		or event.button_index == MOUSE_BUTTON_RIGHT) \
		and event.is_pressed():
			clicked.emit(index, event.button_index))
	
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

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

func set_highlighted(value: bool):
	highlighted = value
	highlighted_rect.visible = value

func set_durability(value: float):
	durability = value
	progress_bar.visible = 0.0 < value
	progress_bar.value = value

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
