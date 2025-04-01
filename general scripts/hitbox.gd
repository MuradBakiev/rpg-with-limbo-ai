
class_name Hitbox_manager
extends Area2D

@export var damage: float = 1.0

func _ready() -> void:
	area_entered.connect(_area_entered)
	#connect("area_entered", _area_entered)

func _area_entered(hurtbox: Area2D) -> void:
	if hurtbox.owner == owner:
		return
	if hurtbox is Hurtbox_manager:
		#print(get_children().front().disabled)
		hurtbox.take_damage(damage)
		#print(hurtbox.owner)
		#print(owner)
