extends Node3D

@onready var nametag: Label3D = $Name
@onready var description_label: Label3D = $Description
@onready var icon: MeshInstance3D = $Icon
@export var shop_slot : int = 0
@export var ticket_price : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var rarity_numbers : Array = [1, 2, 3, 4]
@export var weight_probabilities : Array = [10, 5, 2, 0.5]
var random_value : int

var item_name : String
var tooltip : String
var rarity : String
var description : String
@export var item_type : String = "Ticket"

var random_ticket_choice : int

#all the ticket textures

#common upgrade textures
var ONES := load("uid://c1xnyqu2ub30a")
var TWOS := load("uid://be5nvu3qm0vho")
var THREES := load("uid://44a6d5qamiuf")
var FOURS := load("uid://bugtfutk2cwka")
var MONEYGAIN := load("uid://cuknkloaylgqj")
var REROLL_UPGRADES := load("uid://h48lqwc8sdab")
var SHOPCARDSLOTS := load("uid://byfvta3jy6s12")
var REROLL_SYMBOL := load("uid://dxmk0u03op0pe")

#uncommon upgrade textures
var CHOICE := load("uid://dw7nmpk7bvvuk")
var LOWER_SMALL_STRAIGHT_FLOOR := load("uid://63pedn3x236b")
var SMALLSTRAIGHTS := load("uid://dkniro058vyl7")
var UPGRADEFULLHOUSE := load("uid://c2c4vd65ofjc2")
var FIVES := load("uid://coxtna3knmwv2")
var SIXES := load("uid://dquxw88iko0mu")
var SHOPDICESLOTS := load("uid://cgm0yq3mgtfwd")

#rare upgrade textures
var CARDSLOT := load("uid://4a7bx7uqwkhq")
var DICESLOTUPGRADE := load("uid://bon43gwtyrfly")
var FOUR_OF_A_KIND := load("uid://gwkqfjsv3lu2")
var FOUROFAKINDLOWERFLOOR := load("uid://jabs1pxp48lv")
var LARGESTRAIGHT := load("uid://dafdddggpgx5w")
var LARGESTRAIGHTLOWERFLOOR := load("uid://keny4oswp477")

#legendary upgrade textures
var SHOPTICKETSLOTS := load("uid://cpp2q7vx6m2g2")
var STATUESHOPSLOTS := load("uid://c200ypxxr1ljv")
var STATUESLOTUPGRADE := load("uid://5twwr2mau3rm")
var YACHTLOWERFLOOR := load("uid://dbtrucpah0l6r")
var YACHT_UPGRADE := load("uid://bmrtiav1mj1j")

var common_upgrades_taken
var uncommon_upgrades_taken
var rare_upgrades_taken
var legendary_upgrades_taken


func _ready() -> void:
	await get_tree().process_frame
	common_upgrades_taken = get_parent().get_parent().common_upgrades_taken
	uncommon_upgrades_taken = get_parent().get_parent().uncommon_upgrades_taken
	rare_upgrades_taken = get_parent().get_parent().rare_upgrades_taken
	legendary_upgrades_taken = get_parent().get_parent().legendary_upgrades_taken

var common_upgrades : Dictionary = {
	1:
		ONES,
	2:
		TWOS,
	3:
		THREES,
	4:
		FOURS,
	5:
		MONEYGAIN,
	6:
		REROLL_UPGRADES,
	7:
		SHOPCARDSLOTS,
	8: 
		REROLL_SYMBOL
}

var uncommon_upgrades : Dictionary = {
	1:
		CHOICE,
	2:
		LOWER_SMALL_STRAIGHT_FLOOR,
	3:
		SMALLSTRAIGHTS,
	4:
		UPGRADEFULLHOUSE,
	5:
		FIVES,
	6:
		SIXES,
	7:
		SHOPDICESLOTS,
	8:
		SHOPDICESLOTS
}

var rare_upgrades : Dictionary = {
	1:
		CARDSLOT,
	2:
		CARDSLOT,
	3:
		DICESLOTUPGRADE,
	4:
		DICESLOTUPGRADE,
	5:
		FOUR_OF_A_KIND,
	6:
		FOUROFAKINDLOWERFLOOR,
	7:
		LARGESTRAIGHT,
	8:
		LARGESTRAIGHTLOWERFLOOR
}

