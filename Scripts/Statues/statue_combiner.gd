extends Node3D

@export var shop_slot : int = 0

@export var statue_position : int

@export var item_name : String
@export var item_type : String = "Statue"
@export var tooltip : String 
@export var description : String 
@export var rarity : String 

@onready var statue_choice_area: Area3D = $StatueChoiceArea
@onready var statue_mouse_collider: CollisionShape3D = $StatueChoiceArea/StatueMouseCollider
@onready var statue_highlight: MeshInstance3D = $StatueHighlight
@onready var die_timer: Timer = $DieTimer
@onready var poof_particle: CPUParticles3D = $PoofParticle
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var activate_timer: Timer = $ActivateTimer

var moving_up : bool = false
var moving_to_new_base : bool = false
var deconstructing_former : bool = false

var deconstructing_newer : bool = false

var moving_to_target : bool = false

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
var paperweight := load("uid://dk4tm1lkctsbk")


var common_statues : Dictionary = {
	1: wolf,
	2: sisyphus
	}
	
var uncommon_statues : Dictionary = {
	1: paperweight
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
	var statue_top_rarity_choice : int = GameManager.rng_statues.randi_range(1, 5)
	if statue_top_rarity_choice < 4:
		var random_statue_top_choice : int = GameManager.rng_statues.randi_range(1, common_statues.size())
		statue_top = common_statues.get(random_statue_top_choice)
		statue_top_rarity = 1
	else:
		var random_statue_top_choice : int = GameManager.rng_statues.randi_range(1, uncommon_statues.size())
		statue_top = uncommon_statues.get(random_statue_top_choice)
		statue_top_rarity = 2
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
	
	get_parent().get_parent().price_tag.inflation_is_a_bitch(statue_price)
	get_parent().get_parent().show_price()
	
func disable_statue_choice_area() -> void:
	statue_mouse_collider.disabled = true

func enable_statue_choice_area() -> void:
	statue_mouse_collider.disabled = false
	
	
func redo_statue() -> void:
	get_tree().call_group("statues", "disable_statue_choice_area")
	audio_stream_player_3d.stream = SfxBank.poof_sound
	audio_stream_player_3d.volume_db = (-8 + randf_range(2, 3))
	audio_stream_player_3d.pitch_scale = (0 + randf_range(0.9, 1.2))
	audio_stream_player_3d.play()
	
	statue_bottom_instance.statue_base_logic.name_change(str(statue_top_instance.statue_name))
	statue_top_instance.statue_model_logic.color_shift(str(statue_bottom_instance.color))
	statue_top_instance.generate_value()
	statue_top_instance.update_text()
	
	statue_price = ((statue_bottom_rarity + statue_top_rarity) * 2)
	
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
	if statue_top_instance.trigger_condition == "Reroll" and !in_shop:
		activate_timer.wait_time = statue_position * 0.2
		activate_timer.start()
		await activate_timer.timeout
		statue_top_instance.statue_activate()

func main_scene_round_started() -> void:
	if statue_top_instance.trigger_condition == "RoundStart" and !in_shop:
		activate_timer.wait_time = statue_position * 0.2
		activate_timer.start()
		await activate_timer.timeout
		statue_top_instance.statue_activate()

func purchase_statue() -> void:
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
		shop_slot = target_slot
		return
	if target_slot == 0:
		in_shop = false
		add_to_group("awaiting_new_slot")
		get_parent().shop_to_statue_stand()
		get_parent().dialogue_player.play_statue_dialogue_1()
		get_parent().choosing_new_statue = true
		get_tree().call_group("statues", "enable_statue_choice_area")
		GameManager.combining_statues = true
		GameManager.combined_statue_2 = self
		await get_tree().create_timer(0.8).timeout
		statue_bottom_instance.statue_base_logic.name_change("
		" + str(statue_bottom_instance.item_name) + " Base
		Value: " + str(statue_bottom_instance.base_statue_value))
		rotation = Vector3.ZERO
		position = Vector3.ZERO
		deconstructing_newer = true
	
func statue_chosen() -> void:
	moving_up = true
	get_parent().statue_stand_to_statue_fusion()
	GameManager.combined_statue_1 = self
	get_tree().call_group("statues", "disable_statue_choice_area")
	await get_tree().create_timer(0.5).timeout
	statue_bottom_instance.statue_base_logic.name_change("
	" + str(statue_bottom_instance.item_name) + " Base
	Value: " + str(statue_bottom_instance.base_statue_value))
	moving_up = false
	deconstructing_former = true
	get_parent().statue_combiner_stuff.enable_statue_combiner_areas()
	get_parent().dialogue_player.play_statue_dialogue_2()
	
#func go_to_new_slot(slot : int) -> void:
	#adjust_number(slot)
	#get_parent().get_parent().chosen_dice.set(slot, get_parent().name)
	#get_parent().get_parent().in_play_dice_instances.set(slot, get_parent())
	#dice_position = slot
	
	#just_spawned = false
#	get_parent().global_position = Vector3.ZERO
	#get_parent().rotation = Vector3.ZERO
	#get_parent().freeze = false
	#end_of_round_reset()
	#remove_from_group("awaiting_new_slot")
	#GameManager.dice_amount += 1
	#await get_tree().create_timer(0.65).timeout
	#get_parent().get_parent().dice_storage_to_shop()

func _process(delta: float) -> void:
	if moving_up:
		position.y = lerp(position.y, position.y + 1, delta * 8)
	if moving_to_target:
		position = lerp(position, get_parent().statue_positions.get(statue_position), delta * 8)
	if deconstructing_former:
		statue_top_instance.global_position = lerp(statue_top_instance.global_position, get_parent().statue_combiner_top_1.global_position, delta * 8)
		statue_bottom_instance.global_position = lerp(statue_bottom_instance.global_position, get_parent().statue_combiner_bottom_1.global_position, delta * 8)
	if deconstructing_newer:
		statue_top_instance.global_position = lerp(statue_top_instance.global_position, get_parent().statue_combiner_top_2.global_position, delta * 8)
		statue_bottom_instance.global_position = lerp(statue_bottom_instance.global_position, get_parent().statue_combiner_bottom_2.global_position, delta * 8)
	if moving_to_new_base:
		statue_top_instance.position = lerp(statue_top_instance.position, Vector3.ZERO, delta * 8)
		statue_bottom_instance.position = lerp(statue_bottom_instance.position, Vector3.ZERO, delta * 8)
	else: pass


func _on_statue_choice_area_mouse_entered() -> void:
	print("statue_hovered")
	if GameManager.combining_statues:
		statue_highlight.visible = true
		InputHandler.hovered_object = "statue" + str(statue_position)

func _on_statue_choice_area_mouse_exited() -> void:
	statue_highlight.visible = false
	if InputHandler.hovered_object == "statue" + str(statue_position):
		InputHandler.hovered_object = "none"

func destroy_statue() -> void:
#	if statue_bottom_instance != null:
	#	statue_bottom_instance.poof_particle.emitting = true
	#if statue_top_instance != null:
	#	statue_top_instance.poof_particle.emitting = true
	moving_up = true
	get_parent().dialogue_player.no_dialogue()
	die_timer.wait_time = 0.8
	die_timer.start()
	await die_timer.timeout
	if statue_bottom_instance != null:
		statue_bottom_instance.queue_free()
	if statue_top_instance != null:
		statue_top_instance.queue_free()
	queue_free()

func flip_base() -> void:
	if statue_bottom_instance.statue_type == "Subtract":
		statue_bottom = common_bases.get(1)
	if statue_bottom_instance.statue_type == "Add":
		statue_bottom = common_bases.get(2)
	var new_statue_value : int = statue_bottom_instance.base_statue_value
	statue_bottom_instance.queue_free()
	statue_bottom_instance = statue_bottom.instantiate()
	add_child(statue_bottom_instance)
	statue_bottom_instance.name = "Base" + str(statue_bottom_instance.statue_type)
	
	statue_bottom_instance.statue_base_logic.name_change(str(statue_top_instance.statue_name))
	
	statue_bottom_instance.base_statue_value = new_statue_value
	match statue_bottom_rarity:
		1:
			statue_bottom_instance.label_3d.modulate = statue_bottom_instance.statue_base_logic.common_text_color
			statue_bottom_instance.label_3d.outline_modulate = statue_bottom_instance.statue_base_logic.common_text_outline_color
		2:
			statue_bottom_instance.label_3d.modulate = statue_bottom_instance.statue_base_logic.uncommon_text_color
			statue_bottom_instance.label_3d.outline_modulate = statue_bottom_instance.statue_base_logic.uncommon_text_outline_color
		3:
			statue_bottom_instance.label_3d.modulate = statue_bottom_instance.statue_base_logic.rare_text_color
			statue_bottom_instance.label_3d.outline_modulate = statue_bottom_instance.statue_base_logic.rare_text_outline_color
		4:
			statue_bottom_instance.label_3d.modulate = statue_bottom_instance.statue_base_logic.legendary_text_color
			statue_bottom_instance.label_3d.outline_modulate = statue_bottom_instance.statue_base_logic.legendary_text_outline_color

	statue_top_instance.statue_model_logic.color_shift(str(statue_bottom_instance.color))
	statue_top_instance.generate_value()
	statue_top_instance.update_text()
	
	item_name = statue_bottom_instance.item_name + " " + statue_top_instance.item_name
	description = statue_top_instance.description + statue_bottom_instance.statue_tooltip
