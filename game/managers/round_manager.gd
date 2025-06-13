extends Node

signal round_start
signal round_finish

const Simple = preload("res://game/game_object/enemies/orc.tscn")
const Nuanced = preload("res://game/game_object/enemies/elite_orc.tscn")
const Charger = preload("res://game/game_object/enemies/orc_rider.tscn")
const Ranged = preload("res://game/game_object/enemies/skeleton_archer.tscn")
const Summoner = preload("res://game/game_object/enemies/wizard.tscn")

const WAVES: Array = [
	[Simple],
	[Simple, Simple, Simple],
	[Nuanced],
	[Simple, Nuanced, Simple, Nuanced],
	[Charger],
	[Simple, Simple, Simple, Charger, Nuanced],
	[Ranged],
	[Ranged, Nuanced, Simple, Simple],
	[Summoner],
	[Summoner, Ranged, Nuanced, Nuanced, Ranged, Simple],
]
const REINFORCEMENT: Array = [Simple, Simple]

@export var wave_index: int = -1
@export var agents_alive: int = 0
@export var trigger: Node2D
@export var spawn_points: Node2D
@export var entities_node: Node2D
@export var bridge: Node2D
@export var workshop: Node2D
@export var end_screen_scene: PackedScene

@onready var reinforcement_timer: Timer = $ReinforcementTimer


func _ready() -> void:
	trigger.triggered.connect(on_trigger_triggered)
	reinforcement_timer.timeout.connect(on_reinforcement_timer_timeout)


func on_trigger_triggered() -> void:
	start_round()


func start_round() -> void:
	round_start.emit()
	workshop.turn_off()
	reinforcement_timer.autostart = true
	reinforcement_timer.start()
	
	wave_index += 1
	if wave_index >= WAVES.size():
		print("Victory!")
		var end_screen = end_screen_scene.instantiate()
		if end_screen == null:
			return
		add_child(end_screen)
		end_screen.play_jingle()
	else:
		spawn_entities(WAVES[wave_index])


func finish_round():
	round_finish.emit()
	trigger.enabled = true
	workshop.turn_on()
	reinforcement_timer.autostart = false
	reinforcement_timer.stop()
	
	GameEvents.emit_round_finished()


func spawn_entities(entities_list: Array):
	var spawns: Array = spawn_points.get_children()
	spawns.shuffle()
	for i in entities_list.size():
		var agent_resource: PackedScene = entities_list[i]
		var agent: CharacterBody2D = agent_resource.instantiate()
		entities_node.call_deferred("add_child", agent)
		agent.global_position = spawns[i].global_position
		agent.death.connect(on_agent_death)
		agents_alive += 1


func on_agent_death() -> void:
	agents_alive -= 1
	if agents_alive == 0:
		finish_round()


func on_reinforcement_timer_timeout():
	spawn_entities(REINFORCEMENT)
