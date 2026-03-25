extends Node3D

@export var card_position : int = 1

var activated : bool = false
var in_shop : bool = true

var card_being_replaced : bool = false

var moving_to_target : bool = false

var card_sound_1 := SfxBank.card_flip_1
var card_sound_2 := SfxBank.card_flip_2
var card_sound_3 := SfxBank.card_flip_3

@export var move_along_now : bool = false

@export var common_text_color : Color = Color(0.638, 0.638, 0.638, 1.0)
@export var common_text_outline_color : Color = Color(0.115, 0.115, 0.115, 0.639)

@export var uncommon_text_color : Color = Color(0.236, 0.617, 0.273, 1.0)
@export var uncommon_text_outline_color : Color = Color(0.012, 0.166, 0.158, 0.639)

@export var rare_text_color : Color = Color(0.599, 0.416, 0.838, 1.0)
@export var rare_text_outline_color : Color = Color(0.082, 0.122, 0.295, 0.639)

@export var legendary_text_color : Color = Color(0.882, 0.647, 0.28, 1.0)
@export var legendary_text_outline_color : Color = Color(0.293, 0.0, 0.03, 0.639)

@export var score_categories : Dictionary = {
	1: "ones",
	2: "twos",
	3: "threes",
	4: "fours",
	5: "fives",
	6: "sixes",
	7: "choice",
	8: "small_straight",
	9: "large_straight",
	10: "full_house",
	11: "four_of_a_kind",
	12: "yacht"
}

@onready var timer: Timer = $Timer
@onready var poof_particle: CPUParticles3D = $PoofParticle

func choose_random_category() -> String:
	var random_category : int = GameManager.rng_cards.randi_range(1, 12)
	return score_categories.get(random_category)
	
func random_card_sound() -> void:
	var random_noise : int = 0
	random_noise = randi_range(1, 3)
	match random_noise:
		1: get_parent().audio_stream_player_3d.stream = card_sound_1
		2: get_parent().audio_stream_player_3d.stream = card_sound_2
		3: get_parent().audio_stream_player_3d.stream = card_sound_3
	get_parent().audio_stream_player_3d.volume_db = (-10 + randf_range(-2, 2))
	get_parent().audio_stream_player_3d.pitch_scale = (0 + randf_range(0.8, 1.3))
	get_parent().audio_stream_player_3d.play()

func change_layers() -> void:
	await get_tree().process_frame
	#get_parent().nametag.render_priority -= (card_position * 5)
	#get_parent().descriptionlabel.render_priority -= (card_position * 5)
	#get_parent().raritylabel.render_priority -= (card_position * 5)
	#get_parent().nametag.outline_render_priority -= (card_position * 5)
	#get_parent().descriptionlabel.outline_render_priority -= (card_position * 5)
	#get_parent().raritylabel.outline_render_priority -= (card_position * 5)
	get_parent().nametag.sorting_offset -= (card_position)
	get_parent().raritylabel.sorting_offset -= (card_position)
	get_parent().descriptionlabel.sorting_offset -= (card_position)
	get_parent().card_back.sorting_offset -= (card_position)
	get_parent().card_art.sorting_offset -= (card_position)
	get_parent().card_front.sorting_offset -= (card_position)
	#get_parent().card_back.get_active_material(0).render_priority -= (card_position * 5)
	#get_parent().card_art.get_active_material(0).render_priority -= (card_position * 5)
	#get_parent().card_front.get_active_material(0).render_priority -= (card_position * 5)
	
func focuscard() -> void:
	if InputHandler.hovered_object != "scoresheet" and !activated and get_tree().get_first_node_in_group("main").between_rounds == false or GameManager.choosing_new_cards:
		get_parent().animation_player.play("highlight")
		get_parent().focused = true
		InputHandler.hovered_object = "card" + str(card_position)
		print(InputHandler.hovered_object)
	else:
		pass

func unfocuscard() -> void:
	if !activated:
		get_parent().animation_player.play("unhighlight")
		get_parent().focused = false
		if InputHandler.hovered_object == "card" + str(card_position):
			InputHandler.hovered_object = "none"

func _process(delta: float) -> void:
	if move_along_now and !activated:
		get_parent().position = get_parent().get_parent().card_placement_references[card_position].position
		get_parent().rotation = get_parent().get_parent().card_placement_references[card_position].rotation
	if activated:
		pass
	if moving_to_target:
		get_parent().position = lerp(get_parent().position, get_parent().get_parent().card_placement_references.get(card_position).position, delta * 9)

