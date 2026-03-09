extends Node3D

func color_shift(color):
			
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
