# world_screen.gd
class_name WorldScreen
extends State

func _ready() -> void:
	set_physics_process(false)

func _enter_state() -> void:
	super._enter_state()
	set_physics_process(true)

func _exit_state() -> void:
	super._exit_state()
	set_physics_process(false)

func _physics_process(_delta) -> void:
	pass