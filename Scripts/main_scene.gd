extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var die_spawned : int = 0

var max_die : int = 5
var max_cards : int = 5
var max_statues : int = 4

var consecutive_rolls : int = 0
var next_card : int = 0
var watching_coins : bool = false
var statues_created : int = 0

var choosing_new_die : bool = false
var choosing_new_statue : bool = false
var choosing_new_card : bool = false

var statue_top_choice : Node3D
var statue_bottom_choice : Node3D

var basic_d6 := preload("res://Scenes/dice/Basicd_6.tscn")

var boat := load("uid://dgbnt6hnb02c8")
var city := load("uid://dq38n88cf8h1j")
var current_environment : Node

var card_instance : Node
var dice_instance : Node
var prev_die : int = 0
var between_rounds : bool = false
#var placeholdersong := preload("res://Assets/Music/Tabletop Jazz Cafe.ogg")

var reroll_coin : PackedScene = preload("res://Scenes/gold_coin.tscn")
var reroll_coin_instance : Node
var money_coin : PackedScene = preload("res://Scenes/currency_gold_coin.tscn")
var money_coin_instance : Node
var cards_hovered : bool = false
var cards_highlighted : bool = false

var dice_shop_slots_unlocked : int = 3
var ticket_shop_slots_unlocked : int = 6
var statue_shop_slots_unlocked : int = 8
var card_shop_slots_unlocked : int = 11

@onready var random_money_buffer: Timer = $RandomMoneyBuffer
@onready var lid_collider_delay: Timer = $LidColliderDelay
@onready var zoom_delay: Timer = $ZoomDelay
@onready var card_hover_detection: Area3D = $CardHoverDetection
@onready var card_outline: MeshInstance3D = $CardOutline
@onready var card_animations: AnimationPlayer = $CardAnimations
@onready var card_exit_detect: Area3D = $CardExitDetect
@onready var card_exit_collider: CollisionShape3D = $CardExitDetect/CardExitCollider
@onready var lighting_shift: AnimationPlayer = $LightingShift


@onready var target_score_display: Node3D = $TargetScoreDisplay
@onready var round_score_buffer: Timer = $RoundScoreBuffer

@onready var shop_overlays: Control = $ShopOverlays

@onready var random_coin_buffer: Timer = $RandomCoinBuffer
@onready var main_scene: Node3D = $"."
@onready var dice_cup: Node3D = $DiceCup
@onready var camera_movement: AnimationPlayer = $CameraMovement
@onready var dice_box: Node3D = $DiceBox
@onready var score_sheet: Node3D = $ScoreSheet
@onready var radio: Node3D = %Radio

@onready var current_dice_paper: Node3D = $CurrentDicePaper
@onready var mesh_instance_3d: MeshInstance3D = $Camera3D/MeshInstance3D
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var omni_light_3d_2: OmniLight3D = $OmniLight3D2
@onready var spot_light_3d_3: SpotLight3D = $SpotLight3D3
@onready var spot_light_3d_2: SpotLight3D = $SpotLight3D2
@onready var spot_light_3d_4: SpotLight3D = $SpotLight3D4

@onready var camerabuffer: Timer = $Camerabuffer
@onready var exit_card_outline: MeshInstance3D = $ExitCardOutline
@onready var shop_box: Node3D = $ShopBox
@onready var statue_stand: Node3D = $StatueStand

@onready var card_placement_ref_1: Node3D = $CardPlacementRef1
@onready var card_placement_ref_2: Node3D = $CardPlacementRef2
@onready var card_placement_ref_3: Node3D = $CardPlacementRef3
@onready var card_placement_ref_4: Node3D = $CardPlacementRef4
@onready var card_placement_ref_5: Node3D = $CardPlacementRef5
@onready var card_placement_ref_6: Node3D = $CardPlacementRef6
@onready var card_placement_ref_7: Node3D = $CardPlacementRef7