var legendary_upgrades : Dictionary = {
	1:
		SHOPTICKETSLOTS,
	2:
		STATUESHOPSLOTS,
	3:
		STATUESLOTUPGRADE,
	4:
		STATUESLOTUPGRADE,
	5:
		YACHTLOWERFLOOR,
	6:
		YACHT_UPGRADE
}



var common_upgrades_descriptions : Dictionary = {
	1:
		"Upgrades the multiplier for the Ones category by 2x its current value.",
	2:
		"Upgrades the multiplier for the Twos category by 2x its current value.",
	3:
		"Upgrades the multiplier for the Threes category by 2x its current value.",
	4:
		"Upgrades the multiplier for the fours category by 2x its current value.",
	5:
		"Gain extra gold each round.",
	6:
		"Gain an extra reroll coin every round.",
	7:
		"One more card will appear in the shop for the rest of this run.",
	8:
		"Reroll this shop."
}

var uncommon_upgrades_descriptions : Dictionary = {
	1:
		"Upgrades the multiplier for the Choice category by 1.5x its current value.",
	2: 
		"Allows Small Straights to be made with 3 Dice instead of four.",
	3:
		"Upgrades the multiplier for the Small Straight category by 2x its current value.",
	4:
		"Upgrades the multiplier for the Full House category by 2.5x its current value.",
	5:
		"Upgrades the multiplier for the fives category by 2x its current value.",
	6:
		"Upgrades the multiplier for the sixes category by 2x its current value.",
	7:
		"One more die will appear in this shop for the rest of the run.",
	8:
		"One more die will appear in this shop for the rest of the run."
}

var rare_upgrades_descriptions : Dictionary = {
	1:
		"Gives you another slot in your deck of cards.",
	2: 
		"Gives you another slot in your deck of cards.",
	3:
		"Gives the Dice Box another hole, allowing you to have one more die.",
	4:
		"Gives the Dice Box another hole, allowing you to have one more die.",
	5:
		"Upgrades the multiplier for the Four of a Kind category by 3x its current value.",
	6:
		"Allows you to have a valid Four of a Kind with only three dice of the same value.",
	7:
		"Upgrades the multiplier for the Large Straight category by 3.5x its current value.",
	8:
		"Allows you to make a Large Straight with only four dice."
}

var legendary_upgrades_descriptions : Dictionary = {
	1:
		"One more ticket will appear in the shop for the rest of this run.",
	2: 
		"One more statue will appear in the shop for the rest of this run.",
	3:
		"Removes one of the dividers from the statue stand, allowing you to hold one more statue.",
	4:
		"Removes one of the dividers from the statue stand, allowing you to hold one more statue.",
	5:
		"Lowers the floor for Yachts, allowing you to make them with only four dice.",
	6:
		"Upgrades the multiplier for the Yacht category by 5x its current value."
}



var common_upgrades_names : Dictionary = {
	1:
		"Upgrade Ones",
	2:
		"Upgrade Twos",
	3:
		"Upgrade Threes",
	4:
		"Upgrade Fours",
	5:
		"Upgrade Money Gain",
	6:
		"Upgrade Rerolls",
	7:
		"Shop Expansion: Cards",
	8:
		"Shop Reroll"
}

var uncommon_upgrades_names : Dictionary = {
	1:
		"Upgrade Choice",
	2:
		"Lower Small Straight Floor",
	3:
		"Upgrade Small Straights",
	4:
		"Upgrade Full House",
	5:
		"Upgrade Fives",
	6:
		"Upgrade Sixes",
	7:
		"Shop Expansion: Dice",
	8:
		"Shop Expansion: Dice"
}

var rare_upgrades_names : Dictionary = {
	1:
		"Upgrade Card Slots",
	2:
		"Upgrade Card Slots",
	3:
		"Upgrade Dice Slots",
	4:
		"Upgrade Dice Slots",
	5:
		"Upgrade Four of a Kind",
	6:
		"Lower Four of a Kind Floor",
	7:
		"Upgrade Large Straight",
	8:
		"Lower Large Straight Floor"
}

var legendary_upgrades_names : Dictionary = {
	1:
		"Shop Expansion: Tickets",
	2:
		"Shop Expansion: Statues",
	3:
		"Upgrade Statue Slots",
	4:
		"Upgrade Statue Slots",
	5:
		"Lower Yacht Floor",
	6:
		"Upgrade Yacht"
}



