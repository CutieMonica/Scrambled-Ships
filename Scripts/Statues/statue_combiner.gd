extends Node3D

@export var shop_slot : int = 0

@export var item_name : String
@export var item_type : String = "Statue"
@export var tooltip : String 
@export var description : String 
@export var rarity : String 

var in_shop : bool = true

var statue_top : PackedScene

var statue_top_instance : Node

var statue_bottom : PackedScene

var statue_bottom_instance : Node

var statue_top_rarity : int

var statue_bottom_rarity : int

var statue_price : int

#statue models
var wolf := load("uid://bwhv5cg85yfkq")
var sisyphus := load("res://Scenes/Statues/Models/sisyphus.tscn")

var common_statues : Dictionary = {
	1: wolf,
	2: sisyphus
	}
	
#statue bases
var statue_base_addition := load("uid://c64vl8ofj38lu")
var state_base_subtraction := load("uid://bsijpipthoih6")

var common_bases : Dictionary = {
	1: statue_base_addition,
	2: state_base_subtraction
}

func create_statue() -> void:
	var random_statue_base_choice : int = GameManager.rng_statues.randi_range(1, common_bases.size())
	statue_bottom = common_bases.get(random_statue_base_choice)
	statue_bottom_instance = statue_bottom.instantiate()
	add_child(statue_bottom_instance)
	statue_bottom_instance.name = "Base" + str(statue_bottom_instance.statue_type)
	
	var random_statue_top_choice : int = GameManager.rng_statues.randi_range(1, common_statues.size())
	statue_top = common_statues.get(random_statue_top_choice)
	statue_top_rarity = 1
	statue_top_instance = statue_top.instantiate()
	add_child(statue_top_instance)
	statue_top_instance.name = "Base" + str(statue_top_instance.statue_name)
	
	statue_bottom_instance.statue_base_logic.name_change(str(statue_top_instance.statue_name))
	statue_bottom_instance.create_value()
	statue_top_instance.statue_model_logic.color_shift(str(statue_bottom_instance.color))
	statue_top_instance.generate_value()
	statue_top_instance.update_text()
	
	statue_price = ((statue_bottom_rarity + statue_top_rarity) * 2)
	
	item_name = statue_bottom_instance.item_name + " " + statue_top_instance.item_name
	tooltip = statue_top_instance.tooltip
	description = statue_top_instance.description + statue_bottom_instance.statue_tooltip
	var statue_bottom_rarity_label : String
	match statue_bottom_rarity:
		1: "Common"
		2: "Uncommon"
		3: "Rare"
		4: "Legendary"
		
	var statue_top_rarity_label : String
	match statue_top_rarity:
		1: "Common"
		2: "Uncommon"
		3: "Rare"
		4: "Legendary"
	
	rarity = str(statue_bottom_rarity_label) + " + " + str(statue_top_rarity_label)
	
	get_parent().get_parent().price_tag.inflation_is_a_bitch(statue_price)
	get_parent().get_parent().show_price()
func main_scene_rerolling() -> void:
	if statue_top_instance.trigger_condition == "Reroll":
		statue_top_instance.statue_activate()

func main_scene_round_started() -> void:
	if statue_top_instance.trigger_condition == "RoundStart":
		statue_top_instance.statue_activate()
