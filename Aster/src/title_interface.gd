# title_interface.gd
class_name TitleInterface
extends Control

@onready var current_menu: Control = $TitleMain : set = set_current_menu
@onready var main: Control = $TitleMain
@onready var world_loader: Control = $WorldLoader
@onready var world_creator: Control = $WorldCreator
@onready var options: Control = $OptionMenu
@onready var mods: Control = $ModMenu
@onready var credits: Control = $CreditsMenu

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if not visible and current_menu and current_menu.visible:
		current_menu.hide()
		current_menu = null

func set_current_menu(value: Control):
	if not current_menu and not value:
		return
	elif current_menu and value:
		Ref.ui.transitions.play("fadeout")
		await Ref.ui.transitions.finished
		current_menu.hide()
		current_menu = value
		current_menu.show()
		Ref.ui.transitions.play("fadein")
		await Ref.ui.transitions.finished
	elif current_menu and not value:
		current_menu.hide()
		current_menu = null
		hide()
	else: # not current_menu and value
		current_menu = value
		current_menu.show()
		show()
