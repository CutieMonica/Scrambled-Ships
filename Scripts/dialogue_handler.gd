extends Control

signal text_done
var max_characters : int
var sound_1 := preload("res://Assets/SFX/dealer1.ogg")
var sound_2 := preload("res://Assets/SFX/dealer2.ogg")
var sound_3 := preload("res://Assets/SFX/dealer3.ogg")
var sound_4 := preload("res://Assets/SFX/dealer4.ogg")
var sound_5 := preload("res://Assets/SFX/dealer5.ogg")
var sound_6 := preload("res://Assets/SFX/dealer6.ogg")
var sound_7 := preload("res://Assets/SFX/dealer7.ogg")

@export var volume : float = 0
@export var text : String = " "
@export var start_cutscene : bool = true
@export var wave_amplitude : float = -5.0
@export var wave_frequency : float = 140.0
@export var movement_speed : float = 2.0
@export var movement_amplitude : float = 1.0
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var label: RichTextLabel = $Text
@onready var timer: Timer = $Timer
@onready var text_shader_animation: AnimationPlayer = $text_shader_animation
@export var align_screen : String = "top"


func update_text() -> void:
	label.visible_characters = 0
	label.text = text
	match align_screen:
		"bottom":
			label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		"middle":
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		"top":
			label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

func contrast_switch() -> void:
	if GameManager.increase_contrast:
		label.set("theme_override_colors/font_shadow_color", Color("000000ff"))
	else:
		label.set("theme_override_colors/font_shadow_color", Color("0000ffff"))

func _ready() -> void:
	contrast_switch()
	label.text = " "
	if GameManager.ending_cutscene:
		align_screen = "middle"

func _process(_delta: float) -> void:
	if start_cutscene == true:
		timer.start()
		update_text()
		start_cutscene = false

# 0.15 secs on average
func random_noises() -> void:
	var random_noise : int = 0
	random_noise = GameManager.rng.randi_range(1, 7)
	if random_noise == 1:
		audio_stream_player.stream = sound_1
	if random_noise == 2:
		audio_stream_player.stream = sound_2
	if random_noise == 3:
		audio_stream_player.stream = sound_3
	if random_noise == 4:
		audio_stream_player.stream = sound_4
	if random_noise == 5:
		audio_stream_player.stream = sound_5
	if random_noise == 6:
		audio_stream_player.stream = sound_6
	if random_noise == 7:
		audio_stream_player.stream = sound_7
	audio_stream_player.volume_db = (-8 + GameManager.rng.randf_range(-1, 4) - volume)
	audio_stream_player.pitch_scale = (0 + GameManager.rng.randf_range(0.85, 1.25))
	audio_stream_player.play()
		
	#if audio_stream_player.playing:
		#audio_stream_player.stop()
	#if !audio_stream_player.playing:
		#audio_stream_player.play()
func _on_timer_timeout() -> void:
	if label.visible_ratio != 1:
		label.visible_characters += 1
		if str(label.text[label.visible_characters - 1]) != " ":
			random_noises()
	if label.visible_ratio == 1:
		text_done.emit()
		timer.stop()
	

func ending_instability() -> void:
	text_shader_animation.stop()
	text_shader_animation.play("unstability")
