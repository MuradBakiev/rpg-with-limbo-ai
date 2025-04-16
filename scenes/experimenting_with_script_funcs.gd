extends Node

func _ready() -> void:
	for i in range(10):
		var rand_num = randf_range(-0.2, 0.2)
		var distance_vector: Vector2 = Vector2(1000, 1000)
		print(distance_vector.limit_length(160.0).rotated(rand_num))
		#print((106**2+106**2)**(1/2))
