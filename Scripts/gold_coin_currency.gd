extends RigidBody3D

@export var coin_number : int
@onready var gold_coin: RigidBody3D = $"."
var values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
@export var weight_probabilities = [2, 2, 1, 0.7, 0.7, 0.7, 0.2, 0.2, 0.9, 0.9]
@onready var mesh: MeshInstance3D = $"Sketchfab_Scene/Sketchfab_model/4761e60571154708a3a5b48b4216d582_fbx/RootNode/bitcoin/bitcoin_Material_0"

var proximity_coins : Dictionary = {}

func _ready() -> void:
	var random_weight = GameManager.rng
	var random_value = values[random_weight.rand_weighted(weight_probabilities)]
	match random_value:
		1:
			mesh.get_surface_override_material(0).albedo_color = Color("fcb700")
		2:
			mesh.get_surface_override_material(0).albedo_color = Color("fc9500ff")
		3:
			mesh.get_surface_override_material(0).albedo_color = Color("fcd71eff")
		4:
			mesh.get_surface_override_material(0).albedo_color = Color("d6835eff")
		5:
			mesh.get_surface_override_material(0).albedo_color = Color("f9b669ff")
		6:
			mesh.get_surface_override_material(0).albedo_color = Color("bb5333ff")
		7:
			mesh.get_surface_override_material(0).albedo_color = Color("c5d3efff")
		8:
			mesh.get_surface_override_material(0).albedo_color = Color("8b9bbbff")
		9:
			mesh.get_surface_override_material(0).albedo_color = Color("cd9400ff")
		10:
			mesh.get_surface_override_material(0).albedo_color = Color("fcb458ff")


func honk_shoo_mimimi():
	print(gold_coin.linear_velocity.y)
	if gold_coin.sleeping or linear_velocity.y < 5 and linear_velocity.y > -5:
		gold_coin.freeze = true
	else:
		pass

func unfreeze():
	if gold_coin.sleeping:
		gold_coin.freeze = false

func i_must_go_now():
	gold_coin.freeze = false
	get_tree().call_group("currency", "unfreeze")
	#gold_coin.set_collision_layer_value(1, false)
	#gold_coin.set_collision_layer_value(5, false)
	#gold_coin.set_collision_mask_value(1, false)
	#gold_coin.set_collision_mask_value(5, false)
	gold_coin.linear_velocity.y = 70
	gold_coin.angular_velocity.x = 40
	await get_tree().create_timer(0.3).timeout
	queue_free()


func _on_timer_timeout() -> void:
	honk_shoo_mimimi()
