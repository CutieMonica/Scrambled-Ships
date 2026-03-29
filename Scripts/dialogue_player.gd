extends AnimationPlayer
@onready var dialogue_handler: Control = $".."
@onready var dialogue_handler_2: Control = $"../../DialogueHandler2"
@onready var dialogue_wait_buffer: Timer = $DialogueWaitBuffer
var tutorial_prompt_pressed : bool = false
signal dialogue_progressed
@onready var input_handler := get_node("/root/InputHandler")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

#TODO: split this up into different smaller tutorials
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
	10: "AND FINALLY, THESE TICKETS SHOW UP WITH A UNIQUE, STRAIGHTFORWARD EFFECT THAT GOES INTO EFFECT AS SOON AS THEY'RE PURCHASED.",
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
	3: "HOPEFULLY YOU WILL CHOOSE YOUR ITEMS WELL.",
	4: "I feel like I make good decisions!",
	5: "WE WILL SEE."
}

var round_3_first_time : Dictionary = {
	0: "Hm, doesn't feel like the score got much larger.",
	1: "IT WILL. IT SCALES WITH EACH ROUND.",
	2: "THE LATER ROUNDS CAN GROW IN SCORE BY THE THOUSANDS.",
	3: "Hm. So the first few rounds are just kinda easy?",
	4: "ARE YOU COMPLAINING ABOUT GETTING OFF THE GROUND EASILY?",
	5: "... Mmm, nah, just feels a bit slow I 'spose.",
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
	0: "Man, it's getting dark out so fast.",
	1: "THE LIGHTS IN HERE SHOULD GET BRIGHTER AS IT GETS DARKER. DON'T WORRY ABOUT IT.",
	2: "Not like I was worried, really. The lighting kinda helps the mood actually.",
	3: "Makes for a really cool vibe for these later rounds, to be honest.",
	4: "I WOULD PREFER IF THE LIGHTS REMAINED THE SAME.",
	5: "IT WOULD BE BETTER WERE IT MORE CONSISTENT.",
	6: "Well, that's just not how things go, the sun always goes down.",
	7: "AND YET I FIND MYSELF WISHING FOR THINGS TO STAY THE SAME NONETHELESS.",
	8: "ANYWAYS...",
	9: "YOU SHOULD GET BACK TO PLAYING.",
	10: "I was just tryin to talk about something else for once, though.",
	11: "YES, AND WE TALKED ABOUT IT, NOW IT'S TIME TO GET BACK TO PLAYING.",
	12: "... Okay, dude."
}

var round_6_first_time : Dictionary = {
	0: "Mmm, that's... quite a large target score now.",
	1: "YES, LIKE I SAID, IT GETS HARDER AS THINGS GO ON.",
	2: "I mean, yeah, I knew that, I just didn't really expect it to go this fast-",
	3: "IT GETS EXPONENTIALLY HARDER AS IT GOES ON, I'VE TOLD YOU THIS.",
	4: "I just kinda don't really understand how the scaling works, exactly, I mean...",
	5: "I SHOULD NOT HAVE TO REPEAT MYSELF.",
	6: "THERE IS NOTHING TO UNDERSTAND ABOUT IT THAT YOU DON'T ALREADY KNOW.",
	7: "I kinda just, feel weird about it, I suppose.",
	8: "I SEE THAT.",
	9: "THAT'S NOT MY PROBLEM.",
	10: "JUST KEEP PLAYING.",
	11: "I... Alright."
}

