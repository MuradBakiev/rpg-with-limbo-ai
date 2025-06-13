extends CanvasLayer

@onready var panel_container: PanelContainer = %PanelContainer


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	panel_container.scale = Vector2.ZERO
	var tween = create_tween()
	#somewhere here some code is changing scale to Vector2.ONE, so no interpolation is happening
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0) #needed to fix interpolation
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"
	play_jingle(true)


func play_jingle(defeat: bool = false):
	if defeat:
		$DefeatStreamPlayer.play()
	else:
		$VictoryStreamPlayer.play()


func on_restart_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game/levels/main_level/main_level.tscn")


func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://game/ui/main_menu.tscn")
