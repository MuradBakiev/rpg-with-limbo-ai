extends CharacterBody2D

var is_attacking: bool = false
var direction: Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	#Globals.player_pos = position
	
	if !is_attacking:
		direction = Input.get_vector("left", "right", "up", "down")
		if direction.x != 0 or direction.y != 0:
			$AnimatedSprite2D.play("walk")
			if direction.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.play("idle")
	
	if Input.is_action_pressed("main action"):
		is_attacking = true
		direction = Vector2.ZERO
		$AnimatedSprite2D.play("attack")
		await $AnimatedSprite2D.animation_finished
		is_attacking = false
	
	velocity = direction * 200
	move_and_slide()
