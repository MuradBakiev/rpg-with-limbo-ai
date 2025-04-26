extends EntityBase

const Players_Arrow = preload("res://scenes/player/player's_arrow.tscn")

var is_attacking: bool = false
var direction: Vector2 = Vector2.ZERO

@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func _process(_delta: float) -> void:
	if !is_attacking:
		direction = Input.get_vector("left", "right", "up", "down")
		if direction.x != 0 or direction.y != 0:
			animation_player.play("walk")
			if direction.x < 0 and $Root.scale.x > 0.0:
				$Root.scale.x = -1
			if direction.x > 0 and $Root.scale.x < 0.0:
				$Root.scale.x = 1
		else:
			animation_player.play("idle")
	
	if Input.is_action_pressed("main action"):
		is_attacking = true
		direction = Vector2.ZERO
		animation_player.play("attack1")
		await animation_player.animation_finished
		is_attacking = false
	
	if Input.is_action_pressed("support action"):
		is_attacking = true
		direction = Vector2.ZERO
		animation_player.play("attack2")
		await animation_player.animation_finished
		is_attacking = false
	
	velocity = direction * 200
	move_and_slide()


func shoot_players_arrow() -> void:
	var arrow := Players_Arrow.instantiate()
	arrow.dir = get_facing()
	get_parent().add_child(arrow)
	arrow.global_position = global_position + Vector2.RIGHT * 10.0 * get_facing()


func _damaged(_amount:float):
	hurt_animation_player.play("hurt")

func die():
	pass
