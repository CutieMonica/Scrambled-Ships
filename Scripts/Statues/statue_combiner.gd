extends Node3D

var statue_top

var statue_top_instance

var statue_bottom

var statue_bottom_instance

#statue models
var wolf = load("uid://bwhv5cg85yfkq")
var sisyphus = load("res://Scenes/Statues/Models/sisyphus.tscn")

var common_statues : Dictionary = {
	1: wolf,
	2: sisyphus
	}
	
#statue bases
var statue_base_addition = load("uid://c64vl8ofj38lu")
var state_base_subtraction = load("uid://bsijpipthoih6")

var common_bases : Dictionary = {
	1: statue_base_addition,
	2: state_base_subtraction
}

func _ready() -> void:
	create_statue()

func create_statue():
	var random_statue_base_choice : int = GameManager.rng_statues.randi_range(1, common_bases.size())
	statue_bottom = common_bases.get(random_statue_base_choice)
	statue_bottom_instance = statue_bottom.instantiate()
	add_child(statue_bottom_instance)
	statue_bottom_instance.name = "Base" + str(statue_bottom_instance.statue_type)
	
	var random_statue_top_choice : int = GameManager.rng_statues.randi_range(1, common_statues.size())
	statue_top = common_statues.get(random_statue_top_choice)
	statue_top_instance = statue_top.instantiate()
	add_child(statue_top_instance)
	statue_top_instance.name = "Base" + str(statue_top_instance.statue_name)
	
	statue_bottom_instance.statue_base_logic.name_change(str(statue_top_instance.statue_name))
	statue_bottom_instance.create_value()
	statue_top_instance.statue_model_logic.color_shift(str(statue_bottom_instance.color))
	statue_top_instance.generate_value()
	statue_top_instance.update_text()

func _on_main_scene_rerolling() -> void:
	if statue_top_instance.trigger_condition == "Reroll":
		statue_top_instance.statue_activate()


func _on_main_scene_round_started() -> void:
	if statue_top_instance.trigger_condition == "RoundStart":
		statue_top_instance.statue_activate()
