extends BTAction

@export var target_var := &"target"

@export var speed_var = 100
@export var tolerance: Vector2 = Vector2(20, 20)

func _tick(_delta: float) -> Status:
	#print(blackboard.get_vars_as_dict())
	var target: CharacterBody2D = blackboard.get_var(target_var)
	if target != null:
		var target_position = target.global_position
		var dir = agent.global_position.direction_to(target_position)
		
		if abs(agent.global_position - target_position) < tolerance: #if we reached target with some tolerance, then set speed to 0
			agent.move(dir, 0) #method from enemy.gd script
			return SUCCESS
		else:
			agent.move(dir, speed_var)
			return RUNNING
		
	return FAILURE