@onready var dice_shop_placement_1: Node3D = $ShopPlacementReferences/DiceShopPlacement1
@onready var dice_shop_placement_2: Node3D = $ShopPlacementReferences/DiceShopPlacement2
@onready var dice_shop_placement_3: Node3D = $ShopPlacementReferences/DiceShopPlacement3
@onready var dice_shop_placement_4: Node3D = $ShopPlacementReferences/DiceShopPlacement4
@onready var dice_shop_placement_5: Node3D = $ShopPlacementReferences/DiceShopPlacement5
@onready var ticket_shop_placement: Node3D = $ShopPlacementReferences/TicketShopPlacement
@onready var ticket_shop_placement_2: Node3D = $ShopPlacementReferences/TicketShopPlacement2
@onready var statue_shop_placement_1: Node3D = $ShopPlacementReferences/StatueShopPlacement1
@onready var statue_shop_placement_2: Node3D = $ShopPlacementReferences/StatueShopPlacement2
@onready var card_shop_placement_1: Node3D = $ShopPlacementReferences/CardShopPlacement1
@onready var card_shop_placement_2: Node3D = $ShopPlacementReferences/CardShopPlacement2
@onready var card_shop_placement_3: Node3D = $ShopPlacementReferences/CardShopPlacement3
@onready var dice_generator_1: Node3D = $ShopPlacementReferences/DiceShopPlacement1/DiceGenerator1
@onready var dice_generator_2: Node3D = $ShopPlacementReferences/DiceShopPlacement2/DiceGenerator2
@onready var dice_generator_3: Node3D = $ShopPlacementReferences/DiceShopPlacement3/DiceGenerator3
@onready var dice_generator_4: Node3D = $ShopPlacementReferences/DiceShopPlacement4/DiceGenerator4
@onready var dice_generator_5: Node3D = $ShopPlacementReferences/DiceShopPlacement5/DiceGenerator5

@onready var shop_placement_collider_1: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea1/ShopPlacementCollider1
@onready var shop_placement_collider_2: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea2/ShopPlacementCollider2
@onready var shop_placement_collider_3: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea3/ShopPlacementCollider3
@onready var shop_placement_collider_4: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea4/ShopPlacementCollider4
@onready var shop_placement_collider_5: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea5/ShopPlacementCollider5
@onready var shop_placement_collider_6: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea6/ShopPlacementCollider6
@onready var shop_placement_collider_7: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea7/ShopPlacementCollider7
@onready var shop_placement_collider_8: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea8/ShopPlacementCollider8
@onready var shop_placement_collider_9: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea9/ShopPlacementCollider9
@onready var shop_placement_collider_10: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea10/ShopPlacementCollider10
@onready var shop_placement_collider_11: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea11/ShopPlacementCollider11
@onready var shop_placement_collider_12: CollisionShape3D = $ShopPlacementReferences/ShopPlacementArea12/ShopPlacementCollider12

@onready var statue_placement_ref_1: Node3D = $StatueStand/StatuePlacementRef1
@onready var statue_placement_ref_2: Node3D = $StatueStand/StatuePlacementRef2
@onready var statue_placement_ref_3: Node3D = $StatueStand/StatuePlacementRef3
@onready var statue_placement_ref_4: Node3D = $StatueStand/StatuePlacementRef4
@onready var statue_placement_ref_5: Node3D = $StatueStand/StatuePlacementRef5
@onready var statue_placement_ref_6: Node3D = $StatueStand/StatuePlacementRef6

@onready var statue_combiner_top_1: Node3D = $StatueCombinerStuff/StatueCombinerTop1
@onready var statue_combiner_top_2: Node3D = $StatueCombinerStuff/StatueCombinerTop2
@onready var statue_combiner_bottom_1: Node3D = $StatueCombinerStuff/StatueCombinerBottom1
@onready var statue_combiner_bottom_2: Node3D = $StatueCombinerStuff/StatueCombinerBottom2
@onready var statue_final_product_area: Node3D = $StatueFinalProductArea

