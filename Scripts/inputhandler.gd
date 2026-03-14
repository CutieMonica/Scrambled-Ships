extends Node

var current_reroll_state : int = 0
var hovered_object : String = "none"
var statue_camera_state : bool = false
var next_card : int = 0
@export var in_game : bool = false
@export var actionable : bool = false
@onready var main_scene : Node3D = null

func main_scene_entered() -> void:
	main_scene = get_tree().get_first_node_in_group("main")
	in_game = true
	print(main_scene)

func _input(event: InputEvent) -> void:
	if in_game == true:
		if get_tree().get_first_node_in_group("main").between_rounds == true:
			return
		#if event.is_action_pressed("debug_spawn_card"):
			#next_card += 1
			#get_tree().get_first_node_in_group("main").card_spawner(next_card)
		if event.is_action_pressed("debug_spawn_coins"):
			get_tree().get_first_node_in_group("main").give_extra_rerolls(10)
		if event.is_action_pressed("debug_give_money"):
			get_tree().get_first_node_in_group("main").give_extra_money(10)
		if event.is_action_pressed("Interact") and current_reroll_state == 3 or event.is_action_pressed("Reload") and current_reroll_state == 3:
			get_tree().get_first_node_in_group("main").reload()
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
					get_tree().get_first_node_in_group("main").pull_up_cards()
					for i : int in get_tree().get_first_node_in_group("main").card_deck.size():
						if get_tree().get_first_node_in_group("main").card_deck.get(i) != null:
							get_tree().get_first_node_in_group("main").card_deck.get(i).card_logic.move_along_now = true
				if hovered_object == "exitcards":
					get_tree().get_first_node_in_group("main").pull_down_cards()
					for i : int in get_tree().get_first_node_in_group("main").card_deck.size():
						if get_tree().get_first_node_in_group("main").card_deck.get(i) != null:
							get_tree().get_first_node_in_group("main").card_deck.get(i).card_logic.move_along_now = true
		if event.is_action_pressed("DebugTool"):
			print(get_tree().get_first_node_in_group("main").stored_dice.has("false"))
