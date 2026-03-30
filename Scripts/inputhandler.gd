extends Node

var current_reroll_state : int = 0
var hovered_object : String = "none"
var statue_camera_state : bool = false
var next_card : int = 0
var currently_vacant_dice_slot : int
var currently_vacant_statue_slot : int
var currently_vacant_card_slot : int
var cheats_enabled : bool = false

signal pressed_tutorial_interact

var selected_shop_slot : int

@export var in_game : bool = false
@export var actionable : bool = false
@export var can_progress_text : bool = false
@onready var main_scene : Node3D = null

func main_scene_entered() -> void:
	PauseScreen.can_pause = true
	main_scene = get_tree().get_first_node_in_group("main")
	in_game = true
	print(main_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		if !Settings.settings_up:
			PauseScreen.pause()
		if Settings.settings_up:
			Settings._on_texture_button_pressed()
	if in_game == true:
		if GameManager.in_tutorial:
			if event.is_action_pressed("Interact") and can_progress_text:
				pressed_tutorial_interact.emit()
				can_progress_text = false
			return
		if get_tree().get_first_node_in_group("main").between_rounds == true:
			if event.is_action_pressed("Interact"):
				#dice slots
				if hovered_object == "shop_slot_1":
					selected_shop_slot = 1
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_2":
					selected_shop_slot = 2
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_3":
					selected_shop_slot = 3
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_4":
					selected_shop_slot = 4
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_5":
					selected_shop_slot = 5
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				#ticket slots
				if hovered_object == "shop_slot_6":
					selected_shop_slot = 6
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_7":
					selected_shop_slot = 7
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				#statue slots
				if hovered_object == "shop_slot_8":
					selected_shop_slot = 8
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_9":
					selected_shop_slot = 9
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				#card slots
				if hovered_object == "shop_slot_10":
					selected_shop_slot = 10
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_11":
					selected_shop_slot = 11
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
				if hovered_object == "shop_slot_12":
					selected_shop_slot = 12
					get_tree().get_first_node_in_group("main").shop_slot_zoom(selected_shop_slot)
					
				if hovered_object == "shop_leave":
					get_tree().get_first_node_in_group("main").shop_box.exit_shop()
					
				if get_tree().get_first_node_in_group("main").choosing_new_die:
					if hovered_object == "dice1":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(1).dice_logic.replaced()
					if hovered_object == "dice2":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(2).dice_logic.replaced()
					if hovered_object == "dice3":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(3).dice_logic.replaced()
					if hovered_object == "dice4":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(4).dice_logic.replaced()
					if hovered_object == "dice5":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(5).dice_logic.replaced()
					if hovered_object == "dice6":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(6).dice_logic.replaced()
					if hovered_object == "dice7":
						get_tree().get_first_node_in_group("main").in_play_dice_instances.get(7).dice_logic.replaced()
				if get_tree().get_first_node_in_group("main").choosing_new_statue:
					if hovered_object == "statue1":
						get_tree().get_first_node_in_group("main").in_play_statues.get(1).statue_chosen()
					if hovered_object == "statue2":
						get_tree().get_first_node_in_group("main").in_play_statues.get(2).statue_chosen()
					if hovered_object == "statue3":
						get_tree().get_first_node_in_group("main").in_play_statues.get(3).statue_chosen()
					if hovered_object == "statue4":
						get_tree().get_first_node_in_group("main").in_play_statues.get(4).statue_chosen()
					if hovered_object == "statue5":
						get_tree().get_first_node_in_group("main").in_play_statues.get(5).statue_chosen()
					if hovered_object == "statue6":
						get_tree().get_first_node_in_group("main").in_play_statues.get(6).statue_chosen()
				if hovered_object == "statue_combiner_bottom_1":
					get_tree().get_first_node_in_group("main").statue_bottom_choice = GameManager.combined_statue_1.statue_bottom_instance
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_bottom_highlight_1_solidified()
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_bottom_highlight_2_unsolidified()
					
				if hovered_object == "statue_combiner_bottom_2":
					get_tree().get_first_node_in_group("main").statue_bottom_choice = GameManager.combined_statue_2.statue_bottom_instance
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_bottom_highlight_1_unsolidified()
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_bottom_highlight_2_solidified()
					
				if hovered_object == "statue_combiner_top_1":
					get_tree().get_first_node_in_group("main").statue_top_choice = GameManager.combined_statue_1.statue_top_instance
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_top_highlight_1_solidified()
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_top_highlight_2_unsolidified()
					
				if hovered_object == "statue_combiner_top_2":
					get_tree().get_first_node_in_group("main").statue_top_choice = GameManager.combined_statue_2.statue_top_instance
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_top_highlight_1_unsolidified()
					get_tree().get_first_node_in_group("main").statue_combiner_stuff.combiner_top_highlight_2_solidified()
					
				if GameManager.choosing_new_cards:
					if hovered_object == "card1":
						get_tree().get_first_node_in_group("main").card_deck.get(1).card_logic.replaced()
					if hovered_object == "card2":
						get_tree().get_first_node_in_group("main").card_deck.get(2).card_logic.replaced()
					if hovered_object == "card3":
						get_tree().get_first_node_in_group("main").card_deck.get(3).card_logic.replaced()
					if hovered_object == "card4":
						get_tree().get_first_node_in_group("main").card_deck.get(4).card_logic.replaced()
					if hovered_object == "card5":
						get_tree().get_first_node_in_group("main").card_deck.get(5).card_logic.replaced()
					if hovered_object == "card6":
						get_tree().get_first_node_in_group("main").card_deck.get(6).card_logic.replaced()
					if hovered_object == "card7":
						get_tree().get_first_node_in_group("main").card_deck.get(7).card_logic.replaced()
			return
		#if event.is_action_pressed("debug_spawn_card"):
			#next_card += 1
			#get_tree().get_first_node_in_group("main").card_spawner(next_card)
		if event.is_action_pressed("debug_spawn_coins") and cheats_enabled:
			get_tree().get_first_node_in_group("main").give_extra_rerolls(10)
		if event.is_action_pressed("debug_give_money") and cheats_enabled:
			get_tree().get_first_node_in_group("main").give_extra_money(10)
		if event.is_action_pressed("Interact") and current_reroll_state == 3 or event.is_action_pressed("Reload") and current_reroll_state == 3:
			get_tree().get_first_node_in_group("main").reload()
		if get_tree().get_first_node_in_group("main").choosing_new_statue and !get_tree().get_first_node_in_group("main").between_rounds:
			if hovered_object == "statue1":
				get_tree().get_first_node_in_group("main").in_play_statues.get(1).statue_chosen()
			if hovered_object == "statue2":
				get_tree().get_first_node_in_group("main").in_play_statues.get(2).statue_chosen()
			if hovered_object == "statue3":
				get_tree().get_first_node_in_group("main").in_play_statues.get(3).statue_chosen()
			if hovered_object == "statue4":
				get_tree().get_first_node_in_group("main").in_play_statues.get(4).statue_chosen()
			if hovered_object == "statue5":
				get_tree().get_first_node_in_group("main").in_play_statues.get(5).statue_chosen()
			if hovered_object == "statue6":
				get_tree().get_first_node_in_group("main").in_play_statues.get(6).statue_chosen()
		if actionable:
			if event.is_action_pressed("Reload"):
				get_tree().get_first_node_in_group("main").reload()
			if event.is_action_pressed("Interact") and current_reroll_state == 0:
				if hovered_object == "dice1":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(1).dice_logic.interacted()
				if hovered_object == "dice2":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(2).dice_logic.interacted()
				if hovered_object == "dice3":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(3).dice_logic.interacted()
				if hovered_object == "dice4":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(4).dice_logic.interacted()
				if hovered_object == "dice5":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(5).dice_logic.interacted()
				if hovered_object == "dice6":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(6).dice_logic.interacted()
				if hovered_object == "dice7":
					get_tree().get_first_node_in_group("main").in_play_dice_instances.get(7).dice_logic.interacted()
					
				if hovered_object == "card1":
					get_tree().get_first_node_in_group("main").card_deck.get(1).card_logic.card_interact()
				if hovered_object == "card2":
					get_tree().get_first_node_in_group("main").card_deck.get(2).card_logic.card_interact()
				if hovered_object == "card3":
					get_tree().get_first_node_in_group("main").card_deck.get(3).card_logic.card_interact()
				if hovered_object == "card4":
					get_tree().get_first_node_in_group("main").card_deck.get(4).card_logic.card_interact()
				if hovered_object == "card5":
					get_tree().get_first_node_in_group("main").card_deck.get(5).card_logic.card_interact()
				if hovered_object == "card6":
					get_tree().get_first_node_in_group("main").card_deck.get(6).card_logic.card_interact()
				if hovered_object == "card7":
					get_tree().get_first_node_in_group("main").card_deck.get(7).card_logic.card_interact()
					
				if hovered_object == "dicecup":
					get_tree().get_first_node_in_group("main").reload()
				if hovered_object == "scoresheet":
					get_tree().get_first_node_in_group("main").score_sheet.interact()
				if hovered_object == "statues":
					if !statue_camera_state: 
						get_tree().get_first_node_in_group("main").zoom_on_statue()
					if statue_camera_state: 
						get_tree().get_first_node_in_group("main").zoom_out_statue()
					statue_camera_state = !statue_camera_state
				if hovered_object == "cards":
					if !actionable:
						return
					get_tree().get_first_node_in_group("main").pull_up_cards()
					for i : int in get_tree().get_first_node_in_group("main").card_deck.size():
						if get_tree().get_first_node_in_group("main").card_deck.get(i) != null:
							get_tree().get_first_node_in_group("main").card_deck.get(i).card_logic.move_along_now = true
				if hovered_object == "exitcards":
					get_tree().get_first_node_in_group("main").pull_down_cards()
					actionable = true
					for i : int in get_tree().get_first_node_in_group("main").card_deck.size():
						if get_tree().get_first_node_in_group("main").card_deck.get(i) != null:
							get_tree().get_first_node_in_group("main").card_deck.get(i).card_logic.move_along_now = true
		if event.is_action_pressed("DebugTool"):
			print(get_tree().get_first_node_in_group("main").stored_dice.has("false"))
			
			
			