@onready var dialogue_player: AnimationPlayer = $DialogueHandler/DialoguePlayer

@onready var statue_combiner_stuff: Node3D = $StatueCombinerStuff
@onready var dealer: Node3D = $Dealer


var chosen_dice : Dictionary = {
	1: basic_d6,
	2: basic_d6,
	3: basic_d6,
	4: basic_d6,
	5: basic_d6,
	6: null,
	7: null
}

var in_play_dice_instances : Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null
}

@export var stored_dice : Dictionary = {
	1: "false",
	2: "false",
	3: "false",
	4: "false",
	5: "false",
	6: null,
	7: null,
}

@export var card_placement_references : Dictionary = {
	1:
		card_placement_ref_1,
	2:
		card_placement_ref_2,
	3:
		card_placement_ref_3,
	4:
		card_placement_ref_4,
	5:
		card_placement_ref_5,
	6:
		card_placement_ref_6,
	7:
		card_placement_ref_7
}

@export var card_deck : Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null
}

@export var in_play_statues : Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null
}

@export var statue_positions : Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null
}

@export var shop_items : Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null,
	11: null,
	12: null
}

@export var shop_prices : Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null,
	11: null,
	12: null
}

var shop_placement_references : Dictionary = {}

var current_shop_area : Area3D

@export var reroll_coins : Dictionary = {}

@export var money_coins : Dictionary = {}

func _process(_delta: float) -> void:
	if cards_hovered == true and InputHandler.actionable and GameManager.card_count > 0 and !cards_highlighted:
		highlight_cards()
		 

func performance_switch() -> void:
	if GameManager.performance_mode:
		await get_tree().process_frame
		mesh_instance_3d.visible = false
		omni_light_3d.shadow_enabled = false
		omni_light_3d_2.shadow_enabled = false
		spot_light_3d_2.shadow_enabled = false
		spot_light_3d_3.shadow_enabled = false
		spot_light_3d_4.shadow_enabled = false
	if !GameManager.performance_mode:
		await get_tree().process_frame
		mesh_instance_3d.visible = true
		

		#omni_light_3d.shadow_enabled = true
		#omni_light_3d_2.shadow_enabled = true
		spot_light_3d_2.shadow_enabled = true
		spot_light_3d_3.shadow_enabled = true
		

func remove_dice(dice_position : int) -> void:
	chosen_dice.set(dice_position, null)
	in_play_dice_instances.set(dice_position, null)
	stored_dice.set(dice_position, null)
	GameManager.dice_amount -= 1
	GameManager.dice_numbers.set(dice_position, null)
	
func remove_card(card_position : int) -> void:
	card_deck.set(card_position, null)
	if InputHandler.hovered_object == "card" + str(card_position):
		InputHandler.hovered_object = "none"
	GameManager.card_count -= 1
	
func give_extra_rerolls(amount : int) -> void:
	for i in amount:
		GameManager.rolls += 1
		var n : int = reroll_coins.size()
		reroll_coins.get_or_add(n, reroll_coin)
		reroll_coin_instance = reroll_coins.get(n).instantiate()
		reroll_coins.set(n, reroll_coin_instance)
		reroll_coin_instance.name = "Coin" + str(n)
		reroll_coin_instance.coin_number = n + 1
		reroll_coin_instance.position.y = GameManager.rng.randf_range(11, 13)
		reroll_coin_instance.position.x = GameManager.rng.randf_range(10.5, 12.5)
		reroll_coin_instance.position.z = GameManager.rng.randf_range(2.5, 4.5)
		add_child(reroll_coin_instance)

