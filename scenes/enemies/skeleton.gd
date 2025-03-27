extends CharacterBody2D

var attack: bool = false
@onready var btplayer: BTPlayer = $BTPlayer

func _process(_delta: float) -> void:
	#var direction = (Globals.player_pos - position).normalized()
	#if position.x > Globals.player_pos.x:
		#$AnimatedSprite2D.flip_h = true
	#else:
		#$AnimatedSprite2D.flip_h = false
	
	#velocity = direction * speed
	pass

func move(dir, speed):
	velocity = dir * speed
	move_and_slide()

func update_facing():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func _on_notice_area_body_entered(_body: Node2D) -> void:
	attack = true
	btplayer.restart()

func _on_notice_area_body_exited(_body: Node2D) -> void:
	attack = false
	btplayer.restart()

func stop_motion():
	velocity = Vector2.ZERO

func die():
	queue_free()
