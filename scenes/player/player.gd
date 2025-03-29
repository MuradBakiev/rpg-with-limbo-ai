extends CharacterBody2D

var is_attacking: bool = false
var direction: Vector2 = Vector2.ZERO
@onready var animation_node: AnimatedSprite2D = $Root/AnimatedSprite2D

func _process(_delta: float) -> void:
	#Globals.player_pos = position
	
	if !is_attacking:
		direction = Input.get_vector("left", "right", "up", "down")
		if direction.x != 0 or direction.y != 0:
			animation_node.play("walk")
			if direction.x < 0:
				animation_node.flip_h = true
			else:
				animation_node.flip_h = false
		else:
			animation_node.play("idle")
	
	if Input.is_action_pressed("main action"):
		is_attacking = true
		direction = Vector2.ZERO
		animation_node.play("attack")
		await animation_node.animation_finished
		is_attacking = false
	
	velocity = direction * 200
	move_and_slide()
