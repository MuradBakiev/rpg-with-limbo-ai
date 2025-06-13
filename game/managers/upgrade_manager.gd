extends Node

#@export var experience_manager: Node
@export var workshop: Node2D
@export var upgrade_screen_scene: PackedScene

var able_to_buy = true
var upgrade_pool: WeightedTable = WeightedTable.new()

var upgrade_bow = preload("res://game/resources/upgrades/bow.tres")
var upgrade_bow_damage = preload("res://game/resources/upgrades/bow_damage.tres")
var upgrade_sword_damage = preload("res://game/resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://game/resources/upgrades/player_speed.tres")


func _ready() -> void:
	upgrade_pool.add_item(upgrade_bow, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	
	workshop.entered.connect(on_workshop_entered)
	GameEvents.round_finished.connect(on_round_finished)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = GlobalData.current_upgrades.has(upgrade.id)
	if !has_upgrade:
		GlobalData.current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		GlobalData.current_upgrades[upgrade.id]["quantity"] += 1
	
	if upgrade.max_quantity > 0:
		var current_quantity = GlobalData.current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, GlobalData.current_upgrades)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_bow.id:
		upgrade_pool.add_item(upgrade_bow_damage, 10)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	able_to_buy = false


func on_workshop_entered():
	if able_to_buy:
		var upgrade_screen_instance = upgrade_screen_scene.instantiate()
		add_child(upgrade_screen_instance)
		var chosen_upgrades = pick_upgrades()
		upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
		upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	else:
		workshop.show_warning()


func on_round_finished():
	able_to_buy = true