func give_extra_money(amount : int) -> void:
	for i in amount:
		var random_buffer_time : float = GameManager.rng.randf_range(0.1, 0.2)
		random_money_buffer.wait_time = random_buffer_time
		random_money_buffer.start()
		await random_money_buffer.timeout
		GameManager.current_money += 1
		var n : int = money_coins.size()
		money_coins.get_or_add(n, money_coin)
		money_coin_instance = money_coins.get(n).instantiate()
		money_coins.set(n, money_coin_instance)
		money_coin_instance.name = "MoneyCoin" + str(n)
		money_coin_instance.coin_number = n + 1
		money_coin_instance.position.y = GameManager.rng.randf_range(15, 16)
		money_coin_instance.position.x = GameManager.rng.randf_range(15.3, 15.8)
		money_coin_instance.position.z = GameManager.rng.randf_range(-3.65, -3.3)
		add_child(money_coin_instance)
		
func spawn_coins() -> void:
	for n in GameManager.max_rolls:
		var random_buffer_time : float = GameManager.rng.randf_range(0.05, 0.1)
		random_coin_buffer.wait_time = random_buffer_time
		random_coin_buffer.start()
		await random_coin_buffer.timeout
		reroll_coins.set(n, reroll_coin)
		reroll_coin_instance = reroll_coins.get(n).instantiate()
		reroll_coins.set(n, reroll_coin_instance)
		reroll_coin_instance.name = "Coin" + str(n)
		reroll_coin_instance.coin_number = n + 1
		reroll_coin_instance.position.y = GameManager.rng.randf_range(11, 13)
		reroll_coin_instance.position.x = GameManager.rng.randf_range(10.5, 12.5)
		reroll_coin_instance.position.z = GameManager.rng.randf_range(2.5, 4.5)
		add_child(reroll_coin_instance)
		GameManager.rolls += 1
	

func spawn_money() -> void:
	for i in GameManager.money_due:
		var random_buffer_time : float = GameManager.rng.randf_range(0.1, 0.2)
		random_money_buffer.wait_time = random_buffer_time
		random_money_buffer.start()
		await random_money_buffer.timeout
		GameManager.current_money += 1
		var n : int = money_coins.size()
		money_coins.get_or_add(n, money_coin)
		money_coin_instance = money_coins.get(n).instantiate()
		money_coins.set(n, money_coin_instance)
		money_coin_instance.name = "MoneyCoin" + str(n)
		money_coin_instance.coin_number = n + 1
		money_coin_instance.position.y = GameManager.rng.randf_range(15, 16)
		money_coin_instance.position.x = GameManager.rng.randf_range(15.3, 15.8)
		money_coin_instance.position.z = GameManager.rng.randf_range(-3.65, -3.3)
		add_child(money_coin_instance)
		if watching_coins == true:
			if GameManager.rolls > 0:
				GameManager.update_rolls_count(-1)
	GameManager.money_due = 0
	if watching_coins == true and GameManager.dialogue_seen.get(2) == true:
		random_money_buffer.wait_time = 1.0
		random_money_buffer.start()
		await random_money_buffer.timeout
		play_coins_to_shop()

func round_start() -> void:
	statue_stand.mouse_box_on()
	get_tree().call_group("statues", "main_scene_round_started")
	spawn_coins()
	if !GameManager.is_postgame and GameManager.current_round < 9:
		dealer.phase_shift()
		current_environment.play_environment_shift()
		lighting_shift.play("Round" + str(GameManager.current_round))
	for i : int in stored_dice.size() + 1:
		if stored_dice.get(i) != null:
			stored_dice.set(i, "false")
	if GameManager.current_round != 1:
		shop_to_default()
		score_sheet.reset_everything()
		camerabuffer.wait_time = 1
		between_rounds = false
		score_sheet.highlighter.play_backwards("Clicked")
		score_sheet.unhighlight_box()
		get_tree().call_group("stored_dice", "return_to_box")
		GameManager.reset_dice_resting()
		InputHandler.current_reroll_state = 0
		InputHandler.actionable = true
		camerabuffer.wait_time = 1
		camerabuffer.start()
		await camerabuffer.timeout
		give_extra_rerolls(1)
		score_sheet.inside_sheet = false
		score_sheet.hovered_category = "none"
		reload()

