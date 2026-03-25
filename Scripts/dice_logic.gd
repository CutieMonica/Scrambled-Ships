extends Node3D
class_name DiceLogic


@export_group("stats")
@export var outside_the_box_multiplier : float = 1.0
@export var default_gravity : float = 3.0
@export var default_mass : float = 0.75
@export var dice_position : int = 1
@export var just_spawned : bool = false
@export var awaiting_placement : bool = false
@export var dice_being_replaced : bool = false
@onready var poof_particle: CPUParticles3D = $PoofParticle

@export_group("textures")
@export var texture : Texture2D
@export var normal : Texture2D
@export var roughness : Texture2D

@export_group("sounds")
@warning_ignore("untyped_declaration")
@export var dice_clink_sound_1 = SfxBank.dice_clink_sound_1
@warning_ignore("untyped_declaration")
@export var dice_clink_sound_2 = SfxBank.dice_clink_sound_2
@warning_ignore("untyped_declaration")
@export var dice_clink_sound_3 = SfxBank.dice_clink_sound_3
@warning_ignore("untyped_declaration")
@export var dice_wood_sound = SfxBank.coin_table_hit
@warning_ignore("untyped_declaration")
@export var dice_soft_sound_1 = SfxBank.softsound1
@warning_ignore("untyped_declaration")
@export var dice_soft_sound_2 = SfxBank.softsound2
@warning_ignore("untyped_declaration")
@export var poof_sound = SfxBank.poof_sound

@onready var storage_timer: Timer = $StorageTimer
@onready var back_to_box_timer: Timer = $BackToBoxTimer
@onready var gravity_reset_timer: Timer = $GravityResetTimer

func _ready() -> void:
	await get_tree().physics_frame
	get_parent().mesh.get_active_material(0).albedo_texture = texture
	get_parent().mesh.get_active_material(0).metallic_texture = roughness
	get_parent().mesh.get_active_material(0).roughness_texture = roughness
	get_parent().mesh.get_active_material(0).normal_texture = normal
	get_parent().highlight.get_material_override().albedo_texture = texture
	get_parent().highlight.get_material_override().metallic_texture = roughness
	get_parent().highlight.get_material_override().roughness_texture = roughness
	get_parent().highlight.get_material_override().normal_texture = normal

func adjust_number(new_pos : float) -> void:
	get_parent().dice_position = new_pos
	match get_parent().dice_position:
		1:
			get_parent().stored_pos = Vector3(-4.7, 3.5, -5.6)
		2:
			get_parent().stored_pos = Vector3(-3.25, 3.5, -5.6)
		3:
			get_parent().stored_pos = Vector3(-1.75, 3.5, -5.6)
		4:
			get_parent().stored_pos = Vector3(-0.25, 3.5, -5.6)
		5:
			get_parent().stored_pos = Vector3(1.25, 3.5, -5.6)
		6:
			get_parent().stored_pos = Vector3(2.75, 3.5, -5.6)
		7:
			get_parent().stored_pos = Vector3(4.25, 3.5, -5.6)
			
func sealed_away_forever() -> void:
	get_parent().gravity_scale = 1
	get_parent().set_collision_mask_value(1, false)
	get_parent().set_collision_layer_value(1, false)
	get_parent().storing = true
	get_parent().get_parent().stored_dice.set(get_parent().dice_position, "true")
	storage_timer.start()
	

func start_recall() -> void:
	if !get_parent().stored:
		if get_parent().outside_the_box and get_parent().get_parent().score_sheet.dice_giving_temp_modifier.get(dice_position) == true:
			match get_parent().outside_the_box_multiplier_given_to_top_row:
				0:
					pass
				1:
					get_parent().get_parent().score_sheet.ones_multiplier -= outside_the_box_multiplier
				2:
					get_parent().get_parent().score_sheet.twos_multiplier -= outside_the_box_multiplier
				3:
					get_parent().get_parent().score_sheet.threes_multiplier -= outside_the_box_multiplier
				4:
					get_parent().get_parent().score_sheet.fours_multiplier -= outside_the_box_multiplier
				5:
					get_parent().get_parent().score_sheet.fives_multiplier -= outside_the_box_multiplier
				6:
					get_parent().get_parent().score_sheet.sixes_multiplier -= outside_the_box_multiplier
		get_parent().outside_the_box_multiplier_given_to_top_row = 0
		get_parent().get_parent().score_sheet.dice_giving_temp_modifier.set(dice_position, false)
		get_parent().get_parent().score_sheet.modifier_check()
		get_parent().get_parent().score_sheet.update_multipliers()
		get_parent().set_collision_mask_value(1, false)
		get_parent().recalling = true
		get_parent().dropping = false
		get_parent().shaking = false
		get_parent().outside_the_box = false

func drop() -> void:
	if get_parent().recalling == true:
		get_parent().set_collision_mask_value(1, true)
		get_parent().recalling = false
		get_parent().dropping = true
		get_parent().shaking = false

