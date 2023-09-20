# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# entity.gd
class_name Entity
extends Resource

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# HEALTH
@export var health: float = 100
@export var healthmax: float = 100

signal health_changed(value: float)
signal healthmax_changed(value: float)

func set_health(value: float):
	if value < 0.000001: value = 0.0
	elif healthmax < value: value = healthmax
	if health == value: return
	health = value
	health_changed.emit(health)

func set_healthmax(value: float):
	if value < health: value = health
	if healthmax == value: return
	healthmax = value
	healthmax_changed.emit(healthmax)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
