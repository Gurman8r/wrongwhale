# damage.gd
class_name Damage
extends Resource

@export var base_value: float

func calculate(unit: Unit) -> float:
	var result: float = base_value
	if 0 < result: result = 0
	return result
