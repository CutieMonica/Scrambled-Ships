extends RigidBody3D

class_name WeightedDie

@onready var rigid_body_3d: WeightedDie = $"."

@onready var dice_logic: DiceLogic = $DiceLogic

@onready var mesh: MeshInstance3D = $Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/Dice_0/Object_4

var number : int = 0
var has_given_number : bool = false
var current_pos : Vector3
var recalling : bool = false
var dropping : bool = false
var shaking : bool = false
var thrown : bool = false
var focused : bool = false
var stored_pos : Vector3
var storing : bool = false
var stored : bool = false
var returning_to_box : bool = false
var rotation_delta_mult : int = 12
var outside_the_box : bool = false
var outside_the_box_multiplier_given_to_top_row : int 
var values : Array = [1, 2, 3, 4, 5, 6]
@export var weight_probabilities : Array = [1, 1, 1, 0.8, 0.6, 0.5]
@export var dice_position : int = 1
@onready var ray_cast_1: RayCast3D = $RayCast1
@onready var ray_cast_2: RayCast3D = $RayCast2
@onready var ray_cast_3: RayCast3D = $RayCast3
@onready var ray_cast_4: RayCast3D = $RayCast4
@onready var ray_cast_5: RayCast3D = $RayCast5
@onready var ray_cast_6: RayCast3D = $RayCast6
@onready var highlight: MeshInstance3D = $highlight

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var item_type : String = "Die"
@export var item_name : String = "Cheater's Die"
@export var tooltip : String = "Seems like someone rigged this one, that just ain't fair!"
@export var description : String = "Rolls 1-6, but is weighted to roll one number most often. More likely to be weighted to lower numbers, but you don't get to know which one."
@export var rarity : String = "Rare"

func _ready() -> void:
	var rotating_x : float
	var rotating_y : float
	var rotating_z : float
	rotating_x = randf_range(0, 4)
	rotating_y = randf_range(0, 4)
	rotating_z = randf_range(0, 4)
	rigid_body_3d.rotate_x(rotating_x * 90)
	rigid_body_3d.rotate_y(rotating_y * 90)
	rigid_body_3d.rotate_z(rotating_z * 90)
	gravity_scale = dice_logic.default_gravity
	mass = dice_logic.default_mass
	
	rig_die()
	
func rig_die() -> void:
	var random_weight := GameManager.rng
	var random_value : int = values[random_weight.rand_weighted(weight_probabilities)]
	match random_value:
		1:
			rigid_body_3d.center_of_mass.y = -0.2
		2:
			rigid_body_3d.center_of_mass.x = -0.2
		3:
			rigid_body_3d.center_of_mass.z = 0.2
		4:
			rigid_body_3d.center_of_mass.z = -0.2
		5:
			rigid_body_3d.center_of_mass.x = 0.2
		6:
			rigid_body_3d.center_of_mass.y = 0.2
	
func update_ui() -> void:
	dice_logic.update_ui()

func return_to_box() -> void:
	dice_logic.return_to_box()