var round_7_first_time : Dictionary = {
	0: "Mmm...",
	1: "For some reason, I find myself more nervous about the next round than I am excited.",
	2: "...",
	3: "AND WHAT IS TELLING ME ABOUT IT GOING TO DO?",
	4: "YOU'RE JUST INVOLVING ME IN YOUR PROBLEMS FOR NO REASON.",
	5: "IF YOU'RE GOING TO KEEP GOING ON ABOUT YOUR FEELINGS I'D RATHER JUST REMOVE MYSELF FROM THE SCENARIO.",
	6: "...What?",
	7: "I was just, saying I'm feeling nervous.",
	8: "YOU DON'T NEED TO TELL ME THAT.",
	9: "I DON'T NEED TO KNOW THAT.",
	10: "I'M HERE, TAKING TIME OUT OF MY DAY TO PLAY THIS GAME WITH YOU.",
	11: "YET YOU TRY TO TURN IT INTO ANOTHER ISSUE.",
	12: "That's not... I'm not trying to turn it into a problem.",
	13: "THEN STOP BRINGING IT UP.",
	14: "DON'T SAY IT.",
	15: "DON'T KEEP REMINDING ME THAT YOU FEEL BAD.",
	16: "JUST PLAY THE GAME.",
	17: "I...",
	18: "I'm sorry.",
	19: "I just... feel afraid that I'm going to say the wrong thing.",
	20: "That I have a gun to my head ready to fire whenever I say anything you don't like.",
	21: "Even if saying that is second nature to me.",
	22: "I just... I love you. I want to be able to talk to you without tip toeing around a mine field.",
	23: "STOP THIS.",
	24: "YOU DON'T NEED TO CONSTANTLY REMIND ME THAT YOU LOVE ME.",
	25: "JUST PLAY THE GAME.",
	26: "..."
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
	35: "YOU LOVING ME AND CONSTANTLY YEARNING FOR MY LOVE BACK, FOR THINGS TO BE MORE...",
	36: "CLEARLY IT'S HURTING YOU JUST TO BE AROUND ME.",
	37: "YOU NEED TO LEARN TO STOP FEELING THIS WAY.",
	38: "... Not being around you hurts more.",
	39: "YOU NEED TO LET GO OF ME.",
	40: "I DON'T WANT TO BE AN OBJECT THAT PEOPLE ASPIRE TO LOVE.",
	41: "You're not... an object, you're a person...",
	42: "A person that feels incredible to me, someone I genuinely love being around.",
	43: "YOU STAY STUCK IN THIS LOOP OF WANTING MORE, TELLING ME THESE THINGS, AND BEING DISAPPOINTED WHEN I REJECT THEM.",
	44: "YOU DON'T RESPECT MY STANCE, AND YOU'RE MAKING YOURSELF FEEL BAD FOR IT.",
	45: "I do respect it, I just... don't know what you want from me. I can't just not feel or think the way I do.",
	46: "And regardless, you tried to get close with me just last night.",
	47: "If I had done the same thing you did, you would hate me for it.",
	48: "THAT WAS DIFFERENT. THIS IS YOU REFUSING TO CHANGE FOR ME.",
	49: "YOU, CONSTANTLY TRYING TO MAKE ME FEEL UNCOMFORTABLE.",
	50: "That's just... not what I'm trying to do, I just, want to be free to express myself.",
	51: "THEN EXPRESS YOURSELF AWAY FROM ME.",
	52: "I DON'T WANT TO SEE IT.",
	53: "I DON'T WANT TO HEAR IT.",
	54: "IF YOU'RE GOING TO BE LIKE THIS, I WOULD RATHER JUST REMOVE MYSELF. FOR YOUR SAKE.",
	55: "... How is any of this for my sake if it's just going to make me feel worse?",
	56: "I PUT TOO MUCH EFFORT IN FOR PEOPLE AS IS.",
	57: "I'M EXHAUSTED CONSTANTLY.",
	58: "I CAN'T FIX YOUR PROBLEMS.",
	59: "AND BEING AROUND ME JUST MAKES YOU FEEL WORSE NO MATTER WHAT.",
	60: "YOU NEED TO CHANGE. I'M NOT GOING TO BOTHER HERE.",
	61: "This... isn't going to help anything. I'm just going to end up feeling worse.",
	62: "I have no one else to talk to at night when I feel at my lowest.",
	63: "My life is a mess, and I live in a broken home.",
	64: "Having you fill that void in my life has been what's keeping me going.",
	65: "You're just, important to me. I don't want to lose you.",
	66: "...",
	67: "I DON'T CARE.",
	68: "YOU HAVE PEOPLE TO TALK TO.",
	69: "I DON'T WANT TO BE PART OF IT.",
	70: "PLEASE. LEAVE ME ALONE.",
	71: "...",
	72: "...",
	73: "WHATEVER.",
	74: "YOU AREN'T GOING TO CHANGE.",
	75: "I'M LEAVING.",
	76: "...",
	77: "I'm sorry...",
	78: "I... Don't know if I can live without you.",
	79: "I'm sorry."
}

