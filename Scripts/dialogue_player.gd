extends AnimationPlayer
@onready var dialogue_handler: Control = $".."
@onready var dialogue_handler_2: Control = $"../../DialogueHandler2"
@onready var dialogue_wait_buffer: Timer = $DialogueWaitBuffer
var tutorial_prompt_pressed : bool = false
signal dialogue_progressed
@onready var input_handler := get_node("/root/InputHandler")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var tutorial_dialogue_1 : Dictionary = {
	0: "YOU OPEN YOUR EYES...",
	1: "YOU FIND YOURSELF AWAKE IN A YACHT ON THE WATER.",
	2: "Aren't most yachts on the water? Also this is more like a dinghy.",
	3: "YOU, UH, USE YOUR IMAGINATION. NONE OF THIS IS MEANT TO BE TAKEN LITERALLY.",
	4: "Oh, so you're tryna be like, the dungeon master guy?",
	5: "PRETTY MUCH, I'LL BE SETTING THINGS UP FOR YOU WHILE YOU PLAY, RANDOMIZING ITEMS AND WHATNOT.",
	6: "Cool, anyway, continue.",
	7: "RIGHT. YOU WAKE UP ON THIS YACHT, IN FRONT OF YOU IS A BOX WITH SOME DICE, A SHEET OF PAPER, AND A CUP.",
	8: "ONCE THESE DICE HAVE STOPPED MOVING, YOU CAN INTERACT WITH THEM TO STORE THEM, OR KEEP THEM IN THE BOX.",
	9: "WHEN STORED, THEY WON'T BE REROLLED WHEN YOU INTERACT WITH THE CUP, BUT THE DICE IN THE BOX WILL.",
	10: "EVERY TIME YOU INTERACT WITH THE CUP, YOU LOSE ONE REROLL TOKEN.",
	11: "WHEN YOU'RE SATISFIED WITH THE DICE YOU'VE ROLLED, YOU CAN INTERACT WITH THE PAPER, AND PUT THOSE NUMBERS WHEREVER YOU WISH.",
	12: "THESE TOP CATEGORIES ADD UP HOW MANY OF EACH NUMBER YOU HAVE. IF YOU HAVE THREE THREES, SCORING IN THREES GIVES YOU NINE SCORE.",
	13: "THE BOTTOM CATEGORIES ARE A LITTLE MORE COMPLEX, AND GIVE SCORE PROPORTIONAL TO THEIR DIFFICULTY.",
	14: "CHOICE IS THE GENERIC CATCH-ALL CATEGORY, IT JUST GIVES YOU SCORE EQUAL TO ALL YOUR DICE VALUES ADDED UP.",
	15: "THE TWO STRAIGHTS REQUIRE DICE IN ASCENDING ORDER TO SCORE.",
	16: "SMALL STRAIGHT REQUIRES FOUR NUMBERS, BUT LARGE STRAIGHT REQUIRES FIVE.",
	17: "FULL HOUSE REQUIRES TWO OF YOUR DICE TO HAVE THE SAME VALUE, AND THREE OF YOUR DICE TO ALL SHARE A DIFFERENT ONE.",
	18: "FOUR OF A KIND IS PRETTY SELF-EXPLANATORY.",
	19: "YACHT IS JUST FIVE OF A KIND, BUT WITH A FANCIER NAME.",
	20: "So, what do I gotta do when I wanna score?",
	21: "ONCE ALL YOUR DICE ARE WHERE YOU WANT THEM, INTERACT WITH THE EMPTY SPACE NEXT TO A CATEGORY.",
	22: "THIS WILL CAUSE YOU TO LOSE ONE REROLL, AND WILL REROLL ALL OF YOUR DICE, EVEN IF THEY WERE STORED.",
	23: "YOU CAN ONLY FILL OUT EACH CATEGORY ONCE PER ROUND, SO CHOOSE CAREFULLY.",
	24: "And if I fill a category after running out of reroll tokens?",
	25: "IF YOU BEAT THE TARGET SCORE, YOU WIN AND PROGRESS TO THE NEXT ROUND.",
	26: "AND IF YOU FAIL TO MEET THAT SCORE, YOU LOSE.",
	27: "EVERY TIME YOU WIN, YOU GET TO VISIT THE SHOP, BUT WE'LL GET TO THAT LATER.",
	28: "FOR NOW, JUST TRY TO NOT SCREW UP ON ROUND ONE.",
	29: "I'll do my best, no guarantees tho."
}