func shake() -> void:
	if !get_parent().stored:
		var rotating_x : float
		var rotating_y : float
		var rotating_z : float
		rotating_x = GameManager.rng.randf_range(0, 4)
		rotating_y = GameManager.rng.randf_range(0, 4)
		rotating_z = GameManager.rng.randf_range(0, 4)
		get_parent().rigid_body_3d.rotate_x(rotating_x * 90)
		get_parent().rigid_body_3d.rotate_y(rotating_y * 90)
		get_parent().rigid_body_3d.rotate_z(rotating_z * 90)
		get_parent().recalling = false
		get_parent().dropping = false
		get_parent().shaking = true
		
func return_to_box() -> void:
	get_parent().gravity_scale = 1
	get_parent().set_collision_mask_value(1, false)
	get_parent().set_collision_layer_value(1, false)
	get_parent().returning_to_box = true
	get_parent().stored = false
	get_parent().add_to_group("dice")
	get_parent().remove_from_group("stored_dice")
	get_parent().get_parent().stored_dice.set(get_parent().dice_position, "false")
	back_to_box_timer.start()

func throw() -> void:
	#linear_velocity = Vector3(0, -100, 0)
	#gravity_scale = 4.0
	get_parent().recalling = false
	get_parent().dropping = false
	get_parent().shaking = false
	InputHandler.current_reroll_state = 0
	if !get_parent().stored:
		get_parent().has_given_number = false
	gravity_reset_timer.start()
	
	
func update_ui() -> void:
	GameManager.update_dice_numbers(get_parent().dice_position, get_parent().number)
	get_parent().get_parent().current_dice_paper.update_dice_numbers(get_parent().dice_position, get_parent().number)

func _physics_process(delta: float) -> void:
		
	if get_parent().linear_velocity.length() > 0.1 and !get_parent().storing:
		get_parent().has_given_number = false
		
	if get_parent().recalling:
		get_parent().returning_to_box = false
		get_parent().stored = false
		get_parent().has_given_number = true
		get_parent().linear_velocity = Vector3.ZERO
		if !get_parent().outside_the_box:
			get_parent().position = lerp(get_parent().position, Vector3(11.5, 9 + (get_parent().dice_position * 1.5), -8.8), delta * 5)
		if get_parent().outside_the_box:
			get_parent().get_parent().score_sheet.dice_giving_temp_modifier.set(dice_position, true)
			get_parent().get_parent().score_sheet.modifier_check()
			get_parent().position = lerp(get_parent().position, Vector3(11.5, 9 + (get_parent().dice_position * 1.5), -8.8), delta * 20)
			get_parent().outside_the_box = false
			
	if get_parent().dropping:
		get_parent().has_given_number = true
		
	if get_parent().stored:
		get_parent().has_given_number = true
		
	if get_parent().shaking:
		get_parent().has_given_number = true
		
	if get_parent().returning_to_box and !get_parent().recalling:
		get_parent().position = lerp(get_parent().position, Vector3(get_parent().dice_position * 0.5, 2, 0), delta)
		
	if get_parent().focused == true and !get_parent().outside_the_box and get_parent().linear_velocity.length() < 0.1 and InputHandler.hovered_object != "scoresheet" and !just_spawned and get_tree().get_first_node_in_group("main").between_rounds == false and get_parent().has_given_number:
		focusdie()
		
func focusdie() -> void:
	if dice_being_replaced:
		return
	get_parent().focused = true
	if !get_parent().outside_the_box and get_parent().linear_velocity.length() < 0.1 and InputHandler.hovered_object != "scoresheet" and !just_spawned and get_tree().get_first_node_in_group("main").between_rounds == false and get_parent().has_given_number:
		get_parent().animation_player.play("highlighted")
		print("sus")
		InputHandler.hovered_object = "dice" + str(get_parent().dice_position)
		print(InputHandler.hovered_object)
	if get_parent().get_parent().choosing_new_die == true:
		get_parent().animation_player.play("highlighted")
		InputHandler.hovered_object = "dice" + str(get_parent().dice_position)
	else:
		pass

func losefocusdie() -> void:
	if dice_being_replaced:
		return
	if get_parent().focused:
		get_parent().animation_player.play("not_highlighted")
		print("gups")
		get_parent().focused = false
		if InputHandler.hovered_object == "dice" + str(get_parent().dice_position):
			InputHandler.hovered_object = "none"
		
func interacted() -> void:
	if dice_being_replaced:
		return
	get_parent().leftclickinteraction()
	
func storage() -> void:
	if dice_being_replaced:
		return
	if get_parent().focused and !get_parent().storing and !get_parent().stored and get_parent().linear_velocity.length() < 1 and !get_parent().outside_the_box:
		sealed_away_forever()
		get_parent().add_to_group("stored_dice")
		get_parent().remove_from_group("dice")
		losefocusdie()
	if get_parent().focused and get_parent().stored and get_parent().linear_velocity.length() < 1:
		return_to_box()
		losefocusdie()

func end_of_round_reset() -> void:
	sealed_away_forever()
	get_parent().add_to_group("stored_dice")
	get_parent().remove_from_group("dice")

