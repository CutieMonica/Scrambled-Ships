extends Node3D
class_name DiceLogic


@export var outside_the_box_multiplier : float = 1.0

@export var default_gravity : float = 3.0
@export var default_mass : float = 0.75
@export var dice_position : int = 1

@export var texture : Texture2D
@export var normal : Texture2D
@export var roughness : Texture2D

@export var dice_clink_sound_1 = preload("res://Assets/SFX/diceclink1.ogg")
@export var dice_clink_sound_2 = preload("res://Assets/SFX/diceclink2.ogg")
@export var dice_clink_sound_3 = preload("res://Assets/SFX/diceclink3.ogg")

func _ready() -> void:
	await get_tree().create_timer(0.001).timeout
	get_parent().mesh.get_active_material(0).albedo_texture = texture
	get_parent().mesh.get_active_material(0).metallic_texture = roughness
	get_parent().mesh.get_active_material(0).roughness_texture = roughness
	get_parent().mesh.get_active_material(0).normal_texture = normal
	get_parent().highlight.get_material_override().albedo_texture = texture
	get_parent().highlight.get_material_override().metallic_texture = roughness
	get_parent().highlight.get_material_override().roughness_texture = roughness
	get_parent().highlight.get_material_override().normal_texture = normal

func adjust_number(new_pos):
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
			
func sealed_away_forever():
	get_parent().gravity_scale = 1
	get_parent().set_collision_mask_value(1, false)
	get_parent().set_collision_layer_value(1, false)
	get_parent().storing = true
	get_parent().get_parent().stored_dice.set(dice_position, "true")
	await get_tree().create_timer(0.8).timeout
	get_parent().storing = false
	get_parent().set_collision_mask_value(1, true)
	get_parent().set_collision_layer_value(1, true)
	get_parent().gravity_scale = default_gravity
	get_parent().stored = true

func start_recall():
	if !get_parent().stored:
		if get_parent().outside_the_box:
			match get_parent().outside_the_box_multiplier_given_to_top_row:
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
		get_parent().get_parent().score_sheet.update_multipliers()
		get_parent().set_collision_mask_value(1, false)
		get_parent().recalling = true
		get_parent().dropping = false
		get_parent().shaking = false

func drop():
	if get_parent().recalling == true:
		get_parent().set_collision_mask_value(1, true)
		get_parent().recalling = false
		get_parent().dropping = true
		get_parent().shaking = false

func shake():
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
		
func return_to_box():
	get_parent().gravity_scale = 1
	get_parent().set_collision_mask_value(1, false)
	get_parent().set_collision_layer_value(1, false)
	get_parent().returning_to_box = true
	get_parent().get_parent().stored_dice.set(dice_position, "false")
	await get_tree().create_timer(0.3).timeout
	get_parent().returning_to_box = false
	get_parent().stored = false
	get_parent().gravity_scale = default_gravity
	get_parent().set_collision_mask_value(1, true)
	get_parent().set_collision_layer_value(1, true)
	get_parent().add_to_group("dice")
	get_parent().remove_from_group("stored_dice")

func throw():
	#linear_velocity = Vector3(0, -100, 0)
	#gravity_scale = 4.0
	get_parent().recalling = false
	get_parent().dropping = false
	get_parent().shaking = false
	get_parent().get_parent().current_state = 0
	if !get_parent().stored:
		get_parent().has_given_number = false
	await get_tree().create_timer(0.3).timeout
	get_parent().gravity_scale = default_gravity
	
func update_ui():
	GameManager.update_dice_numbers(get_parent().dice_position, get_parent().number)
	get_parent().get_parent().current_dice_paper.update_dice_numbers(get_parent().dice_position, get_parent().number)

func _physics_process(delta: float) -> void:
		
	if !get_parent().rigid_body_3d.sleeping and !get_parent().storing:
		get_parent().has_given_number = false
		
	if get_parent().recalling:
		get_parent().has_given_number = true
		get_parent().linear_velocity = Vector3.ZERO
		if !get_parent().outside_the_box:
			get_parent().position = lerp(get_parent().position, Vector3(11.5, 9 + (get_parent().dice_position * 1.5), -8.8), delta * 5)
		if get_parent().outside_the_box:
			get_parent().get_parent().score_sheet.has_temp_modifier = false
			get_parent().position = lerp(get_parent().position, Vector3(11.5, 9 + (get_parent().dice_position * 1.5), -8.8), delta * 20)
			get_parent().outside_the_box = false
			
	if get_parent().dropping:
		get_parent().has_given_number = true
		
	if get_parent().stored:
		get_parent().has_given_number = true
		
	if get_parent().shaking:
		get_parent().has_given_number = true
		
	if get_parent().returning_to_box:
		get_parent().position = lerp(get_parent().position, Vector3(get_parent().dice_position * 0.5, 2, 0), delta)
		
func focusdie():
	if !get_parent().outside_the_box and get_parent().rigid_body_3d.sleeping and get_parent().get_parent().input_handler.hovered_object != "scoresheet":
		get_parent().animation_player.play("highlighted")
		get_parent().focused = true
		print("sus")
		get_parent().get_parent().input_handler.hovered_object = "dice" + str(get_parent().dice_position)
		print(get_parent().get_parent().input_handler.hovered_object)
	else:
		pass

func losefocusdie():
	get_parent().animation_player.play("not_highlighted")
	print("gups")
	get_parent().focused = false
	if get_parent().get_parent().input_handler.hovered_object == "dice" + str(get_parent().dice_position):
		get_parent().get_parent().input_handler.hovered_object = "none"
		
func interacted():
	get_parent().leftclickinteraction()
	
func storage():
	if get_parent().focused and !get_parent().storing and !get_parent().stored and get_parent().rigid_body_3d.sleeping and !get_parent().outside_the_box:
		sealed_away_forever()
		get_parent().add_to_group("stored_dice")
		get_parent().remove_from_group("dice")
		losefocusdie()
	if get_parent().focused and get_parent().stored and get_parent().rigid_body_3d.sleeping:
		return_to_box()
		losefocusdie()