var tutorial_shop_dialogue : Dictionary = {
	0: "ALRIGHT, NOW THAT YOU'VE WON THE ROUND...",
	1: "YOU GET PAID SOME COINS. YOU GET MORE MONEY THE MORE REROLLS YOU HAVE LEFTOVER.",
	2: "YOU ALSO GET MORE MONEY IF YOU GO OVER THE TARGET SCORE, BUT THIS HAS DIMINISHING RETURNS EACH ROUND.",
	3: "SO... MAKE YOUR EARLY ROUNDS COUNT.",
	4: "Aight, what do I do with all this money now?",
	5: "YOU TAKE IT OVER TO THE SHOP, WHICH YOU VISIT BETWEEN EACH ROUND.",
	6: "IN THIS SHOP, YOU CAN FIND MYSTICAL DICE, IMBUED WITH UNIQUE ATTRIBUTES...",
	7: "GRAB CARDS THAT HAVE A UNIQUE EFFECT ANY TIME YOU WANT TO USE THEM...",
	8: "PICK UP CURSED STATUES THAT MAKE YOU STRONGER WHENEVER THEY'RE TRIGGERED, BUT DEPEND ON THE POWER OF THEIR BASE...",
	9: "AND WHEN YOU'RE FULL ON STATUES, YOU CAN SWAP THOSE BASES OUT, AND MAKE YOUR STATUES EVEN STRONGER...",
	10: "AND FINALLY, THESE TICKETS SHOW UP WITH A UNIQUE, STRAIGHTFORWARD EFFECT THAT HAPPENS AS SOON AS YOU BUY IT.",
	11: "So... I just buy whatever looks cool?",
	12: "YOU CAN GO THAT ROUTE, OR PLAN CAREFULLY, AND COMBINE ITEMS FOR WONDERFUL REWARDS.",
	13: "YOU CAN INTERACT WITH EACH ITEM TO LEARN MORE ABOUT THEIR EFFECTS BEFORE YOU CHOOSE ANYTHING.",
	14: "JUST TRY TO GET YOUR MULTIPLIERS UP AS HIGH AS YOU CAN, AND YOU MAY JUST OUTRUN THE INCREASING SCORE TARGETS."
}

func play_confirm_sound() -> void:
	audio_stream_player.stream = SfxBank.generic_confirm_sound
	audio_stream_player.pitch_scale = (0 + randf_range(0.8, 1.2))
	audio_stream_player.play()

func _ready() -> void:
	input_handler.connect("pressed_tutorial_interact", tutorial_pressed)

func tutorial_pressed() -> void:
	tutorial_prompt_pressed = true
	if tutorial_prompt_pressed:
		dialogue_progressed.emit()
		tutorial_prompt_pressed = false

func opening_tutorial_dialogue() -> void:
	if GameManager.dialogue_seen.get(1) != true:
		GameManager.in_tutorial = true
		for i in tutorial_dialogue_1.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 2 or i == 4 or i == 6 or i == 20 or i == 24 or i == 29:
				no_dialogue()
				dialogue_handler_2.text = tutorial_dialogue_1.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = tutorial_dialogue_1.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				7: get_parent().get_parent().camera_movement.play("First_time_to_default")
				10: get_parent().get_parent().camera_movement.play("default_to_cup")
				11: get_parent().get_parent().camera_movement.play("cup_to_paper")
				12: get_parent().get_parent().camera_movement.play("paper_to_top_categories")
				13: get_parent().get_parent().camera_movement.play("top_categories_to_bottom_categories")
				14: get_parent().get_parent().camera_movement.play("bottom_categories_to_choice")
				15: get_parent().get_parent().camera_movement.play("choice_to_straights")
				18: get_parent().get_parent().camera_movement.play("straights_to_four_of_a_kind")
				20: get_parent().get_parent().camera_movement.play("four_of_a_kind_to_sheet")
				25: get_parent().get_parent().camera_movement.play("sheet_to_counter")
				27: get_parent().get_parent().camera_movement.play("counter_to_dealer")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(1)
		get_parent().get_parent().camera_movement.play("dealer_to_default")
		no_dialogue()
		no_dialogue_voice_2()
	
func shop_tutorial_dialogue() -> void:
	if GameManager.dialogue_seen.get(2) != true:
		GameManager.in_tutorial = true
		for i in tutorial_shop_dialogue.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 4 or i == 11:
				no_dialogue()
				dialogue_handler_2.text = tutorial_shop_dialogue.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = tutorial_shop_dialogue.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				1: get_parent().get_parent().get_rick_quick_bitch()
				5: get_parent().get_parent().play_coins_to_shop()
				6: get_parent().get_parent().camera_movement.play("shop_to_dice_view")
				7: get_parent().get_parent().camera_movement.play("dice_view_to_cards_view")
				8: get_parent().get_parent().camera_movement.play("cards_view_to_statues")
				10: get_parent().get_parent().camera_movement.play("statues_view_to_tickets")
				11: get_parent().get_parent().camera_movement.play("tickets_to_shop_default")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(2)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		no_dialogue()
		no_dialogue_voice_2()
	
func dialogue_save(dialogue_number : int) -> void:
	GameManager.dialogue_seen.set(dialogue_number, true)
	SaveLoad.SaveFileData.dialogue_seen.set(dialogue_number, true)
	SaveLoad._save()

func no_dialogue() -> void:
	dialogue_handler.text = " "
	dialogue_handler.start_cutscene = true
	
func no_dialogue_voice_2() -> void:
	dialogue_handler_2.text = " "
	dialogue_handler_2.start_cutscene = true

func play_dice_selection_dialogue() -> void:
	play("replace_dice")

func play_statue_dialogue_1() -> void:
	play("replace_statue_1")

func play_statue_dialogue_2() -> void:
	play("replace_statue_2")
