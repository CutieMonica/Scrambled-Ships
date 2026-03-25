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

var tutorial_dont_waste_your_rolls_dialogue : Dictionary = {
	0: "HM. IT SEEMS YOU'RE DEDICATED TO PLAYING FOR ONE PARTICULAR CATEGORY.",
	1: "JUST A LITTLE WORD OF ADVICE...",
	2: "YOU ONLY GET TO PUT A NUMBER IN EACH CATEGORY ONCE, YOU CAN'T REPEAT THE SAME ONE OVER AND OVER AGAIN.",
	3: "AND YOU USUALLY WON'T GET ALL YOUR SCORE FOR THE ROUND FROM A SINGLE CATEGORY.",
	4: "IT'S MUCH BETTER TO ONLY ROLL A COUPLE TIMES, SCORE IN ANY CATEGORY THAT WON'T GIVE YOU A ZERO, AND MOVE ON HENCEFORTH.",
	5: "Man, it's real hard to take you seriously when you're playing it up with words like ''Henceforth''.",
	6: "We both know you wouldn't say that.",
	7: "WELL, THE GAME MASTER WOULD, SO SHUT UP. ANYWAYS...",
	8: "GETTING A BUNCH OF BAD SCORES IS USUALLY GOING TO BE BETTER THAN GETTING ONE REALLY GOOD ONE.",
	9: "SO TRY AND SPREAD OUT YOUR SCORES ACROSS EVERY CATEGORY."
}

var random_dialogue_1 : Dictionary = {
	0: "Oh! Right, I wanted to ask...",
	1: "So, once we're back home... Do you think you'd try that game I got you?",
	2: "HUH? OH. RIGHT. YEAH NO, I'M NOT REALLY INTERESTED.",
	3: "Oh... But, you didn't say that before I bought it for you?",
	4: "It's my favorite game like, ever, and it wouldn't take that long to just give it a shot-",
	5: "I SAID NO. I'M JUST NOT INTERESTED IN IT.",
	6: "I KNOW YOU'RE HAVING MONEY TROUBLES OR WHATEVER, BUT YOU DON'T NEED TO TRY AND GUILT TRIP ME BECAUSE YOU BOUGHT ME SOMETHING.",
	7: "I'm not... Trying to guilt trip. I just, like watching my friends play it-",
	8: "I'M NOT GOING TO PLAY IT. SORRY.",
	9: "...",
	10: "It's fine.",
	11: "JUST... GET BACK TO THE DICE.",
	12: "Fine. I'll play your game."
}

var round_2_first_time : Dictionary = {
	0: "CONGRATULATIONS ON MAKING IT THIS FAR.",
	1: "Huh? It's only round 2, you don't gotta patronize me.",
	2: "... ANYWAYS, YOU WILL SEE THAT THE TARGET SCORE HAS INCREASED SIGNIFICANTLY.",
	3: "HOPEFULLY YOU CHOSE YOUR ITEMS WELL.",
	4: "I feel like I made good decisions!",
	5: "WE WILL SEE."
}

var round_3_first_time : Dictionary = {
	0: "Hm, doesn't feel like the score got much larger.",
	1: "IT WILL. IT SCALES WITH EACH ROUND.",
	2: "THE LATER ROUNDS CAN INCREASE IN SCORE BY THE THOUSANDS.",
	3: "Hm. So the first few rounds are just kinda easy?",
	4: "ARE YOU COMPLAINING ABOUT A LEISURELY START?",
	5: "... Mmmnah, just feels a bit slow I 'spose.",
	6: "IT WON'T, SOON ENOUGH. THE SCORE WILL CATCH UP WITH YOU.",
	7: "Whatever you say, man."
}

var round_4_first_time : Dictionary = {
	0: "Yeup, now it's getting a lil bit tough.",
	1: "YES, IT IS.",
	2: "DO YOU HAVE A PLAN FOR THIS ROUND?",
	3: "Yea, I'm gonna roll dice and put in the highest number on the sheet.",
	4: "YOU KNOW, IT ISN'T ALWAYS BEST TO GO FOR THE HIGHEST SCORING CATEGORY EVERY TIME.",
	5: "SAVING A HIGH-SCORER FOR LATER CAN BE QUITE BENEFICIAL.",
	6: "But dude, what if I want to get twelve score in Sixes?",
	7: "YOU COULD SIMPLY WAIT FOR A BETTER OPPORTUNITY.",
	8: "OR JUST BE DUMB ABOUT IT.",
	9: "... It's worked so far, hasn't it?",
	10: "YEAH, SURE."
}

var round_5_first_time : Dictionary = {
	0:
	1:
}

var round_8_dialogue_variant_1 : Dictionary = {
	0: "..?",
	1: "OH.",
	2: "Hm?",
	3: "SOMETHING CAME UP. I NEED TO GO SOON.",
	4: "Oh... But this is the first time I've been this far!",
	5: "I KNOW. YOU CAN FINISH THIS ROUND.",
	6: "I NEED TO LEAVE AFTER.",
	7: "YOU CAN KEEP PLAYING IF YOU WANT.",
	8: "Well, I'll uh, just wait for you to get back.",
	9: "YOU DON'T HAVE TO.",
	10: "YOU CAN PLAY ON YOUR OWN.",
	11: "I know. I want to.",
	12: "...",
	13: "WHATEVER. JUST FINISH THIS ROUND."
}

