
class_name Hurtbox_manager
extends Area2D

@export var health: Health_manager

func take_damage(amount: float):
	health.take_damage(amount)
