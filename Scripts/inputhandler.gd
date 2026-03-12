extends Node

var hovered_object : String = "none"
var statue_camera_state : bool = false
@export var actionable : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_spawn_card"):
		get_parent().card_spawner(1)
	if event.is_action_pressed("debug_spawn_coins"):
		get_parent().give_extra_rerolls(10)
	if event.is_action_pressed("debug_give_money"):
		get_parent().give_extra_money(10)
	if event.is_action_pressed("Interact") and get_parent().current_state == 3 or event.is_action_pressed("Reload") and get_parent().current_state == 3:
		get_parent().reload()
	if actionable:
		if event.is_action_pressed("Reload"):
			get_parent().reload()
		if event.is_action_pressed("Interact") and get_parent().current_state == 0:
			if hovered_object == "dice1":
				get_parent().in_play_dice_instances.get(1).dice_logic.interacted()
			if hovered_object == "dice2":
				get_parent().in_play_dice_instances.get(2).dice_logic.interacted()
			if hovered_object == "dice3":
				get_parent().in_play_dice_instances.get(3).dice_logic.interacted()
			if hovered_object == "dice4":
				get_parent().in_play_dice_instances.get(4).dice_logic.interacted()
			if hovered_object == "dice5":
				get_parent().in_play_dice_instances.get(5).dice_logic.interacted()
			if hovered_object == "dice6":
				get_parent().in_play_dice_instances.get(6).dice_logic.interacted()
			if hovered_object == "dice7":
				get_parent().in_play_dice_instances.get(7).dice_logic.interacted()
			if hovered_object == "dicecup":
				get_parent().reload()
			if hovered_object == "scoresheet":
				get_parent().score_sheet.interact()
			if hovered_object == "statues":
				if !statue_camera_state: 
					get_parent().zoom_on_statue()
				if statue_camera_state: 
					get_parent().zoom_out_statue()
				statue_camera_state = !statue_camera_state
			if hovered_object == "cards":
				
	if event.is_action_pressed("DebugTool"):
		print(get_parent().stored_dice.has("false"))
