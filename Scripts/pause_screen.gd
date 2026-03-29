extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@export var paused : bool = false
@onready var continue_button: TextureButton = $CanvasLayer/ColorRect/Continue
@onready var settings: TextureButton = $CanvasLayer/ColorRect/Settings
@onready var exit: TextureButton = $CanvasLayer/ColorRect/Exit
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
var can_unpause : bool = false
var can_pause : bool = false
@onready var pause_buffer: Timer = $PauseBuffer
@onready var color_rect_2: ColorRect = $CanvasLayer/ColorRect2


func playsound(sound : int) -> void:
	if sound == 1:
		audio_stream_player.stream = SfxBank.generic_confirm_sound
	if sound == 2:
		audio_stream_player.stream = SfxBank.slide_in
	if sound == 3:
		audio_stream_player.stream = SfxBank.slide_out
	audio_stream_player.play()

func pause() -> void:
	if can_pause and InputHandler.actionable and pause_buffer.is_stopped():
		pause_buffer.start()
		match paused:
			false:
				can_unpause = true
				playsound(2)
				get_tree().paused = true
				animation_player.play("PauseScreenOn")
			true:
				_on_continue_pressed()
				
	
		

func enable_buttons() -> void:
	if InputHandler.in_game:
		continue_button.disabled = false
		settings.disabled = false
		exit.disabled = false
		can_unpause = true

func _on_continue_pressed() -> void:
	if can_unpause:
		playsound(3)
		get_tree().paused = false
		animation_player.play_backwards("PauseScreenOn")
		continue_button.disabled = true
		settings.disabled = true
		exit.disabled = true

func _on_settings_pressed() -> void:
	playsound(1)
	can_unpause = false
	Settings.and_then_i_pull_up_hop_out_at_the_after_party()
	continue_button.disabled = true
	settings.disabled = true
	exit.disabled = true

func _on_exit_pressed() -> void:
	playsound(1)
	can_unpause = false
	continue_button.disabled = true
	settings.disabled = true
	exit.disabled = true
	animation_player.play("ExitPressed")
	GlobalMusicPlayer.fade_out()
	get_tree().get_first_node_in_group("main").radio.fade_out_song()
	await get_tree().create_timer(1).timeout
	animation_player.play_backwards("PauseScreenOn")
	paused = false
	InputHandler.in_game = false
	get_tree().paused = false
	continue_button.disabled = true
	settings.disabled = true
	exit.disabled = true
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	await get_tree().create_timer(0.2).timeout
	color_rect_2.visible = false
		


func _on_pause_buffer_timeout() -> void:
	paused = !paused
