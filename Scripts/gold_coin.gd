extends RigidBody3D

@export var coin_number : int

var mid_air_hits : int = 0
var hovered : bool = false
var random_song : int = 1

var moving : bool = false
@onready var gold_coin: RigidBody3D = $"."
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var hit_counter: Label3D = $"../HitCounter"
@onready var timer: Timer = $Timer
@onready var collision_shape_3d: CollisionShape3D = $StupidFeatureNeutral/CollisionShape3D
@onready var mesh: MeshInstance3D = $"Sketchfab_Scene/Sketchfab_model/4761e60571154708a3a5b48b4216d582_fbx/RootNode/bitcoin/bitcoin_Material_0"
var values : Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
@export var weight_probabilities : Array = [2, 2, 1, 0.7, 0.7, 0.7, 0.2, 0.2, 0.9, 0.9]
var random_noise : int = 1
var can_play_sound : bool = false
var proximity_coins : Dictionary = {}
var soundtype : String = "coin"

func random_coin_clink() -> void:
	if soundtype == "coin":
		match random_noise:
			1:
				audio_stream_player_3d.stream = SfxBank.coin_drop_1
			2:
				audio_stream_player_3d.stream = SfxBank.coin_hit_1
			3:
				audio_stream_player_3d.stream = SfxBank.coin_hit_2
			4:
				audio_stream_player_3d.stream = SfxBank.coin_hit_3
	if soundtype == "wood":
		audio_stream_player_3d.stream = SfxBank.coin_table_hit
	audio_stream_player_3d.volume_db = randf_range(-9, -7)
	audio_stream_player_3d.pitch_scale = randf_range(0.9, 1.2)
	audio_stream_player_3d.play()


func _ready() -> void:
	hit_counter.visible = false
	var random_weight := GameManager.rng
	var random_value : int = values[random_weight.rand_weighted(weight_probabilities)]
	match random_value:
		1:
			mesh.get_surface_override_material(0).albedo_color = Color("fcb700")
		2:
			mesh.get_surface_override_material(0).albedo_color = Color("fc9500ff")
		3:
			mesh.get_surface_override_material(0).albedo_color = Color("fcd71eff")
		4:
			mesh.get_surface_override_material(0).albedo_color = Color("d6835eff")
		5:
			mesh.get_surface_override_material(0).albedo_color = Color("f9b669ff")
		6:
			mesh.get_surface_override_material(0).albedo_color = Color("bb5333ff")
		7:
			mesh.get_surface_override_material(0).albedo_color = Color("cde9fdff")
		8:
			mesh.get_surface_override_material(0).albedo_color = Color("aed9f6ff")
		9:
			mesh.get_surface_override_material(0).albedo_color = Color("d48c5aff")
		10:
			mesh.get_surface_override_material(0).albedo_color = Color("fecf98ff")

func freeze() -> void:
	if gold_coin.sleeping or linear_velocity.length() < 1.5:
		gold_coin.freeze = true
		moving = false

