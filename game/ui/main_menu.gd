extends CanvasLayer

var options_scene = preload("res://game/ui/options_menu.tscn")


func _ready() -> void:
	print(MetaProgression.save_data)
	
	%PlayButton.pressed.connect(on_play_pressed)
	%UpgradesButton.pressed.connect(on_upgrades_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	get_tree().change_scene_to_file("res://game/levels/main_level/main_level.tscn")


func on_upgrades_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	get_tree().change_scene_to_file("res://game/ui/meta_menu.tscn")


func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transition_halfway
	
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_options_closed.bind(options_instance))


func on_quit_pressed():
	get_tree().quit()


func on_options_closed(options_instance: Node):
	options_instance.queue_free()
