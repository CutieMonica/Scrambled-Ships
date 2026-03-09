extends RigidBody3D

class_name D6

@onready var rigid_body_3d: D6 = $"."

@onready var dice_logic: DiceLogic = $DiceLogic

@onready var mesh: MeshInstance3D = $Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/Dice_0/Object_4
@onready var highlight: MeshInstance3D = $Object_4


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
var rotation_delta_mult : int = 10
var outside_the_box : bool = false
var outside_the_box_multiplier_given_to_top_row : int = 0
@export var dice_position : int = 1
@onready var ray_cast_1: RayCast3D = $RayCast1
@onready var ray_cast_2: RayCast3D = $RayCast2
@onready var ray_cast_3: RayCast3D = $RayCast3
@onready var ray_cast_4: RayCast3D = $RayCast4
@onready var ray_cast_5: RayCast3D = $RayCast5
@onready var ray_cast_6: RayCast3D = $RayCast6

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	var rotating_x : float
	var rotating_y : float
	var rotating_z : float
	rotating_x = GameManager.rng.randf_range(0, 4)
	rotating_y = GameManager.rng.randf_range(0, 4)
	rotating_z = GameManager.rng.randf_range(0, 4)
	rigid_body_3d.rotate_x(rotating_x * 90)
	rigid_body_3d.rotate_y(rotating_y * 90)
	rigid_body_3d.rotate_z(rotating_z * 90)
	gravity_scale = dice_logic.default_gravity
	mass = dice_logic.default_mass
	
func update_ui():
	dice_logic.update_ui()

func return_to_box():
	dice_logic.return_to_box()

func _physics_process(delta: float) -> void:
	if rigid_body_3d.sleeping and !has_given_number:
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
		if outside_the_box_multiplier_given_to_top_row != 0:
			match outside_the_box_multiplier_given_to_top_row:
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
		if outside_the_box:
			outside_the_box_multiplier_given_to_top_row = number
			get_parent().score_sheet.has_temp_modifier = true
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
		
		get_parent().score_sheet.update_multipliers()
		
			
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
		position = lerp(position, stored_pos, delta * 5)

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
	
func leftclickinteraction():
	dice_logic.storage()
	
func _on_d_6_mouse_detect_mouse_entered() -> void:
	dice_logic.focusdie()
	print(str(dice_position) + " focused")

func _on_d_6_mouse_detect_mouse_exited() -> void:
	dice_logic.losefocusdie()
