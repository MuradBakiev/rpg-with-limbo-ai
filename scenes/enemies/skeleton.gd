extends CharacterBody2D

var attack: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var btplayer: BTPlayer = $BTPlayer
@onready var health:Health_manager =  $Health

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func _process(_delta: float) -> void:
	pass

func move(dir, speed):
	velocity = dir * speed
	move_and_slide()

func update_facing():
	if velocity.x < 0:
		$Root.scale.x = -1
	else:
		$Root.scale.x = 1

func _on_notice_area_body_entered(_body: Node2D) -> void:
	attack = true
	btplayer.restart()

func _on_notice_area_body_exited(_body: Node2D) -> void:
	attack = false
	btplayer.restart()

func stop_motion():
	velocity = Vector2.ZERO

func _damaged(amount: float):
	print("sekeleton damaged")
	animation_player.play("hurt")
	btplayer.set_active(false)
	await animation_player.animation_finished
	btplayer.restart()

func die():
	queue_free()
