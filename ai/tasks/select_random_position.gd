
@tool
extends BTAction

@export var range_min: float = 300.0
@export var range_max: float = 400.0
@export var position_var: StringName = &"pos"


func _generate_name() -> String:
	return "SelectRandomPosition  range: [%s, %s]  ➜%s" % [
		range_min, range_max,
		LimboUtility.decorate_var(position_var)]


func _tick(_delta: float) -> Status:
	var pos: Vector2
	var is_good_position: bool
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	while not is_good_position:
		random_direction = random_direction.rotated(deg_to_rad(90))
		var rand_distance: float = randf_range(range_min, range_max)
		pos = agent.global_position + random_direction * rand_distance
		is_good_position = agent.is_good_position(pos)
	blackboard.set_var(position_var, pos)
	return SUCCESS
