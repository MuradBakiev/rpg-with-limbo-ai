extends Node

@export_range(0, 1) var drop_percent: float = 0.5
@export var health_component: Node
@export var gold_coin_scene: PackedScene

func _ready() -> void:
	(health_component as Node).death.connect(on_death)


func on_death():
	var adjusted_drop_percent = drop_percent
	var experience_gain_upgrade_count = MetaProgression.get_upgrade_count("experience_gain")
	if experience_gain_upgrade_count > 0:
		adjusted_drop_percent += 1 * experience_gain_upgrade_count
	
	if randf() > adjusted_drop_percent:
		return
	
	if gold_coin_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_position = (owner as Node2D).global_position
	var gold_coin_instance = gold_coin_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.call_deferred("add_child", gold_coin_instance)
	gold_coin_instance.global_position = spawn_position
