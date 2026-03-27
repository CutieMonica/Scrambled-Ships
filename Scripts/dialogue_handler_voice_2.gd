extends Control

signal text_done
var max_characters : int
var sound_1 := preload("res://Assets/SFX/voice2/a.ogg")
var sound_2 := preload("res://Assets/SFX/voice2/ceh.ogg")
var sound_3 := preload("res://Assets/SFX/voice2/e.ogg")
var sound_4 := preload("res://Assets/SFX/voice2/ehp.ogg")
var sound_5 := preload("res://Assets/SFX/voice2/em.ogg")
var sound_6 := preload("res://Assets/SFX/voice2/keh.ogg")
var sound_7 := preload("res://Assets/SFX/voice2/ooh.ogg")

@export var text : String = " "
@export var volume : float
@export var start_cutscene : bool = true
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var label: RichTextLabel = $Text
@onready var timer: Timer = $Timer
@export var align_screen : String = "bottom"
@export var min_pitch : float = 0.8
@export var max_pitch : float = 1.1
@onready var text_shader_animation: AnimationPlayer = $text_shader_animation
@onready var outline: RichTextLabel = $Outline
@onready var shadow: RichTextLabel = $Shadow

func update_text() -> void:
	label.visible_characters = 0
	outline.visible_characters = 0
	shadow.visible_characters = 0
	label.text = text
	outline.text = text
	shadow.text = text
	match align_screen:
		"bottom":
			label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			outline.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			shadow.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		"middle":
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			outline.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			shadow.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		"top":
			label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
			outline.vertical_alignment = VERTICAL_ALIGNMENT_TOP
			shadow.vertical_alignment = VERTICAL_ALIGNMENT_TOP

func _ready() -> void:
	label.text = " "
	outline.text = " "
	shadow.text = " "
	if GameManager.ending_cutscene:
		align_screen = "middle"
	if GameManager.is_postgame:
		align_screen = "top"

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
	audio_stream_player.pitch_scale = (0 + GameManager.rng.randf_range(min_pitch, max_pitch))
	audio_stream_player.play()
		
	#if audio_stream_player.playing:
		#audio_stream_player.stop()
	#if !audio_stream_player.playing:
		#audio_stream_player.play()
func _on_timer_timeout() -> void:
	if label.visible_ratio != 1:
		label.visible_characters += 1
		outline.visible_characters += 1
		shadow.visible_characters += 1
		if str(label.text[label.visible_characters - 1]) != " ":
			random_noises()
	if label.visible_ratio == 1:
		text_done.emit()
		timer.stop()

func back_to_normal() -> void:
	text_shader_animation.play("wave")

func play_shake_1() -> void:
	text_shader_animation.play("shaky")
	
func play_shake_2() -> void:
	text_shader_animation.play("shaky2")
