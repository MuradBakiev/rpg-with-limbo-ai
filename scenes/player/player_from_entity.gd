extends EntityBase

const Players_Arrow = preload("res://scenes/player/player's_arrow.tscn")

var is_attacking: bool = false
var direction: Vector2 = Vector2.ZERO

var stunned: bool = false
var original_modulate: Color = Color.WHITE

@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer

func _ready() -> void:
	health.damaged.connect(_damaged)
	health.death.connect(die)

func _process(_delta: float) -> void:
	if stunned:
		return
	
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

func stun():
	if stunned:
		return
	stunned = true

	# Визуальный эффект — покраснение и дрожание
	var tween := create_tween().set_loops(1)
	original_modulate = modulate
	modulate = Color(1, 0.5, 0.5)
	
	#print("stunned")
	#tween.tween_property(self, "position:x", position.x + 5, 0.05).as_relative()
	animation_player.pause()
	tween.tween_property(self, "modulate", original_modulate, 0.3)
	tween.tween_callback(func(): modulate = original_modulate)
	tween.tween_callback(func():
		stunned = false
		animation_player.play()
	)
