# title_interface.gd
class_name TitleInterface
extends PanelContainer

@onready var menu: Control = $MainMenu : set = set_menu
@onready var main_menu: Control = $MainMenu
@onready var world_loader: Control = $WorldLoader
@onready var world_creator: Control = $WorldCreator
@onready var options_menu: Control = $OptionsMenu
@onready var mod_menu: Control = $ModMenu

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
		Ref.ui.transitions.play("fadeout")
		await Ref.ui.transitions.finished
		menu.hide()
		menu = value
		menu.show()
		Ref.ui.transitions.play("fadein")
		await Ref.ui.transitions.finished
	elif menu and not value:
		menu.hide()
		menu = null
		hide()
	else: # not menu and value
		menu = value
		menu.show()
		show()
