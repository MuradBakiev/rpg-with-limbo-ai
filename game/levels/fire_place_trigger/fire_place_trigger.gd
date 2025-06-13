extends Node2D

signal triggered

var enabled = true


func _ready() -> void:
	$Health.damaged.connect(on_health_damaged)


func on_health_damaged(_amount: float) -> void:
	if not enabled:
		return
	triggered.emit()
	enabled = false
