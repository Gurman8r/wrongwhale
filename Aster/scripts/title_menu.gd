# title_menu.gd
class_name TitleMenu
extends Control

func _on_visibility_changed() -> void:
	if not Ref.main.good2go: return
	var title: TitleInterface = Ref.ui.title_interface
	if visible:
		if title.current and title.current != self:
			title.current.hide()
		title.current = self
	else:
		if title.current == self:
			title.current = null
