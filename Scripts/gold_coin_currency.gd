extends RigidBody3D

@export var coin_number : int
@onready var gold_coin: RigidBody3D = $"."
var values : Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
@export var weight_probabilities : Array = [2, 2, 1, 0.7, 0.7, 0.7, 0.2, 0.2, 0.9, 0.9]
@onready var mesh: MeshInstance3D = $coin_material
@onready var kill_timer: Timer = $KillTimer
@onready var timer: Timer = $Timer
var random_noise : int = 0
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
var can_play_sound : bool = false

var proximity_coins : Dictionary = {}

func random_coin_clink() -> void:
	match random_noise:
		1:
			audio_stream_player_3d.stream = SfxBank.coin_drop_1
		2:
			audio_stream_player_3d.stream = SfxBank.coin_hit_1
		3:
			audio_stream_player_3d.stream = SfxBank.coin_hit_2
		4:
			audio_stream_player_3d.stream = SfxBank.coin_hit_3
	audio_stream_player_3d.volume_db = randf_range(-12, -10)
	audio_stream_player_3d.pitch_scale = randf_range(0.9, 1.2)
	audio_stream_player_3d.play()


@export var coin_hit_1 : Resource = preload("res://Assets/SFX/coinhit1.ogg")
@export var coin_hit_2 : Resource = preload("res://Assets/SFX/coinhit2.ogg")
@export var coin_hit_3 : Resource = preload("res://Assets/SFX/coin hit 3.ogg")


func honk_shoo_mimimi() -> void:
	print(gold_coin.linear_velocity.y)
	if gold_coin.sleeping or linear_velocity.y < 1 and linear_velocity.y > -1:
		gold_coin.freeze = true
	else:
		pass

func unfreeze() -> void:
	if gold_coin.sleeping:
		gold_coin.freeze = false
		timer.start()

func i_must_go_now() -> void:
	unfreeze()
	gold_coin.set_collision_layer_value(1, false)
	gold_coin.set_collision_layer_value(5, false)
	gold_coin.set_collision_mask_value(1, false)
	gold_coin.set_collision_mask_value(5, false)
	gold_coin.linear_velocity.y = 80
	gold_coin.angular_velocity.x = 40
	kill_timer.start()

func _on_timer_timeout() -> void:
	if gold_coin.freeze != true:
		honk_shoo_mimimi()
	else:
		timer.start()


func _on_kill_timer_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("currency") and can_play_sound:
		if linear_velocity.y < -2:
			random_noise = randi_range(1, 4)
			random_coin_clink()
	can_play_sound = true
