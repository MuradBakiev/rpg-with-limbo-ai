
class_name Hitbox_manager
extends Area2D

@export var damage: float = 1.0

func _ready() -> void:
	area_entered.connect(_area_entered)
	#print(get_parent().name == "Arrow")
	#connect("area_entered", _area_entered)

func _area_entered(hurtbox: Area2D) -> void:
	if hurtbox.owner == owner or (hurtbox.owner.is_in_group("arrow_immune") and get_parent().is_in_group("projectile")):
		return
	
	if hurtbox is Hurtbox_manager:
		hurtbox.take_damage(damage)
		if get_parent().get_parent().is_in_group("stunner"):
			if hurtbox.owner.has_method("stun"):
				hurtbox.owner.stun()
