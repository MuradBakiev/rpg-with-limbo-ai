extends CharacterBody2D

class_name EntityBase

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

#func move(dir, speed):
	#velocity = dir * speed
	#move_and_slide()

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


#func update_facing():
	#if velocity.x < 0:
		#$Root.scale.x = -1
	#else:
		#$Root.scale.x = 1


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
	animation_player.play("hurt")
	btplayer.set_active(false)
	await animation_player.animation_finished
	btplayer.restart()

func die():
	queue_free()
