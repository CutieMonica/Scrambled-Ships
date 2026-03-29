extends Node3D

var statue_activation_noise := preload("res://Assets/SFX/potentialstatueactivationnoise.ogg")
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func get_symbol() -> String:
	var symbol : String = ""
	if get_parent().added_modifier < 0:
		symbol = ""
	if get_parent().added_modifier >= 0:
		symbol = "+"
	return symbol

func play_audio() -> void:
	audio_stream_player_3d.stream = statue_activation_noise
	audio_stream_player_3d.pitch_scale = 0.9 + (get_parent().get_parent().statue_position * 0.1)
	audio_stream_player_3d.play()

func color_shift(color : String) -> void:
			
	match get_parent().color_shift_level:
		0:
			pass
		1:
			match color:
				"red":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("ffd6cfff")
				"blue":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("bde8ffff")
				"yellow":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("ffebb4ff")
				"purple":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("e6daffff")
		2:			
			match color:
				"red":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("ffa597ff")
				"blue":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("7ecdffff")
				"yellow":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("ffc165ff")
				"purple":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("ccb0ffff")
		3:
			match color:
				"red":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("ff7664ff")
				"blue":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("00adfbff")
				"yellow":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("faaa00ff")
				"purple":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("bb92ffff")
		4:
			match color:
				"red":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("e30400ff")
				"blue":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("2e6effff")
				"yellow":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("df8b00ff")
				"purple":
					get_parent().mesh.get_surface_override_material(0).albedo_color = Color("a051ffff")
