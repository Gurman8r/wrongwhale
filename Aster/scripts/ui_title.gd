# ui_title.gd
class_name UI_Title
extends PanelContainer

@onready var current: Control = $MainMenu : set = set_current
@onready var mainmenu: UI_TitleMainMenu = $MainMenu
@onready var loadmenu: UI_TitleLoadMenu = $LoadMenu
@onready var newmenu: UI_TitleNewMenu = $NewMenu
@onready var optionmenu: UI_TitleOptionMenu = $OptionMenu
@onready var modmenu: UI_TitleModMenu = $ModMenu

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