var common_upgrades_tooltips : Dictionary = {
	1:
		"For those lonely singles in your life.",
	2:
		"For all the lovely couples out there.",
	3:
		"For the polycules out there.",
	4:
		"Work on your quads.",
	5:
		"Step 1, Buy Ticket. Step 2, Get Money. Step 3, ????. Step 4, Profit.",
	6:
		"Flip a coin. If it lands on heads you get another roll, if it lands on tails you also get another roll.",
	7:
		"Thankfully they're just playing cards. If they were jokers, that would be blatant copyright infringement.",
	8:
		"This is the kind of greed they talked about in the Bible."
}

var uncommon_upgrades_tooltips : Dictionary = {
	1:
		"The ever-loved catch-all solution.",
	2:
		"We all skip a step here and there.",
	3:
		"Climb until your arms fall off.",
	4:
		"Now hosting more tenants.",
	5:
		"Five. Hundred. Points.",
	6:
		"They say it's the devil's number, but thats just 9 propaganda.",
	7:
		"You may have lost your marbles, but at least you'll always have dice.",
	8:
		"You may have lost your marbles, but at least you'll always have dice."
}

var rare_upgrades_tooltips : Dictionary = {
	1:
		"Hoard more cards, this time without a binder.",
	2:
		"Hoard more cards, this time without a binder.",
	3:
		"Can't get enough dice? Just get more holes!",
	4:
		"Can't get enough dice? Just get more holes!",
	5:
		"Like a quad-barrel shotgun, but nowhere near as cool.",
	6:
		"''Isn't that just three of a kind?'' Is two slices of bread with air in-between a sandwich?",
	7:
		"Feels just like running up the stairs on all fours.",
	8:
		"The stairway to heaven doesn't have a railing."
}

var legendary_upgrades_tooltips : Dictionary = {
	1:
		"More upgrades means more opportunities to upgrade a category you don't need!",
	2:
		"They're kinda hard to stuff into the same box, I hope this is an acceptable solution.",
	3:
		"You'll eventually proc that 6 statue combo that wins every run instantly, I'm sure.",
	4:
		"You'll eventually proc that 6 statue combo that wins every run instantly, I'm sure.",
	5:
		"''Isn't that just four of a kind?'' Yeah. What are you gonna do about it?",
	6:
		"The unsinkable ship will sail another day."
}



