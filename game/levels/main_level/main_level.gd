extends Node2D

@export var end_screen: PackedScene

var pause_menu_scene = preload("res://game/ui/pause_menu.tscn")

#var enemy_scenes = [
	#preload("res://game/game_object/enemies/orc.tscn"),
	#preload("res://game/game_object/enemies/skeleton_archer.tscn"),
	#preload("res://game/game_object/enemies/orc_rider.tscn"),
	#preload("res://game/game_object/enemies/elite_orc.tscn"),
	#preload("res://game/game_object/enemies/wizard.tscn")
#]

@onready var enemies_container = $Entities


func _ready() -> void:
	%Player.health.death.connect(on_player_death)


#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed:
		#match event.keycode:
			#KEY_1:
				#summon_enemy(0)
			#KEY_2:
				#summon_enemy(1)
			#KEY_3:
				#summon_enemy(2)
			#KEY_4:
				#summon_enemy(3)
			#KEY_5:
				#summon_enemy(4)
			#KEY_R:
				#remove_all_enemies()


#func summon_enemy(index: int) -> void:
	#if 0 <= index and index < enemy_scenes.size():
		#var enemy = enemy_scenes[index].instantiate()
		#enemy.position = get_global_mouse_position()
		#enemies_container.add_child(enemy)


#func remove_all_enemies() -> void:
	#for enemy in enemies_container.get_children():
		#enemy.queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled() #stopping search in input map


func on_player_death():
	var end_screen_instance = end_screen.instantiate()
	add_child(end_screen_instance)
	end_screen_instance.set_defeat()
	
	MetaProgression.save()
