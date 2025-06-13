extends PanelContainer

signal selected

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var purchase_button: Button = %PurchaseButton
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var progress_label: Label = %ProgressLabel
@onready var count_label: Label = %CountLabel

var disabled = false
var upgrade: AbilityUpgrade


func _ready() -> void:
	purchase_button.pressed.connect(on_purchase_pressed)
	mouse_entered.connect(on_mouse_entered)
	play_in()


func play_in(delay: float = 0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")


func play_discard():
	$AnimationPlayer.play("discard")


func select_card():
	disabled = true
	GlobalData.current_gold -= upgrade.cost
	GlobalData.gold_updated.emit()
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card == self:
			continue
		other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()


func set_ability_upgrade(upgrade: AbilityUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	update_progress(upgrade)


func update_progress(upgrade: AbilityUpgrade):
	var current_quantity = 0
	if GlobalData.current_upgrades.has(upgrade.id):
		current_quantity = GlobalData.current_upgrades[upgrade.id]["quantity"]
	#var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = GlobalData.current_gold
	var percent = 1
	if upgrade.cost != 0:
		percent = currency / upgrade.cost
	percent = min(1, percent)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1
	progress_label.text = str(currency) + "/" + str(upgrade.cost)
	count_label.text = "x%d" % current_quantity


func on_purchase_pressed():
	if disabled:
		return
	select_card()


func on_mouse_entered():
	if disabled:
		return
	$HowerAnimationPlayer.play("hover")
