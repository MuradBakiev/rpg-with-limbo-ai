extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

#@export var upgrade_card_scene: PackedScene
@onready var upgrade_card_scene = preload("res://game/ui/ability_upgrade_card.tscn")
@onready var card_container: HBoxContainer = %CardContainer

func _ready() -> void:
	get_tree().paused = true
	%EscapeButton.pressed.connect(on_escape_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close()


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	var delay = 0
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		delay += 0.2


func close():
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()


func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	close()


func on_escape_button_pressed():
	close()
