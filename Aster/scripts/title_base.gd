# title_base.gd
class_name TitleBase
extends Control

func make_current():
	Ref.ui.title.current = self
