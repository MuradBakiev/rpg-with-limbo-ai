
extends BTAction

@export var target_var: StringName = &"target"

func _tick(_delta: float) -> Status:
	var target: Node2D = blackboard.get_var(target_var)
	if not is_instance_valid(target):
		return FAILURE
	var dir: float = target.global_position.x - agent.global_position.x
	agent.velocity = Vector2.ZERO
	agent.face_dir(dir)
	return SUCCESS
