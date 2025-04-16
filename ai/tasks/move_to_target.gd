extends BTAction

@export var target_var := &"target"

@export var speed_var = 100
@export var tolerance: float = 30.0

func _tick(_delta: float) -> Status:
	print(blackboard.get_vars_as_dict())
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		var dir = agent.global_position.direction_to(target_position)
		
		#agent.update_facing()
		if abs(agent.global_position.x - target_position.x) <= tolerance and abs(agent.global_position.y - target_position.y) <= tolerance: #if we reached target with some tolerance, then set speed to 0
			agent.update_facing()
			agent.move(dir, 0)
			return SUCCESS
		else:
			agent.move(dir, speed_var)
			agent.update_facing()
			return RUNNING
		
	return FAILURE