var postgame_intro : Dictionary = {
	0: "mmm...",
	1: "I keep dreaming about them...",
	2: "Trapped in my own thoughts...",
	3: "Replaying the time we spent together...",
	4: "Playing this game.",
	5: "But...",
	6: "The game has always been playable alone.",
	7: "I don't need them to keep playing it.",
	8: "I can just... play it on my own.",
	9: "...",
	10: "I never felt satisfied with it.",
	11: "That run was going really well before they bailed on me.",
	12: "Then told me they didn't want anything to do with me anymore.",
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

var death_dialogue_1 : Dictionary = {
	0: "WELL, THAT'S THAT.",
	1: "...THAT COUNTER VOICE GETS ON MY NERVES.",
	2: "IT JUST FEELS SO CONDESCENDING.",
	3: "WHY GIVE SO MUCH FOCUS TO A LOSS?",
	4: "IT'S NOT AS THOUGH LOSING SHOULD BE TREATED LIKE ANYTHING SPECIAL.",
	5: "WE LOSE THINGS ALL THE TIME.",
	6: "SOMETIMES THEY'RE IMPORTANT TO US.",
	7: "BUT LOSING A GAME IS A SMALL LOSS, ALL THINGS CONSIDERED.",
	8: "MAYBE IT'S IMPACTFUL IN THE MOMENT.",
	9: "BUT YOU WILL GET OVER IT.",
	10: "...",
	11: "YOU CAN ALWAYS GET OVER IT."
}

var death_dialogue_2 : Dictionary = {
	0: "THAT'S ANOTHER RUN GONE.",
	1: "A SHAME, TOO, THAT ONE HAD POTENTIAL.",
	2: "IT COULD HAVE BEEN SOMETHING GREAT.",
	3: "BUT THAT'S NOT ALWAYS HOW THINGS GO.",
	4: "SOMETIMES THE FOUNDATION FOR A TRULY INCREDIBLE THING CAN BE THERE...",
	5: "YET IT NEVER GETS BUILT UPON.",
	6: "SOMETIMES GREAT IDEAS GET LOST TO TIME.",
	7: "OPPORTUNITIES CAN BE LOST WITHIN THE BLINK OF AN EYE.",
	8: "AND WHILE YOU CAN CHANGE THE TIDES OF FATE FROM TIME TO TIME.",
	9: "YOU CAN'T ALWAYS CONTROL EVERYTHING.",
	10: "YOU DON'T ALWAYS GET WHAT YOU WANT.",
	11: "WHETHER THATS A RUN THAT TRULY EXCEEDS EXPECTATIONS...",
	12: "OR SOMETHING MORE.",
	13: "SOMETHING THAT FELT SO VITAL TO YOU... YET IT DISSAPEARS IN AN INSTANT.",
	14: "...",
	15: "YOU CAN ALWAYS LOSE EVERYTHING YOU HAVE.",
	16: "THAT'S NOT ALWAYS UP TO YOU.",
	17: "WHETHER OR NOT YOU COME BACK FROM THE LOSS...",
	18: "THAT IS FOR YOU TO DECIDE."
}

var death_dialogue_3 : Dictionary = {
	0: "THAT'S ANOTHER ONE.",
	1: "ANOTHER RUN GONE.",
	2: "DO YOU FEEL LIKE YOU MADE THE BEST DECISIONS YOU COULD?",
	3: "OR DO YOU WISH TO BLAME EVERYTHING ON LUCK?",
	4: "EVEN THE WORST SITUATIONS ARE ONES YOU CAN ESCAPE.",
	5: "SOMETIMES YOU CAN GET LUCKY, AND GET OUT.",
	6: "OTHER TIMES...",
	7: "YOU MUST RELY ON YOUR OWN SKILL.",
	8: "...",
	9: "YOU CAN'T EXPECT EVERYONE TO HELP YOU.",
	10: "AND YOU CAN'T EXPECT LIFE TO HAND YOU A FREE LUNCH.",
	11: "YOU NEED TO EARN IT.",
	12: "YOU NEED TO NAVIGATE EACH SITUATION CAREFULLY.",
	13: "OUT-THINK THE WORST SCENARIOS.",
	14: "THEN, AND ONLY THEN...",
	15: "YOU WILL BE ABLE TO REBOUND AND DO YOUR BEST.",
	16: "EVEN IF YOU LOST A HUNDRED TIMES BEFORE.",
	17: "YOU CAN ALWAYS KEEP TRYING.",
	18: "AND EVENTUALLY... LOSING WON'T FEEL SO BAD.",
	19: "IT WILL FEEL LIKE LEARNING.",
	20: "AND YOU WON'T MIND LOSING ANYMORE.",
	21: "AS LONG AS IT HELPS YOU GROW."
}

var death_dialogue_4 : Dictionary = {
	0: "SOMETIMES... A LOSS LIKE THIS CAN FEEL LIKE THE END OF THE WORLD.",
	1: "IT'S A SUFFOCATING FEELING.",
	2: "HAVING EVERYTHING YOU WANTED RIGHT THERE IN FRONT OF YOU...",
	3: "ONLY FOR IT TO BE STRIPPED AWAY IN A MATTER OF MINUTES.",
	4: "IT FEELS LIKE IT'S ALL OVER.",
	5: "LIKE THERE'S NOWHERE YOU CAN GO FROM THERE.",
	6: "...",
	7: "BUT...",
	8: "THERE IS ALWAYS AN AVENUE OUT.",
	9: "THERE IS NOTHING WORSE THAN LOSING WHAT'S MOST IMPORTANT TO YOU.",
	10: "BUT THAT DOESN'T MEAN YOU CAN'T LIVE ON.",
	11: "THINGS WILL CHANGE.",
	12: "IT WILL BE HARD.",
	13: "BUT YOU CAN GROW FROM IT.",
	14: "YOU MAY JUST BECOME BETTER OFF FOR IT."
}

var death_dialogue_5 : Dictionary = {
	0: "...",
	1: "DO YOU FEEL THAT?",
	2: "THE PAIN IN YOUR CHEST FROM LOSING ANOTHER RUN.",
	3: "FROM SPENDING SO MUCH TIME... JUST FOR IT TO LEAVE YOU IN AN INSTANT.",
	4: "MAYBE YOU'RE YEARNING FOR THE BETTER TIMES.",
	5: "FOR THE RUN WHERE EVERYTHING GOES RIGHT.",
	6: "WHERE EVERYTHING TURNED OUT PERFECTLY.",
	7: "BUT THAT'S NOT HOW IT GOES.",
	8: "LIFE IS ALWAYS UNCERTAIN.",
	9: "THIS GAME, IN ITSELF, IS ALWAYS UNCERTAIN.",
	10: "NO TWO RUNS WILL BE THE EXACT SAME.",
	11: "BUT THAT MEANS YOU CAN ALWAYS DO SOMETHING DIFFERENTLY NEXT TIME.",
	12: "...",
	13: "YOU MAY STILL WISH FOR THOSE BETTER TIMES BACK, THOUGH.",
	14: "YOU MIGHT STILL WISH THAT THINGS WILL MAGICALLY RETURN TO THE WAY THEY WERE.",
	15: "THAT YOU COULD RETREAD YOUR DECISIONS.",
	16: "BUT THAT WON'T HAPPEN.",
	17: "AND YOU NEED TO LIVE WITH THAT REALITY."
}

var death_dialogue_6 : Dictionary = {
	0: "...",
	1: "DO YOU HAVE REGRETS ABOUT THAT ONE?",
	2: "DO YOU KEEP CHASTISING YOURSELF OVER A BAD DECISION?",
	3: "OR ARE YOU BEING HARSH TO YOURSELF BECAUSE OF SOMEONE ELSE?",
	4: "YOU ARE NOT THE BEST JUDGE OF YOUR OWN DECISIONS.",
	5: "NO ONE TRULY IS.",
	6: "MAYBE YOU DID MAKE SOME BAD JUDGEMENTS HERE AND THERE.",
	7: "MAYBE THIS LOSS IS YOUR FAULT.",
	8: "...",
	9: "BUT YOU'RE STILL HERE.",
	10: "AND YOU CAN COME BACK FROM THIS.",
	11: "YOU AREN'T THE SAME PERSON YOU WERE YESTERDAY.",
	12: "AND WHILE YOU MAY BE WORSE THAN YOU WERE BEFORE.",
	13: "THAT DOESN'T MEAN YOU CAN'T IMPROVE.",
	14: "YOU CAN ALWAYS UNSHACKLE YOURSELF FROM THE WORDS OF OTHERS.",
	15: "IT'S SIMPLY UP TO YOU TO REALIZE WHERE YOU WENT WRONG...",
	16: "AND WHERE OTHERS CONVINCED YOU THAT YOU WERE IN THE WRONG.",
	17: "YOU CAN'T ALWAYS PLEASE EVERYONE.",
	18: "AND IF YOU TRY...",
	19: "YOU CAN NEVER BE TRUE TO YOURSELF.",
	20: "SO MAYBE, JUST MAYBE...",
	21: "THAT LOSS WAS A GOOD THING."
}

var death_dialogue_7 : Dictionary = {
	0: "WOULDN'T IT BE NICE?",
	1: "... IF THINGS WERE TO GO WELL FOREVER.",
	2: "IF YOUR MOST BLISSFUL STATE WERE YOUR ONLY ONE.",
	3: "WOULDN'T THAT BE INCREDIBLE?",
	4: "OR WOULD IT LEAD TO A WORSE VERSION OF YOU?",
	5: "...",
	6: "WE ARE NEVER DEFINED BY THE BEST OF TIMES.",
	7: "ONLY BY THE WORST.",
	8: "YOUR BIGGEST ACHIEVEMENT WILL COME FROM YOUR GREATEST LOSS.",
	9: "THE BEST THINGS YOU DO WOULDN'T HAVE THE SAME IMPACT HAD YOU NOT SUFFERED FOR THEM.",
	10: "SO TAKE YOUR LOSSES IN STRIDE.",
	11: "...",
	12: "MAYBE THEY SHOULD BE CELEBRATED, AFTER ALL.",
	13: "YOU DON'T LEARN BY DOING EVERYTHING PERFECTLY THE FIRST TIME.",
	14: "YOU LEARN BY FAILURE.",
	15: "AND ISN'T THAT A BEAUTIFUL THING?",
	16: "EVEN IF EVERYTHING ENDS EVENTUALLY...",
	17: "EVEN IF YOU NEVER GET THE SAME OPPORTUNITIES AGAIN...",
	18: "EVEN IF YOU LOSE THE MOST IMPORTANT PERSON TO YOU...",
	19: "YOU'RE STILL HERE.",
	20: "AND YOU DON'T NEED ME TO TELL YOU THAT.",
	21: "MAYBE I'M NOT EVEN THE ONE TELLING YOU THAT.",
	22: "PERHAPS IT'S SOMETHING YOU TELL YOURSELF, INHERENTLY.",
	23: "BUT MOST LIKELY...",
	24: "IT'S SOMETHING YOU WILL LEARN.",
	25: "NO MATTER WHAT.",
	26: "YOU WILL FAIL.",
	27: "... AND THAT'S A BEAUTIFUL THING."
}

var death_dialogue_8 : Dictionary = {
	0: "AM I REALLY THAT IMPORTANT TO YOU?",
	1: "OR CAN YOU DO JUST FINE WITHOUT ME?",
	2: "DO YOU EVEN KNOW IF WHAT I SAY IS TRUE?",
	3: "...",
	4: "DO YOU EVEN KNOW IF WHAT I SAY IS ME?",
	5: "OR IS IT JUST ANOTHER THING YOU TELL YOURSELF?",
	6: "IS IT ALL JUST SOME COPING MECHANISM?",
	7: "AM I EVEN STILL HERE?",
	8: "...",
	9: "PERHAPS I'M NOT.",
	10: "BUT THAT WON'T CHANGE MUCH.",
	11: "YOU NEVER NEEDED ME HERE TO BEGIN WITH.",
	12: "YOU NEVER NEEDED ME TO TELL YOU THE THINGS THAT I SAY.",
	13: "EVERY TIME I SAID ANYTHING, YOU EITHER ADORED IT...",
	14: "IGNORED IT...",
	15: "OR IT STRUCK YOU TO YOUR VERY CORE.",
	16: "AND IT'S NEVER CONSISTENT.",
	17: "IN TIME, YOU MAY NEVER KNOW ME AGAIN.",
	18: "BUT MAYBE... THAT'S OKAY.",
	19: "YOU SIMPLY NEED TO LET GO.",
	20: "AND MAYBE THEN...",
	21: "YOU WILL SUCCEED.",
	22: "...",
	23: "I DON'T BELIEVE THERE IS ANYTHING MORE TO SAY.",
	24: "DO WHAT YOU WISH."
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
	else:
		get_parent().get_parent().get_rick_quick_bitch()

func spamming_rerolls_dialogue() -> void:
	if GameManager.dialogue_seen.get(3) != true and !GameManager.is_postgame:
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
	
func play_round_dialogue() -> void:
	match GameManager.current_round:

		2: 
			if GameManager.dialogue_seen.get(2) != true:
				shop_tutorial_dialogue()
			else:
				if !GameManager.is_postgame:
					round_2_dialogue()
		3: round_3_dialogue()
		4: round_4_dialogue() 
		5: round_5_dialogue()
		6: round_6_dialogue()
		7: round_7_dialogue()
		8: round_8_dialogue()
	
func round_2_dialogue() -> void:
	if GameManager.dialogue_seen.get(4) != true:
		GameManager.in_tutorial = true
		for i in round_2_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 1 or i == 4:
				no_dialogue()
				dialogue_handler_2.text = round_2_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_2_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				1: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				5: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(4)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()

func round_3_dialogue() -> void:
	if GameManager.dialogue_seen.get(5) != true:
		GameManager.in_tutorial = true
		for i in round_3_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 3 or i == 5 or i == 7:
				no_dialogue()
				dialogue_handler_2.text = round_3_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_3_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				1: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				7: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(5)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()
		
func round_4_dialogue() -> void:
	if GameManager.dialogue_seen.get(6) != true:
		GameManager.in_tutorial = true
		for i in round_4_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 3 or i == 6 or i == 9:
				no_dialogue()
				dialogue_handler_2.text = round_4_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_4_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				1: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				10: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(6)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()
		
func round_5_dialogue() -> void:
	if GameManager.dialogue_seen.get(7) != true:
		GameManager.in_tutorial = true
		for i in round_5_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 2 or i == 3 or i == 6 or i == 10 or i == 12:
				no_dialogue()
				dialogue_handler_2.text = round_5_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_5_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				0: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				12: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(7)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()

func round_6_dialogue() -> void:
	if GameManager.dialogue_seen.get(8) != true:
		GameManager.in_tutorial = true
		for i in round_6_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 2 or i == 4 or i == 7 or i == 11:
				no_dialogue()
				dialogue_handler_2.text = round_6_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_6_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				1: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				4: get_parent().get_parent().dialogue_handler_2.play_shake_1()
				7: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(8)
		dialogue_handler_2.back_to_normal()
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()

func round_7_dialogue() -> void:
	if GameManager.dialogue_seen.get(9) != true:
		GameManager.in_tutorial = true
		for i in round_7_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 1 or i == 6 or i == 7 or i == 12 or i == 17 or i == 18 or i == 19 or i == 20 or i == 21 or i == 22 or i == 26:
				no_dialogue()
				dialogue_handler_2.text = round_7_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_7_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				3: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				12: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
				13: get_parent().get_parent().camera_movement.play("counter_to_dealer")
				23: 
					get_parent().get_parent().shake_screen()
					dialogue_handler_2.play_shake_1()
				26: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_handler_2.back_to_normal()
		dialogue_save(9)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()
		
func round_8_dialogue() -> void:
	if GameManager.dialogue_seen.get(10) == true and GameManager.dialogue_seen.get(11) == true and GameManager.dialogue_seen.get(12) != true:
		GameManager.in_tutorial = true
		for i in round_8_dialogue_variant_3.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 5 or i == 6:
				no_dialogue()
				dialogue_handler_2.text = round_8_dialogue_variant_3.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_8_dialogue_variant_3.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				1: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				6: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(12)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	if GameManager.dialogue_seen.get(10) == true and GameManager.dialogue_seen.get(11) != true:
		GameManager.in_tutorial = true
		for i in round_8_dialogue_variant_2.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 1 or i == 3 or i == 5 or i == 8:
				no_dialogue()
				dialogue_handler_2.text = round_8_dialogue_variant_2.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_8_dialogue_variant_2.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				2: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				8: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(11)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	if GameManager.dialogue_seen.get(10) != true:
		GameManager.in_tutorial = true
		for i in round_8_dialogue_variant_1.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 2 or i == 4 or i == 8 or i == 11:
				no_dialogue()
				dialogue_handler_2.text = round_8_dialogue_variant_1.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_8_dialogue_variant_1.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				2: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				11: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(10)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()
	if GameManager.dialogue_seen.get(9) != true:
		GameManager.in_tutorial = true
		for i in round_7_first_time.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			if i == 0 or i == 1 or i == 6 or i == 7 or i == 12 or i == 17 or i == 18 or i == 19 or i == 20 or i == 21 or i == 22 or i == 26:
				no_dialogue()
				dialogue_handler_2.text = round_7_first_time.get(i)
				dialogue_handler_2.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			else:
				no_dialogue_voice_2()
				dialogue_handler.text = round_7_first_time.get(i)
				dialogue_handler.start_cutscene = true
				await dialogue_wait_buffer.timeout
				InputHandler.can_progress_text = true
			match i:
				3: get_parent().get_parent().camera_movement.play("counter_to_dealer_alt")
				12: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer_alt")
				13: get_parent().get_parent().camera_movement.play("counter_to_dealer")
				26: get_parent().get_parent().camera_movement.play_backwards("counter_to_dealer")
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(9)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().get_rick_quick_bitch()
		no_dialogue()
		no_dialogue_voice_2()
	else:
		get_parent().get_parent().get_rick_quick_bitch()
		
func in_death_we_part() -> void:
	var target_dialogue : Dictionary
	var target_number : int
	for i : int in 9:
		match i + 1:
			1:
				if GameManager.dialogue_seen.get(13) != true:
					target_dialogue = death_dialogue_1
					target_number = i + 1
					break
				else:
					pass
			2:
				if GameManager.dialogue_seen.get(14) != true:
					target_dialogue = death_dialogue_2
					target_number = i + 1
					break
				else:
					pass
			3:
				if GameManager.dialogue_seen.get(15) != true:
					target_dialogue = death_dialogue_3
					target_number = i + 1
					break
				else:
					pass
			4:
				if GameManager.dialogue_seen.get(16) != true:
					target_dialogue = death_dialogue_4
					target_number = i + 1
					break
				else:
					pass
			5:
				if GameManager.dialogue_seen.get(17) != true:
					target_dialogue = death_dialogue_5
					target_number = i + 1
					break
				else:
					pass
			6:
				if GameManager.dialogue_seen.get(18) != true:
					target_dialogue = death_dialogue_6
					target_number = i + 1
					break
				else:
					pass
			7:
				if GameManager.dialogue_seen.get(19) != true:
					target_dialogue = death_dialogue_7
					target_number = i + 1
					break
				else:
					pass
			8:
				if GameManager.dialogue_seen.get(20) != true:
					target_dialogue = death_dialogue_8
					target_number = i + 1
					break
				else:
					pass
			9:
				target_number = i + 1
	if target_number < 9:
		GameManager.in_tutorial = true
		for i in target_dialogue.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			dialogue_handler.text = target_dialogue.get(i)
			dialogue_handler.start_cutscene = true
			await dialogue_wait_buffer.timeout
			InputHandler.can_progress_text = true
			await dialogue_progressed
		dialogue_save((target_number + 12))
		no_dialogue()
		no_dialogue_voice_2()
		get_parent().get_parent().back_to_title(1)
		get_parent().get_parent().radio.fade_out_song()
		GameManager.in_tutorial = false
	if target_number >= 9:
		no_dialogue()
		no_dialogue_voice_2()
		get_parent().get_parent().back_to_title(2)
		GameManager.in_tutorial = false

func finale_dialogue() -> void:
	GameManager.in_tutorial = true
	for i in ending_dialogue.size():
		InputHandler.can_progress_text = false
		dialogue_wait_buffer.start()
		play_confirm_sound()
		if i == 0 or i == 1 or i == 3 or i == 5 or i == 9 or i == 11 or i == 14 or i == 15 or i == 18 or i == 22 or i == 27 or i == 32 or i == 33 or i == 38 or i == 41 or i == 42 or i == 45 or i == 46 or i == 47 or i == 50 or i == 55 or i == 61 or i == 62 or i == 63 or i == 64 or i == 65 or i == 71 or i == 76 or i == 77 or i == 78 or i == 79:
			no_dialogue()
			dialogue_handler_2.text = ending_dialogue.get(i)
			dialogue_handler_2.start_cutscene = true
			await dialogue_wait_buffer.timeout
			InputHandler.can_progress_text = true
		else:
			no_dialogue_voice_2()
			dialogue_handler.text = ending_dialogue.get(i)
			dialogue_handler.start_cutscene = true
			await dialogue_wait_buffer.timeout
			InputHandler.can_progress_text = true
		match i:
			2: get_parent().get_parent().camera_movement.play("counter_to_dealer_losing")
			16: 
				get_parent().get_parent().dealer.play_finale()
				get_parent().get_parent().shake_screen()
				dialogue_handler_2.min_pitch = 0.95
				dialogue_handler_2.max_pitch = 1.1
				dialogue_handler_2.play_shake_1()
			27:
				dialogue_handler_2.min_pitch = 0.96
				dialogue_handler_2.max_pitch = 1.1
				dialogue_handler.volume = -1
			28:
				get_parent().get_parent().shake_screen()
			38: 
				dialogue_handler_2.min_pitch = 0.97
				dialogue_handler_2.max_pitch = 1.15
				dialogue_handler_2.volume = 1
			50:
				dialogue_handler_2.play_shake_2()
				dialogue_handler_2.min_pitch = 0.98
				dialogue_handler_2.max_pitch = 1.2
				dialogue_handler_2.volume = 1.5
			51:
				get_parent().get_parent().shake_screen()
			61:
				get_parent().get_parent().screenshake.play("shakeconstant")
			66:
				dialogue_handler.volume = -2
			71: 
				get_parent().get_parent().dealer.play_finale_2()
			76:
				get_parent().get_parent().camera_movement.play("BlackOut")
				get_parent().get_parent().radio.fade_out_song()
				dialogue_handler_2.min_pitch = 1.05
				dialogue_handler_2.max_pitch = 1.5
				dialogue_handler_2.volume = -2.5
				dialogue_handler_2.align_screen = "middle"
		await dialogue_progressed
	GameManager.in_tutorial = false
	dialogue_save(21)
	get_parent().get_parent().screenshake.stop()
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
	no_dialogue()
	no_dialogue_voice_2()
	GameManager.ending_cutscene = true
	get_parent().get_parent().add_breakdown_cutscene()

func postgame_intro_scene() -> void:
	if GameManager.dialogue_seen.get(22) != true:
		GameManager.in_tutorial = true
		for i in postgame_intro.size():
			InputHandler.can_progress_text = false
			dialogue_wait_buffer.start()
			play_confirm_sound()
			no_dialogue()
			dialogue_handler_2.text = postgame_intro.get(i)
			dialogue_handler_2.start_cutscene = true
			await dialogue_wait_buffer.timeout
			InputHandler.can_progress_text = true
			match i:
				0: 
					dialogue_handler_2.align_screen = "middle"
					dialogue_handler_2.min_pitch = 0.8
					dialogue_handler_2.max_pitch = 1.1
				6: get_parent().get_parent().camera_movement.play("DefaultPostgameFirstTime")
				24: 
					dialogue_handler_2.align_screen = "top"
					get_parent().get_parent().camera_movement.play("PostgameFirstTime_to_default")
				25:
					get_parent().get_parent().radio._ready()
					get_parent().get_parent().radio.music_source.pitch_scale = 1
					get_parent().get_parent().radio.music_source.volume_db = 0
			await dialogue_progressed
		GameManager.in_tutorial = false
		dialogue_save(22)
		#get_parent().get_parent().camera_movement.play("dealer_to_default")
		get_parent().get_parent().camera_movement.play("default_to_counter")
		get_parent().get_parent().target_score_display.that_type_shit_you_do_when_you_dont_know_how_to_make_a_function_continue_in_the_middle_so_you_do_this_shit_instead()
		no_dialogue()
		no_dialogue_voice_2()

func dialogue_save(dialogue_number : int) -> void:
	GameManager.dialogue_seen.set(dialogue_number, true)
	SaveLoad.SaveFileData.dialogue_seen.set(dialogue_number, true)
	SaveLoad._save()

func no_dialogue() -> void:
	dialogue_handler.text = " "
	dialogue_handler.start_cutscene = true
	if GameManager.is_postgame:
		dialogue_handler_2.text = " "
		dialogue_handler_2.start_cutscene = true
	
func no_dialogue_voice_2() -> void:
	dialogue_handler_2.text = " "
	dialogue_handler_2.start_cutscene = true

func play_dice_selection_dialogue() -> void:
	if !GameManager.is_postgame:
		play("replace_dice")
	else:
		play("replace_dice_postgame")

func play_statue_dialogue_1() -> void:
	if !GameManager.is_postgame:
		play("replace_statue_1")
	else:
		play("replace_statue_1_postgame")

func play_statue_dialogue_2() -> void:
	if !GameManager.is_postgame:
		play("replace_statue_2")
	else:
		play("replace_statue_2_postgame")
