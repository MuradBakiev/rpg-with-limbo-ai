extends BTAction

@export var target_pos_var := &"pos"
@export var dir_var := &"dir"
@export var speed_var: StringName = &"speed"

const TOLERANCE := 30.0
#@export var tolerance: Vector2 = Vector2(10, 10)

func _tick(_delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	var dir = blackboard.get_var(dir_var)
	var speed = blackboard.get_var(speed_var)
	
	var desired_velocity
	if agent.global_position.distance_to(target_pos) < TOLERANCE: #if we reached target with some tolerance, then set speed to 0
		desired_velocity = dir * 0
		agent.move(desired_velocity)
		return SUCCESS
	else:
		desired_velocity = dir * speed
		agent.move(desired_velocity)
		agent.update_facing()
		return RUNNING