func _ready() -> void:
	environment_check()
	InputHandler.main_scene_entered()
	performance_switch()
	if GameManager.dialogue_seen.get(1) == false:
		dialogue_player.opening_tutorial_dialogue()
		camera_movement.play("Default_FirstTime")
	if GameManager.dialogue_seen.get(1) == true:
		camera_movement.play("Default")
	round_start()
	card_placement_references = {
	1:
		card_placement_ref_1,
	2:
		card_placement_ref_2,
	3:
		card_placement_ref_3,
	4:
		card_placement_ref_4,
	5:
		card_placement_ref_5,
	6:
		card_placement_ref_6,
	7:
		card_placement_ref_7
	}
	
	shop_placement_references = {
		1: dice_shop_placement_1,
		2: dice_shop_placement_2,
		3: dice_shop_placement_3,
		4: dice_shop_placement_4,
		5: dice_shop_placement_5,
		6: ticket_shop_placement,
		7: ticket_shop_placement_2,
		8: statue_shop_placement_1,
		9: statue_shop_placement_2,
		10: card_shop_placement_1,
		11: card_shop_placement_2,
		12: card_shop_placement_3
	}
	
	statue_positions = {
		1: statue_placement_ref_1.global_position,
		2: statue_placement_ref_2.global_position,
		3: statue_placement_ref_3.global_position,
		4: statue_placement_ref_4.global_position,
		5: statue_placement_ref_5.global_position,
		6: statue_placement_ref_6.global_position
	}
	
func environment_check() -> void:
	if GameManager.is_postgame:
		current_environment = city.instantiate()
	else:
		current_environment = boat.instantiate()
	add_child(current_environment)
	
func _on_timer_timeout() -> void:
	if die_spawned != max_die:
		die_spawned += 1
		dice_spawner(die_spawned)
		
func dice_spawner(dice_position : int) -> void:
	if chosen_dice.get(dice_position) == null:
		return
	dice_instance = chosen_dice.get(dice_position).instantiate()
	in_play_dice_instances.set(dice_position, dice_instance)
	dice_instance.name = "Die" + str(dice_position)
	dice_instance.position.y = GameManager.rng.randf_range(11, 13)
	dice_instance.position.x = GameManager.rng.randf_range(-4.5, 4.5)
	dice_instance.position.z = GameManager.rng.randf_range(-4.5, 4.5)
	stored_dice.set(dice_instance.dice_position, "false")
	add_child(dice_instance)
	dice_instance.dice_logic.adjust_number(dice_position)
	dice_instance.dice_logic.just_spawned = false
	
func card_spawner(card_position : int) -> void:
	card_instance = card_deck.get(card_position).instantiate()
	card_deck.set(card_position, card_instance)
	card_instance.name = "Card" + str(card_position)
	card_instance.position = card_placement_references[card_position].position
	card_instance.rotation = card_placement_references[card_position].rotation
	card_instance.scale = card_placement_references[card_position].scale
	add_child(card_instance)
	card_instance.card_logic.card_position = card_position
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "cup_reloading":
		InputHandler.current_reroll_state = 2
		get_tree().call_group("dice_logic", "drop")
		zoom_delay.start()
		await zoom_delay.timeout
		camera_movement.play("zoom_on_box")
		animation_player.play("cup_shake")
		get_tree().call_group("dice_logic", "shake")
		lid_collider_delay.start()
		await lid_collider_delay.timeout
		dice_cup.lid_collider.disabled = false
		InputHandler.current_reroll_state = 3
		
func roll_used() -> void:
	if reroll_coins.get(GameManager.rolls) != null:
		reroll_coins.get(GameManager.rolls).i_must_go_now()
		reroll_coins.erase(GameManager.rolls)
	