var round_8_dialogue_variant_2 : Dictionary = {
	0: "Finally, back here again.",
	1: "Losing that run before sucked.",
	2: "AH. AND I NEED TO LEAVE SOON AGAIN.",
	3: "Again?",
	4: "YEAH.",
	5: "... Can I ask why?",
	6: "NO.",
	7: "IT'S NONE OF YOUR BUSINESS.",
	8: "... Alright."
}

var round_8_dialogue_variant_3 : Dictionary = {
	0: "Ugh. Finally. Maybe I'll actually beat it this time.",
	1: "YEAH, WHATEVER.",
	2: "I GOT A CALL.",
	3: "I'M LEAVING SOON.",
	4: "WRAP IT UP.",
	5: "...",
	6: "Fine."
}

var ending_dialogue : Dictionary = {
	0: "Mm. Wasn't too hard.",
	1: "Well... That was round 8 done.",
	2: "YEAH. I REALLY NEED TO GO NOW.",
	3: "Alright... Do you... wanna hang out again soon?",
	4: "I'M BUSY.",
	5: "Busy like, all the time?",
	6: "YEAH.",
	7: "YOU HAVE OTHER PEOPLE YOU CAN HANG OUT WITH.",
	8: "YOU DON'T NEED TO PLAY THIS WITH ME.",
	9: "But I thought playing this was like, our thing..?",
	10: "IT'S NOT A ''THING'', IT'S JUST A GAME WE BOTH LIKE.",
	11: "But playing it without you wouldn't feel the same.",
	12: "YOU STILL CAN.",
	13: "YOU DON'T HAVE TO BOTHER ME EVERY TIME YOU WANT TO PLAY THIS GAME.",
	14: "I just, enjoy spending time with you... and...",
	15: "I love you, man. I miss you when we're not hanging out.",
	16: "STOP TELLING ME YOU LOVE ME.",
	17: "I WANT TO BE LIKED, NOT LOVED.",
	18: "But I just... want my friends to know that I do genuinely love and appreciate-",
	19: "STOP.",
	20: "YOU DON'T NEED TO TELL ME THAT.",
	21: "I DON'T WANT TO HEAR IT.",
	22: "But, it's just, hard to go without saying it, my mind always wants to make sure my friends know they're-",
	23: "I DON'T CARE.",
	24: "THAT'S YOUR OWN PROBLEM.",
	25: "YOU CAN CONTROL YOUR BRAIN JUST FINE ENOUGH TO NOT SAY SOMETHING AROUND ME.",
	26: "YOU CAN'T JUST BLAME EVERYTHING ON YOUR MIND BEING MESSED UP.",
	27: "I wasn't trying to blame everything, it's just, a compulsive thing, I-",
	28: "STOP.",
	29: "YOU DON'T NEED TO SAY IT TO ME.",
	30: "YOU NEED TO WORK ON YOURSELF.",
	31: "BE BETTER THAN THIS.",
	32: "...",
	33: "Sorry.",
	34: "...",
	35: "WHATEVER.",
	36: "SHAKE MY HAND.",
	37: "I'M LEAVING.",
	38: "...",
	39: "I'm sorry."
}

var postgame_intro : Dictionary = {
	0: "mmm...",
	1: "I keep dreaming about them...",
	2: "Trapped in my own thoughts...",
	3: "Replaying the time we spent together...",
	4: "Playing this game.",
	5: "But...",
	6: "The game is playable with just one person.",
	7: "I don't need them to keep playing it.",
	8: "I can just... play it on my own.",
	9: "...",
	10: "I never felt satisfied with it.",
	11: "That run was going really well before they bailed on me.",
	12: "Then told me they didn't want anything to do with me again.",
	13: "It almost just... hurts to think about playing it without them here.",
	14: "...",
	15: "But... I want to keep going.",
	16: "I want to do the best I can.",
	17: "Even if it hurts.",
	18: "Even if everything is the same... It still feels different. Like something is missing.",
	19: "But maybe that's okay.",
	20: "I don't need them.",
	21: "I'm here.",
	22: "I'm enough.",
	23: "On my own.",
	24: "Now...",
	25: "... I think this is where I was at before?"
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
	
func spamming_rerolls_dialogue() -> void:
	if GameManager.dialogue_seen.get(3) != true:
		GameManager.in_tutorial = true
		for i in tutorial_dont_waste_your_rolls_dialogue.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 5 or i == 6:
				no_dialogue()
				dialogue_handler_2.text = tutorial_dont_waste_your_rolls_dialogue.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = tutorial_dont_waste_your_rolls_dialogue.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				2: get_parent().get_parent().camera_movement.play("DefaultToSheet")
				4: get_parent().get_parent().camera_movement.play_backwards("DefaultToSheet")
				5: get_parent().get_parent().camera_movement.play_backwards("dealer_to_default")
				8: get_parent().get_parent().camera_movement.play("dealer_to_default")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(3)
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
