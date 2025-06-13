extends Node2D

var closed = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	#$OpenCloseTimer.timeout.connect(on_timer_timeout)
	pass


func open():
	animation_player.play_backwards("bridge_default")


func close():
	animation_player.play("bridge_default")


func on_timer_timeout():
	if closed:
		open()
	else:
		close()
	closed = not closed
