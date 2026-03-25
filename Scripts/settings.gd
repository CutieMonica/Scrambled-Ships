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
@onready var master_volume: HSlider = $CanvasLayer/TextureRect/MasterVolume
@onready var music_volume_ui: HSlider = $CanvasLayer/TextureRect/MusicVolume
@onready var sfx_volume_ui: HSlider = $CanvasLayer/TextureRect/SFXVolume
@onready var option_button: OptionButton = $CanvasLayer/TextureRect/OptionButton


func random_sound() -> void:
	var play_sound : int
	play_sound = randi_range(1, 2)
	if play_sound == 1:
		audio_stream_player.stream = pencil_sound_1
	if play_sound == 2:
		audio_stream_player.stream = pencil_sound_2
	audio_stream_player.play()

func _ready() -> void:
	SaveLoad._load()
	audio_stream_player.volume_db = -86
	if GameManager.performance_mode == true:
		check_button.button_pressed = true
	else:
		check_button.button_pressed = false
	if GameManager.is_on_web == true:
		check_button.disabled = true
	screensize = SaveLoad.SaveFileData.screensize
	option_button.selected = screensize
	match screensize:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	volume = SaveLoad.SaveFileData.volume
	AudioServer.set_bus_volume_db(0, volume)
	master_volume.value = volume
	music_volume = SaveLoad.SaveFileData.music_volume
	AudioServer.set_bus_volume_db(1, music_volume)
	music_volume_ui.value = music_volume
	sfx_volume = SaveLoad.SaveFileData.sfx_volume
	AudioServer.set_bus_volume_db(2, sfx_volume)
	sfx_volume_ui.value = sfx_volume
	
	await get_tree().create_timer(1).timeout
	audio_stream_player.volume_db = 0

func _on_option_button_pressed() -> void:
	random_sound()

func _on_option_button_item_selected(index: int) -> void:
	random_sound()
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			SaveLoad.SaveFileData.screensize = 0
			screensize = 0
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			SaveLoad.SaveFileData.screensize = 1
			screensize = 1
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			SaveLoad.SaveFileData.screensize = 2
			screensize = 2
	
func _on_texture_button_pressed() -> void:
	random_sound()
	animation_player.play_backwards("settingspopup")
	get_tree().call_group("title", "enable_buttons")
	check_button.disabled = true
	SaveLoad._save()
	
func _on_check_button_toggled(toggled_on: bool) -> void:
	random_sound()
	if toggled_on:
		GameManager.toggle_performance_mode(true)
		SaveLoad.SaveFileData.performance_mode = true
		get_tree().call_group("performance_switch", "performance_switch")
		Engine.physics_ticks_per_second = 120
	if !toggled_on:
		GameManager.toggle_performance_mode(false)
		SaveLoad.SaveFileData.performance_mode = false
		get_tree().call_group("performance_switch", "performance_switch")
		Engine.physics_ticks_per_second = 120 

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	SaveLoad.SaveFileData.sfx_volume = value
	sfx_volume = value
	check_button.grab_focus()

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	SaveLoad.SaveFileData.music_volume = value
	music_volume = value

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	SaveLoad.SaveFileData.volume = value
	volume = value

func _on_master_volume_drag_ended(_value_changed: bool) -> void:
	random_sound()

func _on_sfx_volume_drag_ended(_value_changed: bool) -> void:
	random_sound()

func _on_music_volume_drag_ended(_value_changed: bool) -> void:
	random_sound()

func and_then_i_pull_up_hop_out_at_the_after_party() -> void:
	animation_player.play("settingspopup")
	if !GameManager.is_on_web:
		check_button.disabled = false

func _on_line_edit_text_submitted(_new_text: String) -> void:
	if (int(line_edit.text)) > 0 and (int(line_edit.text)) <= 999999999:
		line_edit.text = str(int(line_edit.text))
		GameManager.input_seed = (int(line_edit.text))
	else:
		line_edit.text = str(0)
