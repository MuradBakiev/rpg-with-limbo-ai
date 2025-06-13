extends Node

signal gold_updated()

var current_gold = 0
var current_upgrades = {}


func _ready() -> void:
	GameEvents.gold_coin_collected.connect(on_gold_coin_collected)


func on_gold_coin_collected(number: float):
	current_gold += number
	gold_updated.emit()
