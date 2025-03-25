extends BTAction

@export var range_min_in_dir: int = 40
@export var range_max_in_dir: int = 100

@export var position_var: StringName = &"pos"
@export var direction_var: StringName = &"dir"

func _tick(_delta: float) -> Status:
	var pos: Vector2
	var dir = rand_dir()
	
	pos = rand_pos(dir)
	blackboard.set_var(position_var, pos)
	
	#print(blackboard.get_vars_as_dict())
	return SUCCESS

func rand_dir():
	var dir: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	blackboard.set_var(direction_var, dir)
	return dir

func rand_pos(dir):
	var vector: Vector2
	var distance = randi_range(range_min_in_dir, range_max_in_dir) * dir
	var final_position = (distance + agent.global_position)
	vector = final_position
	return vector
