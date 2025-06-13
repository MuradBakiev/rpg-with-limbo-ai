extends CanvasLayer

@onready var label: Label = $MarginContainer/HBoxContainer/Label


func _ready() -> void:
	label.text = str(GlobalData.current_gold)
	GlobalData.gold_updated.connect(on_gold_updated)


func on_gold_updated():
	label.text = str(GlobalData.current_gold)
