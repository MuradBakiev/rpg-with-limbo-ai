extends CharacterBody2D

func _ready() -> void:
	velocity = Vector2.RIGHT * 200
	$AnimatedSprite2D.play("walk")

func _process(delta: float) -> void:
	move_and_slide()