func coins_spent(amount : int) -> void:
	for n in amount:
		if money_coins.get(money_coins.size() - 1) != null:
			money_coins.get(money_coins.size() - 1).i_must_go_now()
			money_coins.erase(money_coins.size() - 1)
	
func become_actionable() -> void:
	InputHandler.actionable = true
		
func become_inactionable() -> void:
	InputHandler.actionable = false
		
func reload() -> void:
	if InputHandler.current_reroll_state == 0 and GameManager.dice_resting and stored_dice.find_key("false") != null and GameManager.rolls > 0:
		become_inactionable()
		GameManager.reset_dice_resting()
		InputHandler.current_reroll_state = 1
		animation_player.play("cup_reloading")
		get_tree().call_group("dice_logic", "start_recall")
		get_tree().call_group("stored_dice", "update_ui")
		GameManager.update_rolls_count(-1)
	if InputHandler.current_reroll_state == 3:
		GameManager.has_pressed_release = true
		InputHandler.current_reroll_state = 4
		InputHandler.actionable = true
		consecutive_rolls += 1
		if consecutive_rolls == 4:
			dialogue_player.spamming_rerolls_dialogue()
		get_tree().call_group("statues", "main_scene_rerolling")
		
func focus_a_die(focused_die : int) -> void:
	if prev_die != 0:
		in_play_dice_instances.get(prev_die).dice_logic.losefocusdie()
	in_play_dice_instances.get(focused_die).focusdie()

func zoom_on_score_sheet() -> void:
	camera_movement.play("DefaultToSheet")
	InputHandler.actionable = false
	camerabuffer.wait_time = 0.9
	score_sheet.can_leave = false
	camerabuffer.start()
	await camerabuffer.timeout
	InputHandler.hovered_object = "scoresheet"
	score_sheet.can_leave = true
	InputHandler.actionable = true

func zoom_out_score_sheet() -> void:
	camera_movement.play_backwards("DefaultToSheet")
	InputHandler.actionable = false
	camerabuffer.wait_time = 0.9
	camerabuffer.start()
	await camerabuffer.timeout
	InputHandler.actionable = true

func zoom_in_timer() -> void:
	camera_movement.play("default_to_counter")
	
func zoom_out_timer() -> void:
	camera_movement.play_backwards("default_to_counter")

func zoom_on_statue() -> void:
	camera_movement.play("default_to_statues")
	
func zoom_out_statue() -> void:
	camera_movement.play_backwards("default_to_statues")


func _on_card_hover_detection_mouse_entered() -> void:
	cards_hovered = true
	if InputHandler.actionable and GameManager.card_count > 0:
		highlight_cards()

func _on_card_hover_detection_mouse_exited() -> void:
	cards_hovered = false
	unhighlight_cards()

func highlight_cards() -> void:
	InputHandler.hovered_object = "cards"
	card_outline.visible = true
	cards_highlighted = true
	
func unhighlight_cards() -> void:
	if InputHandler.hovered_object == "cards":
		InputHandler.hovered_object = "none"
	card_outline.visible = false
	cards_highlighted = false
	
func pull_up_cards() -> void:
	card_animations.play("pullupcards")
	camerabuffer.wait_time = 0.3
	camerabuffer.start()
	await camerabuffer.timeout
	if !choosing_new_card:
		GameManager.viewing_cards = true
	else:
		GameManager.choosing_new_cards = true
	
func pull_down_cards() -> void:
	card_animations.play_backwards("pullupcards")
	GameManager.viewing_cards = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_spawn_card"):
		next_card += 1
		get_tree().get_first_node_in_group("main").card_spawner(next_card)

func _on_card_exit_detect_mouse_entered() -> void:
	if !GameManager.choosing_new_cards:
		InputHandler.hovered_object = "exitcards"
		exit_card_outline.visible = true

func _on_card_exit_detect_mouse_exited() -> void:
	exit_card_outline.visible = false
	if InputHandler.hovered_object == "exitcards":
		InputHandler.hovered_object = "none"
		
		