func generate_ticket() -> void:
	if get_parent().get_parent().get_parent().ticket_shop_slots_unlocked < shop_slot:
		visible = false
		return
	animation_player.play("RESET")
	var random_weight := GameManager.rng_shops
	random_value = rarity_numbers[random_weight.rand_weighted(weight_probabilities)]
	if shop_slot == 6:
		GameManager.ticket_1_choice_1 = random_value
	ticket_price = random_value * 3
	match random_value:
		1:
			random_ticket_choice = GameManager.rng_shops.randi_range(1, common_upgrades.size())
			if shop_slot == 6:
				GameManager.ticket_1_choice_2 = random_ticket_choice
			if shop_slot == 7:
				if GameManager.ticket_1_choice_1 == random_value and GameManager.ticket_1_choice_1 == random_ticket_choice:
					generate_ticket()
					return
			if common_upgrades_taken.get(random_ticket_choice) == true:
				generate_ticket()
				return
			icon.get_active_material(0).albedo_texture = common_upgrades.get(random_ticket_choice)
			description_label.text = common_upgrades_descriptions.get(random_ticket_choice)
			nametag.text = common_upgrades_names.get(random_ticket_choice)
			item_name = common_upgrades_names.get(random_ticket_choice)
			tooltip = common_upgrades_tooltips.get(random_ticket_choice)
			rarity = "Common"
			description = "Upon purchasing, " + common_upgrades_descriptions.get(random_ticket_choice)
		2:
			random_ticket_choice = GameManager.rng_shops.randi_range(1, 8)
			if shop_slot == 6:
				GameManager.ticket_1_choice_2 = random_ticket_choice
			if shop_slot == 7:
				if GameManager.ticket_1_choice_1 == random_value and GameManager.ticket_1_choice_1 == random_ticket_choice:
					generate_ticket()
					return
			if uncommon_upgrades_taken.get(random_ticket_choice) == true:
				generate_ticket()
				return
			icon.get_active_material(0).albedo_texture = uncommon_upgrades.get(random_ticket_choice)
			description_label.text = uncommon_upgrades_descriptions.get(random_ticket_choice)
			nametag.text = uncommon_upgrades_names.get(random_ticket_choice)
			item_name = uncommon_upgrades_names.get(random_ticket_choice)
			tooltip = uncommon_upgrades_tooltips.get(random_ticket_choice)
			rarity = "Uncommon"
			description = "Upon purchasing, " + uncommon_upgrades_descriptions.get(random_ticket_choice)
		3:
			random_ticket_choice = GameManager.rng_shops.randi_range(1, 8)
			if shop_slot == 6:
				GameManager.ticket_1_choice_2 = random_ticket_choice
			if shop_slot == 7:
				if GameManager.ticket_1_choice_1 == random_value and GameManager.ticket_1_choice_1 == random_ticket_choice:
					generate_ticket()
					return
			if rare_upgrades_taken.get(random_ticket_choice) == true:
				generate_ticket()
				return
			icon.get_active_material(0).albedo_texture = rare_upgrades.get(random_ticket_choice)
			description_label.text = rare_upgrades_descriptions.get(random_ticket_choice)
			nametag.text = rare_upgrades_names.get(random_ticket_choice)
			item_name = rare_upgrades_names.get(random_ticket_choice)
			tooltip = rare_upgrades_tooltips.get(random_ticket_choice)
			rarity = "Rare"
			description = "Upon purchasing, " + rare_upgrades_descriptions.get(random_ticket_choice)
		4:
			random_ticket_choice = GameManager.rng_shops.randi_range(1, 6)
			if shop_slot == 6:
				GameManager.ticket_1_choice_2 = random_ticket_choice
			if shop_slot == 7:
				if GameManager.ticket_1_choice_1 == random_value and GameManager.ticket_1_choice_1 == random_ticket_choice:
					generate_ticket()
					return
			if legendary_upgrades_taken.get(random_ticket_choice) == true:
				generate_ticket()
				return
			icon.get_active_material(0).albedo_texture = legendary_upgrades.get(random_ticket_choice)
			description_label.text = legendary_upgrades_descriptions.get(random_ticket_choice)
			nametag.text = legendary_upgrades_names.get(random_ticket_choice)
			item_name = legendary_upgrades_names.get(random_ticket_choice)
			tooltip = legendary_upgrades_tooltips.get(random_ticket_choice)
			rarity = "Legendary"
			description = "Upon purchasing, " + legendary_upgrades_descriptions.get(random_ticket_choice)
	
	get_parent().get_parent().get_parent().shop_items.set(shop_slot, self)
	get_parent().price_tag.inflation_is_a_bitch(ticket_price)
	get_parent().show_price()
	visible = true
	
