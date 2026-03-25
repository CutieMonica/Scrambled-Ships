extends Node3D

@onready var start: TextureButton = $Control/Start
@onready var settings_button: TextureButton = $Control/Settings
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $Camera3D/MeshInstance3D
@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D
@onready var exit: TextureButton = $Control/Exit

var exiting : bool = false

func _ready() -> void:
	GameManager.reset_things()
	performance_switch()
	seed(1)

func performance_switch() -> void:
	if GameManager.performance_mode:
		await get_tree().process_frame
		mesh_instance_3d.visible = false
		directional_light_3d.shadow_enabled = false
	if !GameManager.performance_mode:
		await get_tree().process_frame
		mesh_instance_3d.visible = true
		directional_light_3d.shadow_enabled = true

func _on_settings_pressed() -> void:
	start.disabled = true
	settings_button.disabled = true
	exit.disabled = true
	Settings.random_sound()
	Settings.and_then_i_pull_up_hop_out_at_the_after_party()
	
func _on_start_pressed() -> void:
	GameManager.run_number += 1
	SaveLoad.SaveFileData.run_number += 1
	SaveLoad._save()
	GameManager.give_me_your_seed()
	Settings.random_sound()
	animation_player.play("fadeout")
	GlobalMusicPlayer.ambience_target = 1
	GlobalMusicPlayer.fade_out()
	
	
func enable_buttons() -> void:
	print("enablers")
	start.disabled = false
	settings_button.disabled = false
	await get_tree().create_timer(0.5).timeout
	exit.disabled = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeout":
		if !exiting:
			get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
		if exiting:
			get_tree().quit()


func _on_exit_pressed() -> void:
	SaveLoad._save()
	Settings.random_sound()
	animation_player.play("fadeout")
	GlobalMusicPlayer.fade_out()
	exiting = true
