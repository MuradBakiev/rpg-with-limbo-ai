extends CharacterBody2D

class_name EntityBase

signal death

const Minion := "res://scenes/enemies/skeleton.tscn"
const Arrow := preload("res://scenes/enemies/arrow/arrow.tscn")

var summon_count: int = 0
var attack: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Health_manager =  $Health
@onready var root: Node2D = $Root

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func _process(_delta: float) -> void:
	#print($Root/AnimatedSprite2D.animation, $Root/AnimatedSprite2D.frame)
	#$Root/AnimatedSprite2D.advance(0)
	pass


func move(new_velocity: Vector2) -> void:
	velocity = new_velocity
	move_and_slide()


func face_dir(dir: float) -> void:
	if dir > 0.0 and root.scale.x < 0.0:
		root.scale.x = 1.0
	if dir < 0.0 and root.scale.x > 0.0:
		root.scale.x = -1.0


func update_facing() -> void:
	face_dir(velocity.x)


func get_facing() -> float:
	return signf(root.scale.x)


func is_good_position(p_position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = p_position
	params.collision_mask = 3 # Obstacle layer has value 3
	var collision := space_state.intersect_point(params)
	return collision.is_empty()


func shoot_arrow() -> void:
	var arrow := Arrow.instantiate()
	arrow.dir = get_facing()
	get_parent().add_child(arrow)
	arrow.global_position = global_position + Vector2.RIGHT * 10.0 * get_facing()


func summon_minion(p_position: Vector2) -> void:
	var minion: CharacterBody2D = load(Minion).instantiate()
	get_parent().add_child(minion)
	minion.position = p_position
	minion.z_index = 1
	summon_count += 1
	minion.death.connect(func():
		summon_count -= 1
		print("Summon count:", summon_count)
	)


func _on_notice_area_body_entered(_body: Node2D) -> void:
	var btplayer: BTPlayer = $BTPlayer
	attack = true
	btplayer.restart()

func _on_notice_area_body_exited(_body: Node2D) -> void:
	var btplayer: BTPlayer = $BTPlayer
	attack = false
	btplayer.restart()

func stop_motion():
	velocity = Vector2.ZERO

func _damaged(_amount: float):
	var btplayer: BTPlayer = $BTPlayer
	#animation_player.play("hurt")
	animation_player.set_deferred("current_animation", "hurt")
	btplayer.set_active(false)
	await animation_player.animation_finished
	btplayer.restart()

func die():
	death.emit()
	queue_free()
