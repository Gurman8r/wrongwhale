# title.gd
# Title
extends Node

# ui
var interface: TitleInterface

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _ready() -> void:
	interface = Utility.make(self, TitleInterface.PREFAB, "Interface")
	reset()

func reset() -> void:
	pass
