extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var die_spawned : int = 0
var max_die : int = 7
var next_card : int = 0
var watching_coins : bool = false

#all possible dice
var basic_d6 : PackedScene = preload("res://Scenes/dice/Basicd_6.tscn")
var cursed_die : PackedScene = load("res://Scenes/dice/CursedDice.tscn")
var leaded_die : PackedScene = load("res://Scenes/dice/LeadedDice.tscn")
var sky_die : PackedScene = load("res://Scenes/dice/SkyDie.tscn")
var weighted_die : PackedScene = load("res://Scenes/dice/weighteddie.tscn")
var inscrybed_die : PackedScene = load("uid://cvdes1pfuas6d")
var jelly_die : PackedScene = preload("uid://vlnditpvpyti")

#all possible cards
var bomb_card := preload("uid://dgpdr61xocghe")


var card_instance : Node
var dice_instance : Node
var prev_die : int = 0
#var placeholdersong := preload("res://Assets/Music/Tabletop Jazz Cafe.ogg")
var roll_with_it_music := load("res://Assets/Music/Roll with it (final).ogg")
var reroll_coin : PackedScene = preload("res://Scenes/gold_coin.tscn")
var reroll_coin_instance : Node
var money_coin : PackedScene = preload("res://Scenes/currency_gold_coin.tscn")
var money_coin_instance : Node

@onready var random_money_buffer: Timer = $RandomMoneyBuffer
@onready var lid_collider_delay: Timer = $LidColliderDelay
@onready var zoom_delay: Timer = $ZoomDelay
@onready var card_hover_detection: Area3D = $CardHoverDetection
@onready var card_outline: MeshInstance3D = $CardOutline
@onready var card_animations: AnimationPlayer = $CardAnimations
@onready var card_exit_detect: Area3D = $CardExitDetect
@onready var card_exit_collider: CollisionShape3D = $CardExitDetect/CardExitCollider

@onready var target_score_display: Node3D = $TargetScoreDisplay

@onready var random_coin_buffer: Timer = $RandomCoinBuffer
@onready var main_scene: Node3D = $"."
@onready var dice_cup: Node3D = $DiceCup
@onready var camera_movement: AnimationPlayer = $CameraMovement
@onready var dice_box: Node3D = $DiceBox
@onready var score_sheet: Node3D = $ScoreSheet
@onready var music_source: AudioStreamPlayer3D = $Boat/Radio/MusicSource
@onready var current_dice_paper: Node3D = $CurrentDicePaper
@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D
@onready var mesh_instance_3d: MeshInstance3D = $Camera3D/MeshInstance3D
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var omni_light_3d_2: OmniLight3D = $OmniLight3D2
@onready var spot_light_3d_3: SpotLight3D = $SpotLight3D3
@onready var spot_light_3d_2: SpotLight3D = $SpotLight3D2
@onready var camerabuffer: Timer = $Camerabuffer
@onready var exit_card_outline: MeshInstance3D = $ExitCardOutline

@onready var card_placement_ref_1: Node3D = $CardPlacementRef1
@onready var card_placement_ref_2: Node3D = $CardPlacementRef2
@onready var card_placement_ref_3: Node3D = $CardPlacementRef3
@onready var card_placement_ref_4: Node3D = $CardPlacementRef4
@onready var card_placement_ref_5: Node3D = $CardPlacementRef5
@onready var card_placement_ref_6: Node3D = $CardPlacementRef6
@onready var card_placement_ref_7: Node3D = $CardPlacementRef7

var chosen_dice : Dictionary = {
	1: basic_d6,
	2: weighted_die,
	3: leaded_die,
	4: sky_die,
	5: cursed_die,
	6: inscrybed_die,
	7: jelly_die
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
	1: bomb_card,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null
}


@export var reroll_coins : Dictionary = {}

@export var money_coins : Dictionary = {}

func performance_switch() -> void:
	if GameManager.performance_mode:
		mesh_instance_3d.visible = false
		directional_light_3d.shadow_enabled = false
		omni_light_3d.shadow_enabled = false
		omni_light_3d_2.shadow_enabled = false
		spot_light_3d_2.shadow_enabled = false
		spot_light_3d_3.shadow_enabled = false
	if !GameManager.performance_mode:
		mesh_instance_3d.visible = true
		#directional_light_3d.shadow_enabled = true
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
	for n in GameManager.rolls:
		var random_buffer_time : float = GameManager.rng.randf_range(0.1, 0.2)
		random_coin_buffer.wait_time = random_buffer_time
		random_coin_buffer.start()
		await random_coin_buffer.timeout
		reroll_coins.get_or_add(n, reroll_coin)
		reroll_coin_instance = reroll_coins.get(n).instantiate()
		reroll_coins.set(n, reroll_coin_instance)
		reroll_coin_instance.name = "Coin" + str(n)
		reroll_coin_instance.coin_number = n + 1
		reroll_coin_instance.position.y = GameManager.rng.randf_range(11, 13)
		reroll_coin_instance.position.x = GameManager.rng.randf_range(10.5, 12.5)
		reroll_coin_instance.position.z = GameManager.rng.randf_range(2.5, 4.5)
		add_child(reroll_coin_instance)
	