func unfreeze() -> void:
	timer.start()
	gold_coin.freeze = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and hovered:
		mid_air_hits += 1
		moving = true
		unfreeze()
		collision_shape_3d.disabled = false
		#get_tree().call_group("reroll_coins", "unfreeze")
		linear_velocity.y = GameManager.rng.randf_range(5, 8)
		linear_velocity.x = GameManager.rng.randf_range(-2, 2)
		linear_velocity.z = GameManager.rng.randf_range(-2, 2)
		angular_velocity.x = GameManager.rng.randf_range(-40, 40)
		angular_velocity.z = GameManager.rng.randf_range(-40, 40)
		if mid_air_hits < 3:
			audio_stream_player_3d.stream = SfxBank.coinclick
			audio_stream_player_3d.volume_db = (-8)
			audio_stream_player_3d.play()
		if mid_air_hits == 2:
			collision_shape_3d.disabled = true
		if mid_air_hits >= 3:
			get_parent().update_label()
			hit_counter.visible = true
			hit_counter.font_size = 256 + (mid_air_hits * 4)
			print(hit_counter.font_size)
			hit_counter.text = str(mid_air_hits)
			audio_stream_player_3d.stream = SfxBank.orchestrahit
			audio_stream_player_3d.volume_db = (-8 + mid_air_hits * 0.1)
			audio_stream_player_3d.play()
			if mid_air_hits < 15:
				if random_song == 1:
					match mid_air_hits:
						3:
							audio_stream_player_3d.pitch_scale = (2)
						4:
							audio_stream_player_3d.pitch_scale = (3)
						5:
							audio_stream_player_3d.pitch_scale = (3.5)
						6:
							audio_stream_player_3d.pitch_scale = (4)
						7:
							audio_stream_player_3d.pitch_scale = (4.5)
						8:
							audio_stream_player_3d.pitch_scale = (2)
						9:
							audio_stream_player_3d.pitch_scale = (2)
						10:
							audio_stream_player_3d.pitch_scale = (3)
						11:
							audio_stream_player_3d.pitch_scale = (3.9)
						12:
							audio_stream_player_3d.pitch_scale = (3.5)
						13:
							audio_stream_player_3d.pitch_scale = (3)
						14:
							audio_stream_player_3d.pitch_scale = (2)
				if random_song == 2:
					match mid_air_hits:
						3:
							audio_stream_player_3d.pitch_scale = (2)
						4:
							audio_stream_player_3d.pitch_scale = (2)
						5:
							audio_stream_player_3d.pitch_scale = (4.25)
						6:
							audio_stream_player_3d.pitch_scale = (2.8)
						7:
							audio_stream_player_3d.pitch_scale = (3.1)
						8:
							audio_stream_player_3d.pitch_scale = (3)
						9:
							audio_stream_player_3d.pitch_scale = (2.75)
						10:
							audio_stream_player_3d.pitch_scale = (2)
						11:
							audio_stream_player_3d.pitch_scale = (2.25)
						12:
							audio_stream_player_3d.pitch_scale = (2.5)
						13:
							audio_stream_player_3d.pitch_scale = (2)
						14:
							audio_stream_player_3d.pitch_scale = (2)
			else:
				audio_stream_player_3d.pitch_scale = (1 + mid_air_hits * 0.1)
					

func stop_the_count() -> void:
	collision_shape_3d.disabled = true
	moving = false
	mid_air_hits = 0
	hit_counter.visible = false
	random_song = randi_range(1, 2)

func _on_sleeping_state_changed() -> void:
	if gold_coin.sleeping:
		stop_the_count()

func _on_stupid_feature_stopper_area_entered(area: Area3D) -> void:
	if area.is_in_group("wood") and can_play_sound:
		if linear_velocity.y < -2:
			random_noise = randi_range(1, 1)
			random_coin_clink()
			soundtype = "wood"
	stop_the_count()


func _on_stupid_feature_stopper_area_shape_entered(_area_rid: RID, area: Area3D, _area_shape_index: int, _local_shape_index: int) -> void:
	if area.is_in_group("wood") and can_play_sound:
		if linear_velocity.y < -2:
			random_noise = randi_range(1, 1)
			random_coin_clink()
			soundtype = "wood"
	stop_the_count()


func _on_stupid_feature_stopper_body_entered(body: Node3D) -> void:
	if body.is_in_group("reroll_coins") and can_play_sound:
		if linear_velocity.y < -2:
			random_noise = randi_range(1, 4)
			random_coin_clink()
			soundtype = "coin"
	can_play_sound = true
	stop_the_count()


func _on_stupid_feature_stopper_body_shape_entered(_body_rid: RID, _body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	stop_the_count()


func _on_stupid_feature_continuer_mouse_entered() -> void:
	hovered = true


func _on_stupid_feature_continuer_mouse_exited() -> void:
	hovered = false


func _on_timer_timeout() -> void:
	if gold_coin.sleeping or linear_velocity.length() < 1.5:
		freeze()
		timer.stop()
	else:
		timer.start()

func _on_stupid_feature_neutral_body_entered(body: Node3D) -> void:
	if body.is_in_group("reroll_coins"):
		body.unfreeze()
		body.linear_velocity.y += 2
	if body.is_in_group("currency"):
		body.unfreeze()
		body.linear_velocity.y += 2
