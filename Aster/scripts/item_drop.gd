# item_drop.gd
class_name ItemDrop
extends RigidBody3D

@export var stack: ItemStack

@onready var sprite_3d = $Sprite3D

func _ready() -> void:
	sprite_3d.texture = stack.item_data.texture

func _physics_process(delta) -> void:
	sprite_3d.rotate_y(delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.data.inventory.pick_up_stack(stack):
		queue_free()
