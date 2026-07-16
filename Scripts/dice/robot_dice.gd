extends RigidBody3D

class_name Robot_die

@onready var dice_logic: DiceLogic = $DiceLogic

@onready var mesh: MeshInstance3D = $Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/Dice_0/Object_4

var number : int = 0
var add_to_meter : int = 0
var has_given_number : bool = false
var current_pos : Vector3
var recalling : bool = false
var dropping : bool = false
var shaking : bool = false
var thrown : bool = false
var focused : bool = false
var burnt_out : bool = false
var stored_pos : Vector3
var storing : bool = false
var stored : bool = false
var returning_to_box : bool = false
var rotation_delta_mult : int = 12
var outside_the_box : bool = false
var outside_the_box_multiplier_given_to_top_row : int = 0
@export var dice_position : int = 1
@onready var ray_cast_1: RayCast3D = $RayCast1
@onready var ray_cast_2: RayCast3D = $RayCast2
@onready var ray_cast_3: RayCast3D = $RayCast3
@onready var ray_cast_4: RayCast3D = $RayCast4
@onready var ray_cast_5: RayCast3D = $RayCast5
@onready var ray_cast_6: RayCast3D = $RayCast6
@onready var rigid_body_3d: RigidBody3D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var highlight: MeshInstance3D = $Highlight
@onready var highlight_bubble: MeshInstance3D = $Highlight/HighlightBubble
@onready var highlight_circle: MeshInstance3D = $Highlight/HighlightBubble/HighlightCircle
@onready var number_buffer: Timer = $NumberBuffer
@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D

@export var item_type : String = "Die"
@export var item_name : String = "Robot Die"
@export var tooltip : String = "Looks like it was stolen from some demented game show."
@export var description : String = "Rolls 1-6. When rerolled, the number it rolls will be added to the meter, which will become its new value. If the meter goes over 12, the die becomes useless for the rest of the round. If the meter hits exactly 12, you get rewarded. The meter is not affected by cards."
@export var rarity : String = "Rare"

const ROBOT_DIE = preload("uid://dtbwg3qhjr01u")
const ROBOT_DIE_1 = preload("uid://crsykskwcfrd4")
const ROBOT_DIE_2 = preload("uid://bw7n40kfqmmyn")
const ROBOT_DIE_3 = preload("uid://cak2pp6y31h2q")
const ROBOT_DIE_4 = preload("uid://cucsmnrlrho6b")
const ROBOT_DIE_5 = preload("uid://bjtj5dchehyve")
const ROBOT_DIE_6 = preload("uid://bjwi47bo60v7b")
const ROBOT_DIE_7 = preload("uid://b1d3u26sxh22o")
const ROBOT_DIE_8 = preload("uid://brw3xswdurarg")
const ROBOT_DIE_9 = preload("uid://6a4qh3p5cm22")
const ROBOT_DIE_10 = preload("uid://tj5o4we6gdy1")
const ROBOT_DIE_11 = preload("uid://cb4ys1oe6dtrb")
const ROBOT_DIE_12 = preload("uid://d0a2r813bjbo8")
const ROBOT_DIE_OVERHEAT = preload("uid://dcybljkm2dmps")

var dice_textures : Dictionary = {
	0: ROBOT_DIE,
	1: ROBOT_DIE_1,
	2: ROBOT_DIE_2,
	3: ROBOT_DIE_3,
	4: ROBOT_DIE_4,
	5: ROBOT_DIE_5,
	6: ROBOT_DIE_6,
	7: ROBOT_DIE_7,
	8: ROBOT_DIE_8,
	9: ROBOT_DIE_9,
	10: ROBOT_DIE_10,
	11: ROBOT_DIE_11,
	12: ROBOT_DIE_12,
	13:  ROBOT_DIE_OVERHEAT
}


func _ready() -> void:
	burnt_out = false
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
	
func reset_burnt() -> void:
	has_given_number = false
	burnt_out = false
	number = 0
	add_to_meter = 0
	mesh.get_active_material(0).albedo_texture = dice_textures.get(number)
	
