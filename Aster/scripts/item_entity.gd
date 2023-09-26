# item_entity.gd
class_name ItemEntity
extends WorldObject

@export var stack: ItemStack

@onready var sprite_3d = $Sprite3D
@onready var collision_shape_3d = $CollisionShape3D

func _ready() -> void:
	sprite_3d.texture = stack.item_data.texture

func _physics_process(delta) -> void:
	sprite_3d.rotate_y(delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.data.inventory.pick_up_stack(stack):
		queue_free()

func _on_cell_visibility_changed():
	collision_shape_3d.disabled = not cell.visible
