extends CharacterBody2D

var is_attacking: bool = false
var direction: Vector2 = Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health: Health_manager = $Health

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func _process(_delta: float) -> void:
	if !is_attacking:
		direction = Input.get_vector("left", "right", "up", "down")
		if direction.x != 0 or direction.y != 0:
			animation_player.play("walk")
			if direction.x < 0:
				$Root.scale.x = -1
			else:
				$Root.scale.x = 1
		else:
			animation_player.play("idle")
	
	if Input.is_action_pressed("main action"):
		is_attacking = true
		direction = Vector2.ZERO
		animation_player.play("attack1")
		await animation_player.animation_finished
		is_attacking = false
	
	velocity = direction * 200
	move_and_slide()

func _damaged(amount:float):
	#animation_player.play("hurt")
	#await animation_player.animation_finished
	print("player damaged")
	pass

func die():
	pass
