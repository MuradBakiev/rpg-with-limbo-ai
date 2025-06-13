extends CanvasLayer

@export var round_manager: Node
@onready var label = %Label


func _ready() -> void:
	visible = false
	round_manager.round_start.connect(on_round_start)
	round_manager.round_finish.connect(on_round_finish)


func _process(_delta: float) -> void:
	if round_manager == null:
		return
	var time_left = round_manager.reinforcement_timer.time_left
	label.text = "Reinforcements will arrive in\n" + format_seconds_to_string(time_left)


func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60)
	var remaining_seconds = floor(seconds - (minutes * 60))
	return str(minutes, ":", ("%02d" % remaining_seconds))


func on_round_start():
	visible = true


func on_round_finish():
	visible = false
