
class_name Health_manager
extends Node

#emitted when health is 0
signal death

#emitted when take damage
signal damaged(amount: float)

@export var max_health: float = 10.0

var current: float

func _ready() -> void:
	current = max_health

func take_damage(amount: float):
	current -= amount
	current = max(current, 0.0)
	#print(current)
	#print(self.get_parent())
	
	if current <= 0.0:
		death.emit()
	else:
		damaged.emit(amount)
