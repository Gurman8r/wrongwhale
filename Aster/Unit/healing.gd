# healing.gd
class_name Healing
extends Resource

@export var base_value: float

func calculate(unit: Unit) -> float:
	var result: float = base_value
	if result < 0: result = 0
	return result
