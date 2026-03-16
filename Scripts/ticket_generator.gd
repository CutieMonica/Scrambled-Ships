extends Node3D

@onready var nametag: Label3D = $Name
@onready var description_label: Label3D = $Description
@onready var icon: MeshInstance3D = $Icon
@export var shop_slot : int = 0
@export var ticket_price : int = 0

var item_name : String
var tooltip : String
var rarity : String
var description : String

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

var common_upgrades_taken : Dictionary = {
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
	7: false,
	8: false,
	9: false,
	10: false,
	11: false,
	12: false
}

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
		"Gain an extra 3 gold each round.",
	6:
		"Gain an extra reroll coin every round.",
	7:
		"One more card will appear in the shop for the rest of this run.",
	8:
		"Reroll this shop."
}

var common_upgrades_names : Dictionary = {
	1:
		"UPGRADE ONES",
	2:
		"UPGRADE TWOS",
	3:
		"UPGRADE THREES",
	4:
		"UPGRADE FOURS",
	5:
		"UPGRADE MONEY GAIN",
	6:
		"UPGRADE REROLLS",
	7:
		"SHOP EXPANSION: CARDS",
	8:
		"SHOP REROLL"
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

func generate_ticket() -> void:
	if get_parent().get_parent().get_parent().ticket_shop_slots_unlocked < shop_slot:
		visible = false
		return
	random_ticket_choice = GameManager.rng_upgrades.randi_range(1, common_upgrades.size())
	ticket_price = 3
	icon.get_active_material(0).albedo_texture = common_upgrades.get(random_ticket_choice)
	description_label.text = common_upgrades_descriptions.get(random_ticket_choice)
	nametag.text = common_upgrades_names.get(random_ticket_choice)
	item_name = common_upgrades_names.get(random_ticket_choice)
	tooltip = common_upgrades_tooltips.get(random_ticket_choice)
	rarity = "Common"
	description = "Upon purchasing, " + common_upgrades_descriptions.get(random_ticket_choice)
	get_parent().get_parent().get_parent().shop_items.set(shop_slot, self)
	get_parent().price_tag.inflation_is_a_bitch(ticket_price)
	get_parent().show_price()
	visible = true
	
func purchase_ticket() -> void:
	match random_ticket_choice:
		1:
			get_parent().get_parent().get_parent().score_sheet.ones_multiplier *= 2
		2:
			get_parent().get_parent().get_parent().score_sheet.twos_multiplier *= 2
		3:
			get_parent().get_parent().get_parent().score_sheet.threes_multiplier *= 2
		4:
			get_parent().get_parent().get_parent().score_sheet.fours_multiplier *= 2
		5:
			GameManager.permanent_money_increases += 3
		6:
			GameManager.max_rolls += 1
		7:
			get_parent().get_parent().get_parent().card_shop_slots_unlocked = 12
			get_parent().get_parent().card_generator_3.spawn_card()
			common_upgrades_taken.set(random_ticket_choice, true)
		8:
			get_parent().get_parent().get_parent().shop_box.shop_reroll()
			
