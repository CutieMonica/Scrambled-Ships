extends StaticBody3D

@onready var wood_carving: MeshInstance3D = $WoodCarving
var bad_ideas = load("res://Assets/Textures/deskcarvings/badideaswoodcarving.png")
var monica = load("res://Assets/Textures/deskcarvings/monicarving.png")
var gorbert = load("res://Assets/Textures/deskcarvings/gorbert.png")
var bob = load("uid://c55gb4likh6xu")
var B_0 = load("uid://dfel6t0y42b5s")
var brooke = load("uid://dcgs5b1k66l8j")
var limp_knight = load("uid://b634yw36eisxo")
var mushroom_kid = load("uid://imw7qge5sfke")
var salesman = load("uid://cmmwwfobvobw7")
var cool_s = load("res://Assets/Textures/deskcarvings/cool s.png")
var volf = load("res://Assets/Textures/deskcarvings/Volf.png")
var cabl = load("res://Assets/Textures/deskcarvings/cablo.png")

var random_icon : int

func _ready() -> void:
	random_icon = GameManager.rng.randi_range(1, 12)
	match random_icon:
		1: 
			wood_carving.get_active_material(0).albedo_texture = bad_ideas
		2: 
			wood_carving.get_active_material(0).albedo_texture = monica
		3: 
			wood_carving.get_active_material(0).albedo_texture = gorbert
		4:
			wood_carving.get_active_material(0).albedo_texture = bob
		5:
			wood_carving.get_active_material(0).albedo_texture = B_0
		6:
			wood_carving.get_active_material(0).albedo_texture = brooke
		7:
			wood_carving.get_active_material(0).albedo_texture = limp_knight
		8:
			wood_carving.get_active_material(0).albedo_texture = mushroom_kid
		9:
			wood_carving.get_active_material(0).albedo_texture = salesman
		10:
			wood_carving.get_active_material(0).albedo_texture = cool_s
		11:
			wood_carving.get_active_material(0).albedo_texture = volf
		12: 
			wood_carving.get_active_material(0).albedo_texture = cabl
