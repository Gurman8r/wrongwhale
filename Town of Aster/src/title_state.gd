# title_state.gd
class_name TitleState
extends State

func _ready() -> void:
	super._ready()

func _enter_state() -> void:
	super._enter_state()
	Game.main.change_state(Game.world_state)

func _exit_state() -> void:
	super._exit_state()

func _physics_process(_delta) -> void:
	pass
