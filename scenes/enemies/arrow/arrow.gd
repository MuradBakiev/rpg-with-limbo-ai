
extends Node2D

const SPEED := 400
const DEAD_SPEED := 200

@export var dir: float = 1.0

var _is_dead: bool = false

@onready var arrow: Sprite2D = $Root/Projectile
@onready var collision_shape: CollisionShape2D = $HitBox/HitBoxCollisionShape2D
@onready var root: Node2D = $Root


func _physics_process(delta: float) -> void:
	var speed = SPEED if not _is_dead else DEAD_SPEED
	position += Vector2.RIGHT * speed * dir * delta


func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	queue_free()

func _on_hit_box_area_entered(_area: Area2D) -> void:
	_die()


func _on_delete_timer_timeout() -> void:
	queue_free()
