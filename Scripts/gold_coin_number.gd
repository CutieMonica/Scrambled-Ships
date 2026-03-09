extends Node3D

@export var coin_number : int
@onready var gold_coin: RigidBody3D = $GoldCoin
@onready var hit_counter: Label3D = $HitCounter


func update_label():
	hit_counter.position = Vector3(gold_coin.position.x, gold_coin.position.y - 2, gold_coin.position.z)

func i_must_go_now():
	gold_coin.unfreeze()
	gold_coin.set_collision_layer_value(1, false)
	gold_coin.set_collision_layer_value(5, false)
	gold_coin.set_collision_mask_value(1, false)
	gold_coin.set_collision_mask_value(5, false)
	gold_coin.input_ray_pickable = false
	gold_coin.linear_velocity.y = 70
	gold_coin.angular_velocity.x = 40
	await get_tree().create_timer(0.3).timeout
	queue_free()
