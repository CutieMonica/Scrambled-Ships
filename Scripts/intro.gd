extends Control

var pen_sound = preload("res://Assets/SFX/sound_garage-pen-signature-5-395486.ogg")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var star_sound = preload("res://Assets/SFX/Extra Life.wav")
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	audio_stream_player.stream = pen_sound
	audio_stream_player.play()
	await get_tree().create_timer(0.7).timeout
	audio_stream_player_2.stream = star_sound
	audio_stream_player_2.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "logo_animation":
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
