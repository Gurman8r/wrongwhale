# ui_title.gd
class_name UI_Title
extends PanelContainer

@onready var menu: Control = $MainMenu : set = set_menu
@onready var main: Control = $MainMenu
@onready var world_loader: Control = $WorldLoader
@onready var world_creator: Control = $WorldCreator
@onready var mod_manager: Control = $ModManager
@onready var opt_manager: Control = $OptManager

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if not visible and menu and menu.visible:
		menu.hide()
		menu = null

func set_menu(value: Control):
	if not menu and not value:
		return
	elif menu and value:
		Ref.ui.transition.play("fadeout")
		await Ref.ui.transition.finished
		menu.hide()
		menu = value
		menu.show()
		Ref.ui.transition.play("fadein")
		await Ref.ui.transition.finished
	elif menu and not value:
		menu.hide()
		menu = null
		hide()
	else: # not menu and value
		menu = value
		menu.show()
		show()
