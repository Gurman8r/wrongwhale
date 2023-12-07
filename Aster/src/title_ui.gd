# title_ui.gd
class_name TitleUI
extends Control

@onready var current: Control = $Interface/TitleHome : set = set_current
@onready var home: Control = $Interface/TitleHome
@onready var world_loader = $Interface/WorldLoader
@onready var world_creator = $Interface/WorldCreator
@onready var option_menu = $Interface/OptionMenu
@onready var mod_menu = $Interface/ModMenu
@onready var credits_menu = $Interface/CreditsMenu

func _init() -> void:
	assert(Game.title_ui == null)
	Game.title_ui = self

func _ready():
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if not visible and current and current.visible:
		current.hide()
		current = null

func set_current(value: Control):
	if not current and not value:
		return
	elif current and value:
		Game.transitions_ui.play("fadeout")
		await Game.transitions_ui.finished
		current.hide()
		current = value
		current.show()
		Game.transitions_ui.play("fadein")
		await Game.transitions_ui.finished
	elif current and not value:
		current.hide()
		current = null
		hide()
	else: # not current and value
		current = value
		current.show()
		show()
