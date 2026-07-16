extends Control

var pen_sound := preload("res://Assets/SFX/sound_garage-pen-signature-5-395486.ogg")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var star_sound := preload("res://Assets/SFX/Extra Life.wav")
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var performance: Label = $Performance

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	audio_stream_player.stream = pen_sound
	audio_stream_player.play()
	await get_tree().create_timer(0.7).timeout
	audio_stream_player_2.stream = star_sound
	audio_stream_player_2.play()
	if !GameManager.performance_mode:
		performance.visible = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "logo_animation":
		if GameManager.is_on_web:
			get_tree().change_scene_to_file("res://Scenes/WebWarning.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("performance_on_go") and !GameManager.performance_mode:
		Settings._on_check_button_toggled(true)
		performance.visible = false
		Settings.check_button.button_pressed = true
