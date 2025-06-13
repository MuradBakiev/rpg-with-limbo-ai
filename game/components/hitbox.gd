
class_name Hitbox_manager
extends Area2D

@export var base_damage: float = 1.0
var damage

var floating_text_scene = preload("res://game/ui/floating_text.tscn")

func _ready() -> void:
	area_entered.connect(_area_entered)
	damage = base_damage


func _area_entered(hurtbox: Area2D) -> void:
	if hurtbox.owner == owner or (hurtbox.owner.is_in_group("arrow_immune") and\
	get_parent().is_in_group("projectile")):
		return
	
	if hurtbox is Hurtbox_manager:
		hurtbox.take_damage(damage)
		if get_parent().get_parent().is_in_group("stunner"):
			if hurtbox.owner.has_method("stun"):
				hurtbox.owner.stun()
	
	if not hurtbox.owner.is_in_group("trigger"):
		var floating_text = floating_text_scene.instantiate() as Node2D
		get_tree().get_first_node_in_group("entities_layer").add_child(floating_text)
		
		floating_text.global_position = hurtbox.global_position + (Vector2.UP * 40)
		
		var format_string = "%0.2f"
		if round(damage) == damage:
			format_string = "%0.0f"
		floating_text.start(format_string % damage)
