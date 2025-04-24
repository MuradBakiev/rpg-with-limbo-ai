
@tool
extends BTAction

@export var speed_var: StringName = &"speed"
@export var duration: float = 0.1


func _generate_name() -> String:
	return "MoveForward  speed: %s  duration: %ss" % [
		LimboUtility.decorate_var(speed_var),
		duration]


func _tick(_delta: float) -> Status:
	if not agent.attack:
		return FAILURE
	var facing = agent.get_facing()
	var speed = blackboard.get_var(speed_var)
	var desired_velocity: Vector2 = Vector2.RIGHT * facing * speed
	agent.move(desired_velocity)
	agent.update_facing()
	if elapsed_time > duration:
		return SUCCESS
	return RUNNING