func _on_storage_timer_timeout() -> void:
	get_parent().storing = false
	get_parent().set_collision_mask_value(1, true)
	get_parent().set_collision_layer_value(1, true)
	get_parent().gravity_scale = default_gravity
	get_parent().stored = true


func _on_back_to_box_timer_timeout() -> void:
	get_parent().returning_to_box = false
	get_parent().stored = false
	get_parent().gravity_scale = default_gravity
	get_parent().set_collision_mask_value(1, true)
	get_parent().set_collision_layer_value(1, true)
	


func _on_gravity_reset_timer_timeout() -> void:
	get_parent().gravity_scale = default_gravity

func play_wood_sound() -> void:
	get_parent().audio_stream_player_3d.stream = dice_wood_sound
	get_parent().audio_stream_player_3d.volume_db = (-9 + randf_range(-1, 3))
	get_parent().audio_stream_player_3d.pitch_scale = (0 + randf_range(0.8, 2))
	get_parent().audio_stream_player_3d.play()

func play_soft_sound() -> void:
	var random_noise : int = 0
	random_noise = randi_range(1, 2)
	if random_noise == 1:
		get_parent().audio_stream_player_3d.stream = dice_soft_sound_1
	if random_noise == 2:
		get_parent().audio_stream_player_3d.stream = dice_soft_sound_2
	get_parent().audio_stream_player_3d.volume_db = (-10 + randf_range(-2, 2))
	get_parent().audio_stream_player_3d.pitch_scale = (0 + randf_range(0.8, 1.3))
	get_parent().audio_stream_player_3d.play()

func purchase_die() -> void:
	var target_slot : int = get_tree().get_first_node_in_group("main").find_vacant_dice_slot()
	get_parent().reparent(get_tree().get_first_node_in_group("main"))
	if target_slot != 0:
		adjust_number(target_slot)
		get_parent().get_parent().chosen_dice.set(target_slot, get_parent().name)
		get_parent().get_parent().in_play_dice_instances.set(target_slot, get_parent())
		dice_position = target_slot
		just_spawned = false
		get_parent().get_parent().shop_to_dice_storage()
		await get_tree().create_timer(0.75).timeout
		get_parent().global_position = Vector3.ZERO
		get_parent().rotation = Vector3.ZERO
		get_parent().freeze = false
		end_of_round_reset()
		remove_from_group("awaiting_new_slot")
		GameManager.dice_amount += 1
		await get_tree().create_timer(1.5).timeout
		get_parent().get_parent().dice_storage_to_shop()
		return
	if target_slot == 0:
		add_to_group("awaiting_new_slot")
		get_parent().get_parent().shop_to_dice_storage()
		get_parent().get_parent().choosing_new_die = true
	
func replaced() -> void:
	poof_particle.emitting = true
	get_parent().audio_stream_player_3d.stream = poof_sound
	get_parent().audio_stream_player_3d.volume_db = (-8 + randf_range(2, 3))
	get_parent().audio_stream_player_3d.pitch_scale = (0 + randf_range(0.9, 1.2))
	get_parent().audio_stream_player_3d.play()
	get_parent().get_parent().choosing_new_die = false
	await get_tree().create_timer(0.05).timeout
	get_parent().mesh.visible = false
	get_parent()._on_d_6_mouse_detect_mouse_exited()
	dice_being_replaced = true
	await get_tree().create_timer(0.45).timeout
	var temp_dice_position_buffer : int = get_parent().dice_position
	get_parent().get_parent().remove_dice(get_parent().dice_position)
	get_tree().get_first_node_in_group("awaiting_new_slot").go_to_new_slot(temp_dice_position_buffer)
	get_parent().queue_free()
	
func go_to_new_slot(slot : int) -> void:
	adjust_number(slot)
	get_parent().get_parent().chosen_dice.set(slot, get_parent().name)
	get_parent().get_parent().in_play_dice_instances.set(slot, get_parent())
	dice_position = slot
	
	just_spawned = false
	get_parent().global_position = Vector3.ZERO
	get_parent().rotation = Vector3.ZERO
	get_parent().freeze = false
	end_of_round_reset()
	remove_from_group("awaiting_new_slot")
	GameManager.dice_amount += 1
	await get_tree().create_timer(0.9).timeout
	get_parent().get_parent().dice_storage_to_shop()

func explosion() -> void:
	get_parent().linear_velocity.y = GameManager.rng.randf_range(15, 20)
	get_parent().linear_velocity.x = get_parent().position.x * GameManager.rng.randf_range(20, 22)
	get_parent().linear_velocity.z = get_parent().position.z * GameManager.rng.randf_range(20, 22)
	get_parent().rigid_body_3d.rotate_x(GameManager.rng.randf_range(-360, 360))
	get_parent().rigid_body_3d.rotate_y(GameManager.rng.randf_range(-360, 360))
	get_parent().rigid_body_3d.rotate_z(GameManager.rng.randf_range(-360, 360))
