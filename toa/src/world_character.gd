# world_character.gd
class_name WorldCharacter
extends CharacterBody3D

func get_cell() -> WorldCell: return get_parent().get_parent() as WorldCell
