
extends BTAction

const TOLERANCE:= 30

@export var target_var: StringName = &"target"

@export var speed_var: StringName = &"speed"

@export var approach_distance: float = 30.0

var _waypoint: Vector2

func _enter() -> void:
	var target: Node2D = blackboard.get_var(target_var, null)
	
	if is_instance_valid(target):
		_select_new_waypoint(_get_desired_position(target))


func _tick(_delta: float) -> Status:
	var target: Node2D = blackboard.get_var(target_var, null)
	#print(blackboard.get_vars_as_dict())
	if not is_instance_valid(target) or not agent.attack:
		return FAILURE
	
	var desired_pos: Vector2 = _get_desired_position(target)
	if agent.global_position.distance_to(desired_pos) < TOLERANCE:
		return SUCCESS
	
	if agent.global_position.distance_to(_waypoint) < TOLERANCE:
		_select_new_waypoint(desired_pos)
	
	var speed: float = blackboard.get_var(speed_var, 200.0)
	var desired_velocity: Vector2 = agent.global_position.direction_to(_waypoint) * speed
	agent.move(desired_velocity)
	agent.update_facing()
	return RUNNING


func _get_desired_position(target: Node2D) -> Vector2:
	var side = signf(agent.global_position.x - target.global_position.x) #determine where our agent is located relative to the target (from left or from the right side)
	var desired_pos: Vector2 = target.global_position
	desired_pos.x += side * approach_distance
	return desired_pos


func _select_new_waypoint(desired_position: Vector2) -> void:
	var distance_vector: Vector2 = desired_position - agent.global_position
	var angle_variation: float = randf_range(-0.2, 0.2)
	_waypoint = agent.global_position + distance_vector.limit_length(150.0).rotated(angle_variation)
