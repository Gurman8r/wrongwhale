# title_basemenu.gd
class_name TitleBaseMenu
extends Control

func _on_visibility_changed() -> void:
	if not Ref.main.good2go: return
	var title: TitleInterface = Ref.ui.title_interface
	if visible:
		if not title.visible:
			title.show()
		if title.current and title.current != self:
			title.current.hide()
		title.current = self
	elif title.current == self:
		title.current = null