func _physics_process(delta: float) -> void:
	if linear_velocity.length() < 0.1 and !has_given_number:
		current_pos = position
		if ray_cast_1.is_colliding():
			number = 1
		if ray_cast_2.is_colliding():
			number = 2
		if ray_cast_3.is_colliding():
			number = 3
		if ray_cast_4.is_colliding():
			number = 4
		if ray_cast_5.is_colliding():
			number = 5
		if ray_cast_6.is_colliding():
			number = 6
		if outside_the_box_multiplier_given_to_top_row != 0 and get_parent().score_sheet.dice_giving_temp_modifier.get(dice_position) == true or !outside_the_box and outside_the_box_multiplier_given_to_top_row != 0 and get_parent().score_sheet.dice_giving_temp_modifier.get(dice_position) == true:
			match outside_the_box_multiplier_given_to_top_row:
				0:
					pass
				1:
					get_parent().score_sheet.ones_multiplier -= dice_logic.outside_the_box_multiplier
				2:
					get_parent().score_sheet.twos_multiplier -= dice_logic.outside_the_box_multiplier
				3:
					get_parent().score_sheet.threes_multiplier -= dice_logic.outside_the_box_multiplier
				4:
					get_parent().score_sheet.fours_multiplier -= dice_logic.outside_the_box_multiplier
				5:
					get_parent().score_sheet.fives_multiplier -= dice_logic.outside_the_box_multiplier
				6:
					get_parent().score_sheet.sixes_multiplier -= dice_logic.outside_the_box_multiplier
			get_parent().score_sheet.dice_giving_temp_modifier.set(dice_position, false)
		if outside_the_box:
			outside_the_box_multiplier_given_to_top_row = number
			get_parent().score_sheet.dice_giving_temp_modifier.set(dice_position, true)
			match number:
				1:
					get_parent().score_sheet.ones_multiplier += dice_logic.outside_the_box_multiplier
				2:
					get_parent().score_sheet.twos_multiplier += dice_logic.outside_the_box_multiplier
				3:
					get_parent().score_sheet.threes_multiplier += dice_logic.outside_the_box_multiplier
				4:
					get_parent().score_sheet.fours_multiplier += dice_logic.outside_the_box_multiplier
				5:
					get_parent().score_sheet.fives_multiplier += dice_logic.outside_the_box_multiplier
				6:
					get_parent().score_sheet.sixes_multiplier += dice_logic.outside_the_box_multiplier
		get_parent().score_sheet.modifier_check()
		get_parent().score_sheet.update_multipliers()
		print(number)
		dice_logic.update_ui()
		has_given_number = true
		
			
		print(number)
		dice_logic.update_ui()
		has_given_number = true

	if storing:
		recalling = false
		has_given_number = true
		if number == 1:
			if rotation.x != 0.0:
				rotation.x = move_toward(rotation.x, 0.0, delta * rotation_delta_mult)
			if rotation.y != 0.0:
				rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
			if rotation.z != 0.0:
				rotation.z = move_toward(rotation.z, 0.0, delta * rotation_delta_mult)
		if number == 2:
			if rotation.x != 0.0:
				rotation.x = move_toward(rotation.x, 0.0, delta * rotation_delta_mult)
			if rotation.y != 0.0:
				rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
			if rotation.z != 1.5:
				rotation.z = move_toward(rotation.z, 1.5, delta * rotation_delta_mult)
		if number == 3:
			if rotation.x != 1.5:
				rotation.x = move_toward(rotation.x, 1.5, delta * rotation_delta_mult)
			if rotation.y != 0.0:
				rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
			if rotation.z != 0.0:
				rotation.z = move_toward(rotation.z, 0.0, delta * rotation_delta_mult)
		if number == 4:
			if rotation.x != -1.5:
				rotation.x = move_toward(rotation.x, -1.5, delta * rotation_delta_mult)
			if rotation.y != 0.0:
				rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
			if rotation.z != 0.0:
				rotation.z = move_toward(rotation.z, 0.0, delta * rotation_delta_mult)
			#if rotation != Vector3(-90.0, 0.0, 0.0): 
		if number == 5:
			if rotation.x != 0.0:
				rotation.x = move_toward(rotation.x, 0.0, delta * rotation_delta_mult)
			if rotation.y != 0.0:
				rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
			if rotation.z != -1.5:
				rotation.z = move_toward(rotation.z, -1.5, delta * rotation_delta_mult)
		if number == 6:
			if rotation.x != 0.0:
				rotation.x = move_toward(rotation.x, 0.0, delta * rotation_delta_mult)
			if rotation.y != 0.0:
				rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
			if rotation.z != -3.0:
				rotation.z = move_toward(rotation.z, -3.0, delta * rotation_delta_mult)
		position = lerp(position, stored_pos, delta * 10)

func _on_dice_noise_detection_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice"):
		print("dicehit")
		var random_noise : int = 0
		random_noise = randi_range(1, 3)
		if random_noise == 1:
			audio_stream_player_3d.stream = dice_logic.dice_clink_sound_1
		if random_noise == 2:
			audio_stream_player_3d.stream = dice_logic.dice_clink_sound_2
		if random_noise == 3:
			audio_stream_player_3d.stream = dice_logic.dice_clink_sound_3
		audio_stream_player_3d.volume_db = (-8 + randf_range(-1, 4))
		audio_stream_player_3d.pitch_scale = (0 + randf_range(0.8, 2))
		audio_stream_player_3d.play()
	
func leftclickinteraction() -> void:
	dice_logic.storage()
	
func _on_d_6_mouse_detect_mouse_entered() -> void:
	dice_logic.focusdie()
	print(str(dice_position) + " focused")

func _on_d_6_mouse_detect_mouse_exited() -> void:
	dice_logic.losefocusdie()

func _on_dice_noise_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("wood"):
		dice_logic.play_wood_sound()
	if area.is_in_group("soft"):
		dice_logic.play_soft_sound()