func purchase_ticket() -> void:
	animation_player.play("death")
	match random_value:
		1:
			match random_ticket_choice:
				1:
					get_parent().get_parent().get_parent().score_sheet.ones_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "ones_multiplier")
				2:
					get_parent().get_parent().get_parent().score_sheet.twos_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "twos_multiplier")
				3:
					get_parent().get_parent().get_parent().score_sheet.threes_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "threes_multiplier")
				4:
					get_parent().get_parent().get_parent().score_sheet.fours_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "fours_multiplier")
				5:
					GameManager.permanent_money_increases += 1
				6:
					GameManager.max_rolls += 1
				7:
					get_parent().get_parent().get_parent().card_shop_slots_unlocked = 12
					get_parent().get_parent().card_generator_3.spawn_card()
					common_upgrades_taken.set(random_ticket_choice, true)
				8:
					get_parent().get_parent().get_parent().shop_box.shop_reroll()
		2:
			match random_ticket_choice:
				1:
					get_parent().get_parent().get_parent().score_sheet.choice_multiplier *= 1.5
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "choice_multiplier")
				2:
					get_parent().get_parent().get_parent().score_sheet.lower_small_straight_floor = true
					uncommon_upgrades_taken.set(2, true)
				3:
					get_parent().get_parent().get_parent().score_sheet.small_straight_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "small_straight_multiplier")
				4:
					get_parent().get_parent().get_parent().score_sheet.full_house_multiplier *= 2.5
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "full_house_multiplier")
				5:
					get_parent().get_parent().get_parent().score_sheet.fives_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "fives_multiplier")
				6:
					get_parent().get_parent().get_parent().score_sheet.sixes_multiplier *= 2
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "sixes_multiplier")
				7:
					get_parent().get_parent().get_parent().dice_shop_slots_unlocked += 1
					if get_parent().get_parent().get_parent().dice_shop_slots_unlocked == 4:
						get_parent().get_parent().dice_generator_4.create_dice()
					if get_parent().get_parent().get_parent().dice_shop_slots_unlocked == 5:
						get_parent().get_parent().dice_generator_5.create_dice()
					uncommon_upgrades_taken.set(random_ticket_choice, true)
				8:
					get_parent().get_parent().get_parent().dice_shop_slots_unlocked += 1
					if get_parent().get_parent().get_parent().dice_shop_slots_unlocked == 4:
						get_parent().get_parent().dice_generator_4.create_dice()
					if get_parent().get_parent().get_parent().dice_shop_slots_unlocked == 5:
						get_parent().get_parent().dice_generator_5.create_dice()
					uncommon_upgrades_taken.set(random_ticket_choice, true)
		3:
			match random_ticket_choice:
				1:
					get_parent().get_parent().get_parent().max_cards += 1
					rare_upgrades_taken.set(random_ticket_choice, true)
				2:
					get_parent().get_parent().get_parent().max_cards += 1
					rare_upgrades_taken.set(random_ticket_choice, true)
				3:
					get_parent().get_parent().get_parent().max_die += 1
					if get_parent().get_parent().get_parent().max_die == 6:
						get_parent().get_parent().get_parent().dice_box.unlock_slot_6()
					if get_parent().get_parent().get_parent().max_die == 7:
						get_parent().get_parent().get_parent().dice_box.unlock_slot_7()
					rare_upgrades_taken.set(random_ticket_choice, true)
				4:
					get_parent().get_parent().get_parent().max_die += 1
					if get_parent().get_parent().get_parent().max_die == 6:
						get_parent().get_parent().get_parent().dice_box.unlock_slot_6()
					if get_parent().get_parent().get_parent().max_die == 7:
						get_parent().get_parent().get_parent().dice_box.unlock_slot_7()
					rare_upgrades_taken.set(random_ticket_choice, true)
				5:
					get_parent().get_parent().get_parent().score_sheet.four_of_a_kind_multiplier *= 3
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "four_of_a_kind_multiplier")
				6:
					get_parent().get_parent().get_parent().score_sheet.lower_four_of_a_kind_floor = true
					rare_upgrades_taken.set(random_ticket_choice, true)
				7:
					get_parent().get_parent().get_parent().score_sheet.large_straight_multiplier *= 3.5
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "large_straight_multiplier")
				8:
					get_parent().get_parent().get_parent().score_sheet.lower_large_straight_floor = true
					rare_upgrades_taken.set(random_ticket_choice, true)
		4:
			match random_ticket_choice:
				1:
					get_parent().get_parent().get_parent().ticket_shop_slots_unlocked = 7
					get_parent().get_parent().ticket_generator_2.generate_ticket()
					legendary_upgrades_taken.set(random_ticket_choice, true)
				2:
					get_parent().get_parent().get_parent().statue_shop_slots_unlocked = 9
					get_parent().get_parent().statue_spawner_2.spawn_statue()
					legendary_upgrades_taken.set(random_ticket_choice, true)
				3:
					get_parent().get_parent().get_parent().max_statues += 1
					if get_parent().get_parent().get_parent().max_statues == 5:
						get_parent().get_parent().get_parent().statue_stand.divider_1_gone()
					if get_parent().get_parent().get_parent().max_statues == 6:
						get_parent().get_parent().get_parent().statue_stand.divider_2_gone()
					legendary_upgrades_taken.set(random_ticket_choice, true)
				4:
					get_parent().get_parent().get_parent().max_statues += 1
					if get_parent().get_parent().get_parent().max_statues == 5:
						get_parent().get_parent().get_parent().statue_stand.divider_1_gone()
					if get_parent().get_parent().get_parent().max_statues == 6:
						get_parent().get_parent().get_parent().statue_stand.divider_2_gone()
					legendary_upgrades_taken.set(random_ticket_choice, true)
				5:
					get_parent().get_parent().get_parent().score_sheet.lower_yacht_floor = true
					legendary_upgrades_taken.set(random_ticket_choice, true)
				6:
					get_parent().get_parent().get_parent().score_sheet.yacht_multiplier *= 5
					get_parent().get_parent().get_parent().score_sheet.buff_one_modifier(0, "yacht_multiplier")
	
