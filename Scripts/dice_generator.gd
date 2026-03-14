extends Node3D

var rarity : Array = [1, 2, 3, 4]
@export var weight_probabilities : Array = [10, 5, 2, 0.5]

@export var shop_position : int = 1

@export var dice_rarity : String
@export var dice_choice : PackedScene
@export var dice_instance : Node
@export var dice_price : int

#dice
var basic_d6 : PackedScene = load("res://Scenes/dice/Basicd_6.tscn")
var cursed_die : PackedScene = load("res://Scenes/dice/CursedDice.tscn")
var leaded_die : PackedScene = load("res://Scenes/dice/LeadedDice.tscn")
var sky_die : PackedScene = load("res://Scenes/dice/SkyDie.tscn")
var weighted_die : PackedScene = load("res://Scenes/dice/weighteddie.tscn")
var inscrybed_die : PackedScene = load("uid://cvdes1pfuas6d")
var jelly_die : PackedScene = preload("uid://vlnditpvpyti")

var common_dice : Dictionary = {
	1: basic_d6,
	2: cursed_die,
	3: leaded_die
	}
	
var uncommon_dice : Dictionary = {
	1: sky_die,
	2: jelly_die
}

var rare_dice : Dictionary = {
	1: weighted_die
}

var legendary_dice : Dictionary = {
	1: inscrybed_die
}

func create_dice() -> void:
	print("Creating_dice")
	if get_parent().get_parent().get_parent().dice_shop_slots_unlocked < shop_position:
		return
	var random_weight := GameManager.rng_shops
	var random_value : int = rarity[random_weight.rand_weighted(weight_probabilities)]
	match random_value:
		1:
			dice_rarity = "common"
			dice_choice = common_dice.get(GameManager.rng_shops.randi_range(1, common_dice.size()))
			dice_price = 2
		2:
			dice_rarity = "uncommon"
			dice_choice = uncommon_dice.get(GameManager.rng_shops.randi_range(1, uncommon_dice.size()))
			dice_price = 4
		3:
			dice_rarity = "rare"
			dice_choice = rare_dice.get(GameManager.rng_shops.randi_range(1, rare_dice.size()))
			dice_price = 6
		4:
			dice_rarity = "legendary"
			dice_choice = legendary_dice.get(GameManager.rng_shops.randi_range(1, legendary_dice.size()))
			dice_price = 8
	dice_instance = dice_choice.instantiate()
	dice_instance.name = "Die" + str(shop_position)
	get_parent().price_tag.inflation_is_a_bitch(dice_price)
	get_parent().show_price()
	#dice_instance.position = Vector3.ZERO
	dice_instance.freeze = true
	#dice_instance.rotation = get_parent().rotation
	add_child(dice_instance)
	dice_instance.rotation = Vector3.ZERO
	get_parent().get_parent().get_parent().shop_items.set(shop_position, dice_instance)
	dice_instance.reparent(get_parent().get_parent().get_parent())