func spawn_money() -> void:
	for n in GameManager.money_due:
		var random_buffer_time : float = GameManager.rng.randf_range(0.1, 0.2)
		random_money_buffer.wait_time = random_buffer_time
		random_money_buffer.start()
		await random_money_buffer.timeout
		money_coins.get_or_add(n, money_coin)
		money_coin_instance = money_coins.get(n).instantiate()
		money_coins.set(n, money_coin_instance)
		money_coin_instance.name = "MoneyCoin" + str(n)
		money_coin_instance.coin_number = n + 1
		money_coin_instance.position.y = GameManager.rng.randf_range(15, 16)
		money_coin_instance.position.x = GameManager.rng.randf_range(15.3, 15.8)
		money_coin_instance.position.z = GameManager.rng.randf_range(-3.65, -3.3)
		add_child(money_coin_instance)

func round_start() -> void:
	get_tree().call_group("statues", "main_scene_round_started")
	spawn_coins()

func _ready() -> void:
	InputHandler.main_scene_entered()
	performance_switch()
	music_source.stream = roll_with_it_music
	music_source.play()
	round_start()
	GlobalMusicPlayer.start_act1ambience()
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

func _on_timer_timeout() -> void:
	if die_spawned != max_die:
		die_spawned += 1
		dice_spawner(die_spawned)
		
func dice_spawner(dice_position : int) -> void:
	dice_instance = chosen_dice.get(dice_position).instantiate()
	in_play_dice_instances.set(dice_position, dice_instance)
	dice_instance.name = "Die" + str(dice_position)
	dice_instance.position.y = GameManager.rng.randf_range(11, 13)
	dice_instance.position.x = GameManager.rng.randf_range(-4.5, 4.5)
	dice_instance.position.z = GameManager.rng.randf_range(-4.5, 4.5)
	stored_dice.set(dice_instance.dice_position, "false")
	add_child(dice_instance)
	dice_instance.dice_logic.adjust_number(dice_position)
	
func card_spawner(card_position : int) -> void:
	card_instance = card_deck.get(card_position).instantiate()
	card_deck.set(card_position, card_instance)
	card_instance.name = "Card" + str(card_position)
	card_instance.position = card_placement_references[card_position].position
	card_instance.rotation = card_placement_references[card_position].rotation
	card_instance.scale = card_placement_references[card_position].scale
	add_child(card_instance)
	card_instance.card_logic.card_position = card_position
	card_instance.card_logic.change_layers()
	
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
		camera_movement.play_backwards("zoom_on_box")
		InputHandler.current_reroll_state = 4
		get_tree().call_group("statues", "main_scene_rerolling")
		
func focus_a_die(focused_die : int) -> void:
	if prev_die != 0:
		in_play_dice_instances.get(prev_die).dice_logic.losefocusdie()
	in_play_dice_instances.get(focused_die).focusdie()

func zoom_on_score_sheet() -> void:
	camera_movement.play("DefaultToSheet")
	InputHandler.actionable = false
	camerabuffer.start()
	await camerabuffer.timeout
	InputHandler.actionable = true

func zoom_out_score_sheet() -> void:
	camera_movement.play_backwards("DefaultToSheet")
	InputHandler.actionable = false
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
	InputHandler.hovered_object = "cards"
	card_outline.visible = true

func _on_card_hover_detection_mouse_exited() -> void:
	if InputHandler.hovered_object == "cards":
		InputHandler.hovered_object = "none"
		card_outline.visible = false

func pull_up_cards() -> void:
	card_animations.play("pullupcards")
	
func pull_down_cards() -> void:
	card_animations.play_backwards("pullupcards")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_spawn_card"):
		next_card += 1
		get_tree().get_first_node_in_group("main").card_spawner(next_card)

func _on_card_exit_detect_mouse_entered() -> void:
	InputHandler.hovered_object = "exitcards"
	exit_card_outline.visible = true

func _on_card_exit_detect_mouse_exited() -> void:
	exit_card_outline.visible = false
	if InputHandler.hovered_object == "exitcards":
		InputHandler.hovered_object = "none"
		

func remove_card(card_position : int) -> void:
	card_deck.set(card_position, null)
	if InputHandler.hovered_object == "card" + str(card_position):
		InputHandler.hovered_object = "none"
		
func _on_card_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "pullupcards":
		card_exit_collider.disabled = !card_exit_collider.disabled
		if card_exit_collider.disabled == true:
			exit_card_outline.visible = false
			for i : int in card_deck.size():
					if card_deck.get(i) != null:
						card_deck.get(i).card_logic.move_along_now = false

func play_sheet_to_counter() -> void:
	InputHandler.actionable = false
	camera_movement.play("sheet_to_counter")
	target_score_display.get_new_target_score()

func get_rick_quick_bitch() -> void:
	watching_coins = true
	camera_movement.play("end_of_round_counter_to_coins")
