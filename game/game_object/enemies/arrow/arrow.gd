
extends Node2D

const SPEED := 400
const DEAD_SPEED := 200

@export var dir: float = 1.0

var is_dead: bool = false

#@onready var arrow: Sprite2D = $Root/Projectile
#@onready var collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape2D
#@onready var root: Node2D = $Root
@onready var hit_box: Hitbox_manager = $HitBox


func _physics_process(delta: float) -> void:
	var speed = SPEED if not is_dead else DEAD_SPEED
	position += Vector2.RIGHT * speed * dir * delta


func die() -> void:
	if is_dead:
		return
	is_dead = true
	queue_free()


func apply_damage(amount: float):
	hit_box.damage = amount


func _on_hit_box_area_entered(_area: Area2D) -> void:
	die()


func _on_delete_timer_timeout() -> void:
	queue_free()