func number_change() -> void:
	for i in add_to_meter:
		number += 1
		if number < 13 and !burnt_out:
			mesh.get_active_material(0).albedo_texture = dice_textures.get(number)
			audio_stream_player_3d.stream = SfxBank.robotbeep
			audio_stream_player_3d.volume_db = (-10 + (number * 0.2))
			audio_stream_player_3d.pitch_scale = (1 + (number * 0.1))
			audio_stream_player_3d.play()
			number_buffer.start()
			update_ui()
			await number_buffer.timeout
		if number >= 13:
			burnt_out = true
			number = 0
			mesh.get_active_material(0).albedo_texture = dice_textures.get(13)
			audio_stream_player_3d.stream = SfxBank.generic_deny_sound
			audio_stream_player_3d.volume_db = (-8)
			audio_stream_player_3d.pitch_scale = (1)
			audio_stream_player_3d.play()
			update_ui()
			cpu_particles_3d.emitting = true
			break
	add_to_meter = 0
	dice_logic.remove_modifier()
	if number == 12:
		get_parent().give_extra_rerolls(2)
	if outside_the_box and get_parent().score_sheet.dice_giving_temp_modifier.get(dice_position) == false:
		outside_the_box_multiplier_given_to_top_row = number
		get_parent().score_sheet.dice_giving_temp_modifier.set(dice_position, true)
		match number:
			0:
				pass
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
			7:
				get_parent().score_sheet.choice_multiplier += dice_logic.outside_the_box_multiplier
			8:
				get_parent().score_sheet.small_straight_multiplier += dice_logic.outside_the_box_multiplier
			9:
				get_parent().score_sheet.full_house_multiplier += dice_logic.outside_the_box_multiplier
			10:
				get_parent().score_sheet.large_straight_multiplier += dice_logic.outside_the_box_multiplier
			11:
				get_parent().score_sheet.four_of_a_kind_multiplier += dice_logic.outside_the_box_multiplier
			12:
				get_parent().score_sheet.yacht_multiplier += dice_logic.outside_the_box_multiplier
		get_parent().score_sheet.modifier_check()
		get_parent().score_sheet.update_multipliers()
	
func update_ui() -> void:
	dice_logic.update_ui()

func return_to_box() -> void:
	dice_logic.return_to_box()

func _physics_process(delta: float) -> void:
	if linear_velocity.length() < 0.1 and !has_given_number:
		current_pos = position
		if !burnt_out:
			if ray_cast_1.is_colliding():
				if add_to_meter == 0:
					add_to_meter = 1
				dice_logic.dice_storage_rotation = Vector3.ZERO
				dice_logic.dice_side_up = 1
			if ray_cast_2.is_colliding():
				if add_to_meter == 0:
					add_to_meter = 2
				dice_logic.dice_storage_rotation = Vector3(0, 0, 1.5)
				dice_logic.dice_side_up = 2
			if ray_cast_3.is_colliding():
				if add_to_meter == 0:
					add_to_meter = 3
				dice_logic.dice_storage_rotation = Vector3(1.5, 0, 0)
				dice_logic.dice_side_up = 3
			if ray_cast_4.is_colliding():
				if add_to_meter == 0:
					add_to_meter = 4
				dice_logic.dice_storage_rotation = Vector3(-1.5, 0, 0)
				dice_logic.dice_side_up = 4
			if ray_cast_5.is_colliding():
				if add_to_meter == 0:
					add_to_meter = 5
				dice_logic.dice_storage_rotation = Vector3(0, 0, -1.5)
				dice_logic.dice_side_up = 5
			if ray_cast_6.is_colliding():
				if add_to_meter == 0:
					add_to_meter = 6
				dice_logic.dice_storage_rotation = Vector3(0, 0, -3)
				dice_logic.dice_side_up = 6
			
			number_change()
			
		dice_logic.remove_modifier()
		if outside_the_box and get_parent().score_sheet.dice_giving_temp_modifier.get(dice_position) == false:
			outside_the_box_multiplier_given_to_top_row = number
			get_parent().score_sheet.dice_giving_temp_modifier.set(dice_position, true)
			match number:
				0:
					pass
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
				7:
					get_parent().score_sheet.choice_multiplier += dice_logic.outside_the_box_multiplier
				8:
					get_parent().score_sheet.small_straight_multiplier += dice_logic.outside_the_box_multiplier
				9:
					get_parent().score_sheet.full_house_multiplier += dice_logic.outside_the_box_multiplier
				10:
					get_parent().score_sheet.large_straight_multiplier += dice_logic.outside_the_box_multiplier
				11:
					get_parent().score_sheet.four_of_a_kind_multiplier += dice_logic.outside_the_box_multiplier
				12:
					get_parent().score_sheet.yacht_multiplier += dice_logic.outside_the_box_multiplier
		get_parent().score_sheet.modifier_check()
		get_parent().score_sheet.update_multipliers()
		print(number)
		dice_logic.update_ui()
		has_given_number = true

	if storing:
		recalling = false
		has_given_number = true
		if rotation.x != 0.0:
			rotation.x = move_toward(rotation.x, 0.0, delta * rotation_delta_mult)
		if rotation.y != 0.0:
			rotation.y = move_toward(rotation.y, 0.0, delta * rotation_delta_mult)
		if rotation.z != 0.0:
			rotation.z = move_toward(rotation.z, 0.0, delta * rotation_delta_mult)
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
	
func _on_d_6_mouse_detect_mouse_entered() -> void:
	dice_logic.focusdie()
	print(str(dice_position) + " focused")

func leftclickinteraction() -> void:
	dice_logic.storage()

func _on_d_6_mouse_detect_mouse_exited() -> void:
	dice_logic.losefocusdie()

func _on_dice_noise_detection_area_entered(area: Area3D) -> void:
	if area.is_in_group("wood"):
		dice_logic.play_wood_sound()
	if area.is_in_group("soft"):
		dice_logic.play_soft_sound()
