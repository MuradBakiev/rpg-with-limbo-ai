extends EntityBase

const Players_Arrow = preload("res://game/game_object/player/player's_arrow.tscn")

var direction: Vector2 = Vector2.ZERO
var base_speed = 200
var speed = 0
var base_arrow_damage


var is_attacking: bool = false
var stunned: bool = false
var can_bow: bool = false
var original_modulate: Color = Color.WHITE

@onready var hurt_animation_player: AnimationPlayer = $HurtAnimationPlayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var hit_box: Hitbox_manager = $Root/HitBox


func _ready() -> void:
	speed = base_speed
	
	health.damaged.connect(_damaged)
	health.death.connect(die)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	$HealthRegenerationTimer.timeout.connect(on_health_regeneration_timer_timeout)


func _process(_delta: float) -> void:
	if stunned:
		return
	
	if !is_attacking:
		direction = Input.get_vector("left", "right", "up", "down")
		if direction.x != 0 or direction.y != 0:
			animation_player.play("walk")
			if direction.x < 0 and $Root.scale.x > 0.0:
				$Root.scale.x = -1
			if direction.x > 0 and $Root.scale.x < 0.0:
				$Root.scale.x = 1
		else:
			animation_player.play("idle")
	
	if Input.is_action_pressed("main action"):
		is_attacking = true
		direction = Vector2.ZERO
		animation_player.play("attack1")
		await animation_player.animation_finished
		is_attacking = false
	
	if Input.is_action_pressed("support action"):
		if can_bow:
			is_attacking = true
			direction = Vector2.ZERO
			animation_player.play("attack2")
			await animation_player.animation_finished
			is_attacking = false
	
	velocity = direction * speed
	global_position = global_position.round()
	move_and_slide()


func shoot_players_arrow() -> void:
	var arrow := Players_Arrow.instantiate()
	arrow.dir = get_facing()
	get_parent().add_child(arrow)
	arrow.global_position = global_position + Vector2.RIGHT * 10.0 * get_facing()
	if GlobalData.current_upgrades.has("bow_damage"):
		var calculated_damage = arrow.hit_box.base_damage *\
		(1 + GlobalData.current_upgrades["bow_damage"]["quantity"] * 0.15)
		arrow.apply_damage(calculated_damage)


func update_health_display():
	health_bar.value = $Health.get_health_percent()


func _damaged(_amount:float):
	hurt_animation_player.play("hurt")
	GameEvents.emit_player_damaged()
	update_health_display()
	$HitRandomStreamPlayer.play_random()


func stun():
	if stunned:
		return
	stunned = true
	
	var tween := create_tween().set_loops(1)
	original_modulate = modulate
	modulate = Color(1, 0.5, 0.5)
	
	animation_player.pause()
	tween.tween_property(self, "modulate", original_modulate, 0.3)
	tween.tween_callback(func(): modulate = original_modulate)
	tween.tween_callback(func():
		stunned = false
		animation_player.play()
	)


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade.id == "player_speed":
		speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.1)
	elif ability_upgrade.id == "bow":
		can_bow = true
	elif ability_upgrade.id == "sword_damage":
		hit_box.damage = hit_box.base_damage * (1 + current_upgrades["sword_damage"]["quantity"] * 0.15)


func on_health_regeneration_timer_timeout():
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if  health_regeneration_quantity > 0:
		health.take_damage(-health_regeneration_quantity)
		update_health_display()