func card_interact() -> void:
	if !in_shop and GameManager.viewing_cards:
		activated = true
		get_parent().get_parent().remove_card(card_position)
		get_parent().get_parent().exit_card_outline.visible = false
		get_parent().get_parent().pull_down_cards()
		move_along_now = false
		get_parent().mouse_collider.visible = false
		InputHandler.actionable = false
		get_parent().yall_ready_for_this()
		timer.start()
	if GameManager.viewing_cards == false:
		return

func _on_timer_timeout() -> void:
	move_along_now = false
	get_parent().activate()
	get_parent().audio_stream_player_3d.volume_db = 0
	get_parent().audio_stream_player_3d.pitch_scale = 1

func card_dies() -> void:
	InputHandler.actionable = true
	get_parent().queue_free()

func purchase_card() -> void:
	var target_slot : int = get_tree().get_first_node_in_group("main").find_vacant_card_slot()
	
	if target_slot != 0:
		get_parent().reparent(get_tree().get_first_node_in_group("main"))
		card_position = target_slot
		get_parent().get_parent().card_deck.set(target_slot, get_parent())
		in_shop = false
		get_parent().get_parent().shop_to_card_deck()
		await get_tree().create_timer(0.9).timeout
		get_parent().global_position = Vector3(get_parent().get_parent().card_placement_references.get(card_position).global_position.x + 20, get_parent().get_parent().card_placement_references.get(card_position).global_position.y, get_parent().get_parent().card_placement_references.get(card_position).global_position.z)
		get_parent().rotation = get_parent().get_parent().card_placement_references.get(card_position).rotation
		moving_to_target = true
		GameManager.card_count += 1
		remove_from_group("awaiting_new_slot")
		change_layers()
		await get_tree().create_timer(0.8).timeout
		get_parent().get_parent().card_deck_to_shop()
		moving_to_target = false
		return
	if target_slot == 0:
		add_to_group("awaiting_new_slot")
		get_tree().get_first_node_in_group("main").shop_to_default()
		get_tree().get_first_node_in_group("main").choosing_new_card = true
		get_tree().get_first_node_in_group("main").pull_up_cards()
		for i : int in get_tree().get_first_node_in_group("main").card_deck.size():
			if get_tree().get_first_node_in_group("main").card_deck.get(i) != null:
				get_tree().get_first_node_in_group("main").card_deck.get(i).card_logic.move_along_now = true

func replaced() -> void:
	poof_particle.emitting = true
	get_parent().audio_stream_player_3d.stream = SfxBank.poof_sound
	get_parent().audio_stream_player_3d.volume_db = (-8 + randf_range(2, 3))
	get_parent().audio_stream_player_3d.pitch_scale = (0 + randf_range(0.9, 1.2))
	get_parent().audio_stream_player_3d.play()
	get_parent().get_parent().choosing_new_card = false
	GameManager.choosing_new_cards = false
	await get_tree().create_timer(0.05).timeout
	get_parent().card_visuals.visible = false
	unfocuscard()
	card_being_replaced = true
	await get_tree().create_timer(0.45).timeout
	var temp_card_position_buffer : int = card_position
	get_parent().get_parent().remove_card(card_position)
	get_tree().get_first_node_in_group("awaiting_new_slot").go_to_new_slot(temp_card_position_buffer)
	get_parent().queue_free()

func go_to_new_slot(slot : int) -> void:
	card_position = slot
	get_parent().reparent(get_tree().get_first_node_in_group("main"))
	get_parent().get_parent().card_deck.set(slot, get_parent())
	get_parent().global_position = Vector3(get_parent().get_parent().card_placement_references.get(card_position).global_position.x, get_parent().get_parent().card_placement_references.get(card_position).global_position.y + 20, get_parent().get_parent().card_placement_references.get(card_position).global_position.z)
	get_parent().rotation = get_parent().get_parent().card_placement_references.get(card_position).rotation
	moving_to_target = true
	get_parent().get_parent().dialogue_player.no_dialogue()
	remove_from_group("awaiting_new_slot")
	GameManager.card_count += 1
	await get_tree().create_timer(0.9).timeout
	for i : int in get_tree().get_first_node_in_group("main").card_deck.size():
		if get_tree().get_first_node_in_group("main").card_deck.get(i) != null:
			get_tree().get_first_node_in_group("main").card_deck.get(i).card_logic.move_along_now = true
	moving_to_target = false
	get_parent().get_parent().pull_down_cards()
	get_parent().get_parent().default_to_shop()
	get_parent().get_parent().enable_all_shop_areas()
