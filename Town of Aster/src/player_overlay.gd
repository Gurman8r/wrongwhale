# player_overlay.gd
class_name PlayerOverlay
extends CanvasLayer

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var hotbar_inventory: HotbarInventory = $HotbarInventory
@onready var interact_label: Label = $InteractLabel

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _ready() -> void:
	pass

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