func _on_card_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pullupcards":
		card_exit_collider.disabled = !card_exit_collider.disabled
		if card_exit_collider.disabled == true:
			exit_card_outline.visible = false
			for i : int in card_deck.size():
					if card_deck.get(i) != null:
						card_deck.get(i).card_logic.move_along_now = false

func find_vacant_dice_slot() -> int:
	var current_lowest_slot : int = 0
	for i in max_die + 1:
		print("scanning dice slot " + str(i))
		if in_play_dice_instances.get(i) == null:
			if current_lowest_slot == 0:
				current_lowest_slot = i
	return current_lowest_slot
	
	
func find_vacant_statue_slot() -> int:
	var current_lowest_slot : int = 0
	for i in max_statues + 1:
		if in_play_statues.get(i) == null:
			if current_lowest_slot == 0:
				current_lowest_slot = i
	return current_lowest_slot
	
	
func find_vacant_card_slot() -> int:
	var current_lowest_slot : int = 0
	for i in max_cards + 1:
		if card_deck.get(i) == null:
			if current_lowest_slot == 0:
				current_lowest_slot = i
	return current_lowest_slot


func ending_counter_camera() -> void:
	between_rounds = true
	InputHandler.actionable = false
	statue_stand.mouse_box_off()
	if score_sheet.inside_sheet:
		camera_movement.play("sheet_to_counter")
	if !score_sheet.inside_sheet:
		camera_movement.play("default_to_counter")
	round_score_buffer.start()
	await round_score_buffer.timeout
	target_score_display.play_random_death_voice()


func play_sheet_to_counter() -> void:
	between_rounds = true
	InputHandler.actionable = false
	statue_stand.mouse_box_off()
	if score_sheet.inside_sheet:
		camera_movement.play("sheet_to_counter")
	if !score_sheet.inside_sheet:
		camera_movement.play("default_to_counter")
	round_score_buffer.start()
	await round_score_buffer.timeout
	target_score_display.get_new_target_score()


func get_rick_quick_bitch() -> void:
	watching_coins = true
	camera_movement.play("end_of_round_counter_to_coins")
	
	spawn_money()
	
	
func play_coins_to_shop() -> void:
	watching_coins = false
	camera_movement.play("coins_to_shop")
	shop_box.play_shop_reload()
	update_money(0)

func shop_to_default() -> void:
	camera_movement.queue("shop_to_default")
	shop_box.temp_disable_exit_button()

func default_to_shop() -> void:
	camera_movement.queue("default_to_shop")
	shop_box.temp_disable_exit_button()
	shop_box.exit_button_can_be_enabled = true

func shop_to_card_deck() -> void:
	camera_movement.queue("shop_to_card_deck")
	shop_box.temp_disable_exit_button()
	
func card_deck_to_shop() -> void:
	camera_movement.play_backwards("shop_to_card_deck")
	shop_box.temp_disable_exit_button()
	shop_box.exit_button_can_be_enabled = true
	
func shop_to_statue_stand() -> void:
	camera_movement.queue("shop_to_statues")
	shop_box.temp_disable_exit_button()
	shop_box.exit_button_can_be_enabled = true

func statue_stand_to_statue_fusion() -> void:
	camera_movement.play("statues_to_combiner")
	
func statue_fusion_zoom() -> void:
	camera_movement.play("combiner_pan_zoom")
	
func statue_fusion_to_statue_stand() -> void:
	camera_movement.play("combiner_pan_zoom_to_statues")

func statue_stand_to_shop() -> void:
	camera_movement.play_backwards("shop_to_statues")
	dialogue_player.no_dialogue()
	shop_box.temp_disable_exit_button()
	shop_box.exit_button_can_be_enabled = true
	enable_all_shop_areas()

func backwards_default() -> void:
	camera_movement.play_backwards("Default")
	InputHandler.in_game = false
	InputHandler.actionable = false

