extends CanvasLayer

@onready var label: Label = %Label

var tut_array: Array[String] = [
	"Greetings Warrior!",
	"Try to win 5 types of opponents on this Arena. Each opponent has its own unique behavior.",
	"Move by using WASD or arrows.",
	"Attack with sword by clicking Left Mouse Button.",
	"Shoot arrows in enemies by clicking Right Mouse Button, after buying the Bow upgrade.",
	"Opponents will periodically call for reinforcements, manage to defeat them before they outnumber you!",
	"You can call next Round by hitting Fireplace in the middle of Arena.",
	"Upgrades can be purchased in the Workshop in the top right corner of Arena after round is completed.",
	"Enjoy Playing!"
]


func _ready() -> void:
	get_tree().paused = true
	next_tut()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("main action"):
		next_tut()


func next_tut():
	if tut_array.is_empty():
		get_tree().paused = false
		queue_free()
		return
	var tut = tut_array.pop_front() as String
	label.text = tut
