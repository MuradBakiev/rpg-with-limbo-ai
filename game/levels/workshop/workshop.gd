extends Node2D

signal entered

@onready var warning_label: Label = %WarningLabel


func _ready() -> void:
	$UpgradeArea2D.body_entered.connect(on_body_entered)
	warning_label.visible = false
	warning_label.position = global_position + Vector2(-71, -303)


func show_warning():
	warning_label.visible = true
	var timer = get_tree().create_timer(3)
	await timer.timeout
	warning_label.visible = false


func turn_off():
	visible = false
	$StaticBody2D/CollisionPolygon2D.call_deferred("set_disabled", true)
	$UpgradeArea2D/CollisionShape2D.call_deferred("set_disabled", true)


func turn_on():
	visible = true
	$StaticBody2D/CollisionPolygon2D.call_deferred("set_disabled", false)
	$UpgradeArea2D/CollisionShape2D.call_deferred("set_disabled", false)


func on_body_entered(_body: Node2D):
	entered.emit()
