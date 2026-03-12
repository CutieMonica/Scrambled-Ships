extends Node3D

@onready var nametag: Label3D = $Name
@onready var description: Label3D = $Description
@onready var icon: MeshInstance3D = $Icon

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
		"One more card will appear in the shop. This rerolls your current cards.",
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
#replace later
func _ready() -> void:
	generate_ticket()
	
func generate_ticket() -> void:
	var random_ticket_choice : int = GameManager.rng_upgrades.randi_range(1, common_upgrades.size())
	icon.get_active_material(0).albedo_texture = common_upgrades.get(random_ticket_choice)
	description.text = common_upgrades_descriptions.get(random_ticket_choice)
	nametag.text = common_upgrades_names.get(random_ticket_choice)
	
	