func generate_shop() -> void:
	get_tree().call_group("dice_gen", "create_dice")
	get_tree().call_group("ticket_gen", "generate_ticket")
	get_tree().call_group("statue_gen", "spawn_statue")
	get_tree().call_group("card_gen", "spawn_card")
	

func shop_to_dice_storage() -> void:
	camera_movement.queue("shop_to_dice_storage")
	
func dice_storage_to_shop() -> void:
	camera_movement.play_backwards("shop_to_dice_storage")
	dialogue_player.no_dialogue()
	enable_all_shop_areas()
	shop_box.temp_disable_exit_button()
	shop_box.exit_button_can_be_enabled = true

func update_money(amount : int) -> void:
	coins_spent(amount)
	GameManager.current_money -= amount
	shop_box.money_tracker.update_money()

func clear_shop_items() -> void:
	for i in shop_items.size() + 1:
		if shop_items.get(i) != null and shop_items.get(i).item_type != "Ticket":
			shop_items.get(i).queue_free()

func shop_slot_zoom(slot : int) -> void:
	disable_all_shop_areas()
	camera_movement.play("shop_to_slot_" + str(slot))
	shop_overlays.slide_in_UI(shop_items.get(slot).item_name, shop_items.get(slot).tooltip, shop_items.get(slot).rarity, shop_items.get(slot).description, slot)
	shop_box.disable_exit_button() 

func shop_slot_zoom_out(slot : int) -> void:
	camera_movement.play_backwards("shop_to_slot_" + str(slot))
	camerabuffer.wait_time = 0.25
	camerabuffer.start()
	await camerabuffer.timeout
	if !choosing_new_die and !choosing_new_card:
		enable_all_shop_areas()
	if choosing_new_die or choosing_new_card:
		dialogue_player.play_dice_selection_dialogue()
		

func reset_storage_slots() -> void:
	for i in stored_dice.size() + 1:
		if stored_dice.get(i) == "true":
			stored_dice.set(i, "false")

func disable_all_shop_areas() -> void:
	shop_placement_collider_1.disabled = true
	shop_placement_collider_2.disabled = true
	shop_placement_collider_3.disabled = true
	shop_placement_collider_4.disabled = true
	shop_placement_collider_5.disabled = true
	shop_placement_collider_6.disabled = true
	shop_placement_collider_7.disabled = true
	shop_placement_collider_8.disabled = true
	shop_placement_collider_9.disabled = true
	shop_placement_collider_10.disabled = true
	shop_placement_collider_11.disabled = true
	shop_placement_collider_12.disabled = true

func enable_all_shop_areas() -> void:
	shop_placement_collider_1.disabled = false
	shop_placement_collider_2.disabled = false
	shop_placement_collider_3.disabled = false
	shop_placement_collider_4.disabled = false
	shop_placement_collider_5.disabled = false
	shop_placement_collider_6.disabled = false
	shop_placement_collider_7.disabled = false
	shop_placement_collider_8.disabled = false
	shop_placement_collider_9.disabled = false
	shop_placement_collider_10.disabled = false
	shop_placement_collider_11.disabled = false
	shop_placement_collider_12.disabled = false

func recall_all_dice() -> void:
	get_tree().call_group("dice_logic", "end_of_round_reset")

func ending_fade_out() -> void:
	camera_movement.play("counter_to_dealer_losing")
	radio.play_round_end_song()
	dialogue_player.in_death_we_part()

func back_to_title(state : int) -> void:
	GlobalMusicPlayer.fade_out()
	GlobalMusicPlayer.ambience_target = 0
	match state:
		1:
			camera_movement.play("ending_fade")
		2:
			camera_movement.play("ending_fade_2")

func _on_camera_movement_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ending_fade" or anim_name == "ending_fade_2":
		GlobalMusicPlayer.start_title_song()
		GlobalMusicPlayer.fade_in()
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
		
