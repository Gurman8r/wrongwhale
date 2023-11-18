# ui_title.gd
class_name UI_Title
extends PanelContainer

@onready var current_menu: Control = $Main : set = set_current_menu
@onready var main: Control = $Main
@onready var loadgame: Control = $LoadGame
@onready var newgame: Control = $NewGame
@onready var options: Control = $Options
@onready var mods: Control = $Mods

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func set_current_menu(value: Control):
	if not current_menu and not value:
		return
	elif current_menu and value:
		Ref.ui.transition.play("fadeout")
		await Ref.ui.transition.finished
		current_menu.hide()
		current_menu = value
		current_menu.show()
		Ref.ui.transition.play("fadein")
		await Ref.ui.transition.finished
	elif current_menu and not value:
		current_menu.hide()
		current_menu = null
		hide()
	else: # not current_menu and value
		current_menu = value
		current_menu.show()
		show()

func _on_visibility_changed():
	if not visible and current_menu and current_menu.visible:
		current_menu.hide()
		current_menu = null
