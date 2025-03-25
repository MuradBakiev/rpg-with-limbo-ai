extends BTAction

@export var target_pos_var := &"pos"
@export var dir_var := &"dir"

@export var speed := 100
@export var tolerance: Vector2 = Vector2(10, 10)

func _tick(_delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	var dir = blackboard.get_var(dir_var)
	
	if abs(agent.global_position - target_pos) < tolerance: #if we reached target with some tolerance, then set speed to 0
		agent.move(dir, 0) #method from enemy.gd script
		return SUCCESS
	else:
		agent.move(dir, speed)
		return RUNNING
