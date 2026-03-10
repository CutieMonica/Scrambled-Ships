extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $CanvasLayer/AudioStreamPlayer

var screensize : int
var volume : float
var music_volume : float
var sfx_volume : float
var pencil_sound_1 := preload("res://Assets/SFX/pencilsound1.ogg")
var pencil_sound_2 := preload("res://Assets/SFX/pencilsound2.ogg")
@onready var check_button: CheckButton = $CanvasLayer/TextureRect/CheckButton
@onready var line_edit: LineEdit = $CanvasLayer/TextureRect/LineEdit

func random_sound() -> void:
	var play_sound : int
	play_sound = randi_range(1, 2)
	if play_sound == 1:
		audio_stream_player.stream = pencil_sound_1
	if play_sound == 2:
		audio_stream_player.stream = pencil_sound_2
	audio_stream_player.play()

func _ready() -> void:
	if GameManager.performance_mode == true:
		check_button.button_pressed = true
	else:
		check_button.button_pressed = false

func _on_option_button_pressed() -> void:
	random_sound()

func _on_option_button_item_selected(index: int) -> void:
	random_sound()
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			screensize = 0
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			screensize = 1
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			screensize = 2
	
func _on_texture_button_pressed() -> void:
	random_sound()
	animation_player.play_backwards("settingspopup")
	get_parent().start.disabled = false
	get_parent().settings_button.disabled = false
	
func _on_check_button_toggled(toggled_on: bool) -> void:
	random_sound()
	if toggled_on:
		GameManager.toggle_performance_mode(true)
		get_parent().performance_switch()
		Engine.physics_ticks_per_second = 120
	if !toggled_on:
		GameManager.toggle_performance_mode(false)
		get_parent().performance_switch()
		Engine.physics_ticks_per_second = 120 

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	sfx_volume = value
	check_button.grab_focus()

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	music_volume = value

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	volume = value

func _on_master_volume_drag_ended(_value_changed: bool) -> void:
	random_sound()

func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	random_sound()

func _on_music_volume_drag_ended(_value_changed: bool) -> void:
	random_sound()

func and_then_i_pull_up_hop_out_at_the_after_party() -> void:
	animation_player.play("settingspopup")

func _on_line_edit_text_submitted(_new_text: String) -> void:
	if (int(line_edit.text)) > 0 and (int(line_edit.text)) <= 999999999:
		line_edit.text = str(int(line_edit.text))
		GameManager.input_seed = (int(line_edit.text))
	else:
		line_edit.text = str(0)
