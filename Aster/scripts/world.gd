# world.gd
class_name World
extends Node3D

@export var save_data: SaveData

var cell: WorldCell : set = set_cell
var cells: Array[WorldCell]

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	Ref.world = self

func _ready():
	assert(0 < cells.size())
	cell = cells[0]
	visibility_changed.connect(_on_visibility_changed)

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func set_cell(value: WorldCell):
	if cell == value: return
	if cell: cell.hide()
	cell = value
	if cell: cell.show()

func warp(node: Node3D, world_cell: WorldCell, location: Vector3 = Vector3.ZERO) -> void:
	Ref.ui.transition.play("fadeout")
	await Ref.ui.transition.finished
	cell.remove(node)
	set_cell(world_cell)
	cell.add(node, location)
	Ref.ui.transition.play("fadein")
	await Ref.ui.transition.finished

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _on_visibility_changed():
	if visible:
		# load world here
		pass
	else:
		# unload world here
		pass
