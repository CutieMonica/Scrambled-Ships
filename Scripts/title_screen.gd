extends Node3D

@onready var start: TextureButton = $Control/Start
@onready var settings_button: TextureButton = $Control/Settings
@onready var settings: Control = $Settings
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mesh_instance_3d: MeshInstance3D = $Camera3D/MeshInstance3D
@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D

func _ready() -> void:
	seed(1)

func performance_switch() -> void:
	if GameManager.performance_mode:
		mesh_instance_3d.visible = false
		directional_light_3d.shadow_enabled = false
	if !GameManager.performance_mode:
		mesh_instance_3d.visible = true
		directional_light_3d.shadow_enabled = true

func _on_settings_pressed() -> void:
	start.disabled = true
	settings_button.disabled = true
	settings.random_sound()
	settings.and_then_i_pull_up_hop_out_at_the_after_party()
	
func _on_start_pressed() -> void:
	GameManager.give_me_your_seed()
	settings.random_sound()
	animation_player.play("fadeout")
	GlobalMusicPlayer.fade_out()
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeout":
		get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")
