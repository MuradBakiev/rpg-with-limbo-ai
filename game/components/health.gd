
class_name Health_manager
extends Node

signal death #emitted when health is 0
signal damaged(amount: float) #emitted when damage taken

@export var max_health: float = 10.0

var current: float

func _ready() -> void:
	current = max_health

func take_damage(amount: float):
	current = clamp(current-amount, 0, max_health)
	
	if amount > 0:
		if current <= 0.0:
			death.emit()
		else:
			damaged.emit(amount)


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current / max_health, 1)
