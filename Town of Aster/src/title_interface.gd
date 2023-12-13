# title_interface.gd
class_name TitleInterface
extends Control

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

@onready var menu: Control = $TitleHome : set = set_menu
@onready var home: TitleHome = $TitleHome
@onready var world_loader: WorldLoader = $WorldLoader
@onready var world_creator: WorldCreator = $WorldCreator
@onready var mods: ModMenu = $ModMenu
@onready var settings: SettingsMenu = $SettingsMenu

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

func _init() -> void:
	mouse_filter = MOUSE_FILTER_PASS

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
		Transition.play("fadeout")
		await Transition.finished
		menu.hide()
		menu = value
		menu.show()
		Transition.play("fadein")
		await Transition.finished
	elif menu and not value:
		menu.hide()
		menu = null
		hide()
	else: # not menu and value
		menu = value
		menu.show()
		show()

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
