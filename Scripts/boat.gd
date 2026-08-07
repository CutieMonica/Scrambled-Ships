extends StaticBody3D

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@onready var cpu_particles_3d_2: CPUParticles3D = $CPUParticles3D2
@onready var cpu_particles_3d_3: CPUParticles3D = $CPUParticles3D3
@onready var random_drawing_picker: Node = $RandomDrawingPicker

@onready var wood_carving: MeshInstance3D = $WoodCarving

@onready var environment_adjustment: AnimationPlayer = $EnvironmentAdjustment



func _ready() -> void:
	#Call performance switch here to kill the particles in the postgame
	performance_switch()
	
	#Gaster easter egg
	var mystery_man : int = GameManager.rng.randi_range(1, 1000)
	if mystery_man == 666:
		wood_carving.get_active_material(0).albedo_texture = random_drawing_picker.mrbeast
		await get_tree().create_timer(6.66).timeout
		
	#Cycle RNG just to make the desk drawing different for the starting seed, currently: Burgie
	for i : int in 2:
		var _arbitrary_rng_call : int = GameManager.rng.randi_range(1, 2)
		
	#Choose your character
	random_drawing_picker.random_icon = GameManager.rng.randi_range(1, random_drawing_picker.random_icon_image.size())
	wood_carving.get_active_material(0).albedo_texture = random_drawing_picker.random_icon_image.get(random_drawing_picker.random_icon)
	
	#Easter egg seed overrides
	if GameManager.fredmode:
		wood_carving.get_active_material(0).albedo_texture = random_drawing_picker.fred
	if GameManager.jonnymode: 
		wood_carving.get_active_material(0).albedo_texture = random_drawing_picker.jonnyboy
		
#Change lighting in Act 1
func play_environment_shift() -> void:
	environment_adjustment.play("Round" + str(GameManager.current_round))

#Change the environment if you lost
func play_losing_round() -> void:
	environment_adjustment.play("Round" + str(GameManager.current_round) + "_to_end")
	environment_adjustment.queue("RoundEnd")

func performance_switch() -> void:
	cpu_particles_3d.visible = !GameManager.performance_mode
	cpu_particles_3d_2.visible = !GameManager.performance_mode
	cpu_particles_3d_3.visible = !GameManager.performance_mode
