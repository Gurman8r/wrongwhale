# item_entity.gd
class_name ItemEntity
extends WorldEntity

const CATEGORY := "Item"

@export var stack: ItemStack

@onready var area     : Area3D           = $Area
@onready var collider : CollisionShape3D = $Collider
@onready var sprite   : Sprite3D         = $Sprite

func _ready() -> void:
	sprite.texture = stack.item_data.texture
	
	area.body_entered.connect(func(body: Node3D):
		if body.data.inventory_data.pick_up_stack(stack):
			queue_free())

func _physics_process(delta) -> void:
	sprite.rotate_y(delta)
