# ui_title.gd
class_name UI_Title
extends PanelContainer

@onready var current: Control = $Main : set = set_current
@onready var main: Control = $Main
@onready var loadgame: Control = $LoadGame
@onready var newgame: Control = $NewGame
@onready var options: Control = $Options
@onready var mods: Control = $Mods

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func set_current(value: Control):
	if not current and not value:
		return
	elif current and value:
		Ref.ui.transition.play("fadeout")
		await Ref.ui.transition.finished
		current.hide()
		current = value
		current.show()
		Ref.ui.transition.play("fadein")
		await Ref.ui.transition.finished
	elif current and not value:
		current.hide()
		current = null
		hide()
	else: # not current and value
		current = value
		current.show()
		show()

func _on_visibility_changed():
	if not visible and current and current.visible:
		current.hide()
		current = null
