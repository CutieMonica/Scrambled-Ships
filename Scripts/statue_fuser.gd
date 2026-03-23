extends Node3D

@export var statue_position : int

@export var item_name : String
@export var item_type : String = "Statue"
@export var tooltip : String 
@export var description : String 
@export var rarity : String 

var moving_to_target : bool = false

var in_shop : bool = true

var statue_top : PackedScene

var statue_top_instance : Node

var statue_bottom : PackedScene

var statue_bottom_instance : Node

var statue_top_rarity : int

var statue_bottom_rarity : int


func combine_statue() -> void:
	statue_bottom_instance = GameManager.statue_bottom_choice
	statue_top_instance = GameManager.statue_bottom_choice
	statue_bottom_instance.reparent(self)
	statue_top_instance.reparent(self)
	statue_top_instance.generate_value()
	statue_top_instance.update_text()

	item_name = statue_bottom_instance.item_name + " " + statue_top_instance.item_name
	tooltip = statue_top_instance.tooltip
	description = statue_top_instance.description + statue_bottom_instance.statue_tooltip
	var statue_bottom_rarity_label : String
	match statue_bottom_rarity:
		1: statue_bottom_rarity_label = "Common"
		2: statue_bottom_rarity_label = "Uncommon"
		3: statue_bottom_rarity_label = "Rare"
		4: statue_bottom_rarity_label = "Legendary"
		
	var statue_top_rarity_label : String
	match statue_top_rarity:
		1: statue_top_rarity_label = "Common"
		2: statue_top_rarity_label = "Uncommon"
		3: statue_top_rarity_label = "Rare"
		4: statue_top_rarity_label = "Legendary"
	
	rarity = str(statue_bottom_rarity_label) + " + " + str(statue_top_rarity_label)
	
func main_scene_rerolling() -> void:
	if statue_top_instance.trigger_condition == "Reroll":
		statue_top_instance.statue_activate()

func main_scene_round_started() -> void:
	if statue_top_instance.trigger_condition == "RoundStart":
		statue_top_instance.statue_activate()

func move_statue() -> void:
	var target_slot : int = get_tree().get_first_node_in_group("main").find_vacant_statue_slot()
	reparent(get_tree().get_first_node_in_group("main"))
	if target_slot != 0:
		statue_position = target_slot
		get_parent().in_play_statues.set(target_slot, self)
		in_shop = false
		get_parent().shop_to_statue_stand()
		await get_tree().create_timer(0.9).timeout
		position = Vector3(get_parent().statue_positions.get(target_slot).x, get_parent().statue_positions.get(target_slot).y + 20, get_parent().statue_positions.get(target_slot).z)
		rotation = Vector3.ZERO
		moving_to_target = true
		GameManager.statue_count += 1
		remove_from_group("awaiting_new_slot")
		await get_tree().create_timer(1.5).timeout
		get_parent().statue_stand_to_shop()
		moving_to_target = false
		return

func _process(delta: float) -> void:
	if moving_to_target:
		position = lerp(position, get_parent().statue_positions.get(statue_position), delta * 8)
	else: pass
