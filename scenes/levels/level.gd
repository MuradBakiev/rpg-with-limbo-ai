extends Node2D

var enemy_scenes = [
	preload("res://scenes/enemies/orc.tscn"),
	preload("res://scenes/enemies/skeleton_archer.tscn"),
	preload("res://scenes/enemies/orc_rider.tscn"),
	preload("res://scenes/enemies/elite_orc.tscn"),
	preload("res://scenes/enemies/wizard.tscn")
]

#var summoned_enemies: Array[CharacterBody2D] = []
@onready var enemies_container = $Enemies

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				summon_enemy(0)
			KEY_2:
				summon_enemy(1)
			KEY_3:
				summon_enemy(2)
			KEY_4:
				summon_enemy(3)
			KEY_5:
				summon_enemy(4)
			KEY_R:
				remove_all_enemies()


func summon_enemy(index: int) -> void:
	if 0 <= index and index < enemy_scenes.size():
		var enemy = enemy_scenes[index].instantiate()
		enemy.position = get_global_mouse_position()
		enemies_container.add_child(enemy)
		#add_child(enemy)


#func remove_all_enemies() -> void:
	#for enemy in summoned_enemies:
		#if is_instance_valid(enemy):
			#queue_free()
	#summoned_enemies.clear()


func remove_all_enemies() -> void:
	for enemy in enemies_container.get_children():
		enemy.queue_free()
