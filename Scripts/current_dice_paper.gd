extends Node3D

@onready var dice_icon_1: MeshInstance3D = $MeshInstance3D/DiceIcon1
@onready var dice_icon_2: MeshInstance3D = $MeshInstance3D/DiceIcon2
@onready var dice_icon_3: MeshInstance3D = $MeshInstance3D/DiceIcon3
@onready var dice_icon_4: MeshInstance3D = $MeshInstance3D/DiceIcon4
@onready var dice_icon_5: MeshInstance3D = $MeshInstance3D/DiceIcon5
@onready var dice_icon_6: MeshInstance3D = $MeshInstance3D/DiceIcon6
@onready var dice_icon_7: MeshInstance3D = $MeshInstance3D/DiceIcon7

const DICEICON_0 = preload("uid://c6n38nejmkdr3")
const DICEICON_1 = preload("uid://cbm8x16g8qie8")
const DICEICON_2 = preload("uid://sav82vfrtisa")
const DICEICON_3 = preload("uid://c2ln8a367huto")
const DICEICON_4 = preload("uid://caevfuh4vx2jp")
const DICEICON_5 = preload("uid://c340uuubsbhpl")
const DICEICON_6 = preload("uid://cgigm4ay80jlo")
const DICEICON_7 = preload("uid://dp80qvxntdufd")
const DICEICON_8 = preload("uid://c2wrt2ytjxt5n")
const DICEICON_9 = preload("uid://dhx4klmrnbv8c")
const DICEICON_10 = preload("uid://dlx5frnp3jx0r")
const DICEICON_11 = preload("uid://30rnemu28ltb")
const DICEICON_12 = preload("uid://d0sh4tefxphv6")
const DICEICON_13 = preload("uid://bes4a0fvxjnh8")
const DICEICON_14 = preload("uid://b61tms4n5iaj1")
const DICEICON_15 = preload("uid://ch6l6uvsnv266")
const DICEICON_16 = preload("uid://dy51gr0omsqq1")
const DICEICON_17 = preload("uid://dghhr257advdy")
const DICEICON_18 = preload("uid://djqv0yjixspe8")
const DICEICON_19 = preload("uid://bo2e87ddm5qfi")
const DICEICON_20 = preload("uid://8s5o8mhlr8u5")
const DICEICON_21 = preload("uid://d26cg38yei6ug")
const DICEICON_22 = preload("uid://dc0uia43x8bnp")
const DICEICON_23 = preload("uid://b62lo1fvfmbv6")
const DICEICON_24 = preload("uid://b61m34vmrhnqe")
const DICEICONNULL = preload("uid://ce1kcxiht77ss")

	
var dice_number_display: Dictionary = {
	1: dice_icon_1,
	2: dice_icon_2,
	3: dice_icon_3,
	4: dice_icon_4,
	5: dice_icon_5,
	6: dice_icon_6,
	7: dice_icon_7
}

var dice_images: Dictionary = {
	0: DICEICON_0,
	1: DICEICON_1,
	2: DICEICON_2,
	3: DICEICON_3,
	4: DICEICON_4,
	5: DICEICON_5,
	6: DICEICON_6,
	7: DICEICON_7,
	8: DICEICON_8,
	9: DICEICON_9,
	10: DICEICON_10,
	11: DICEICON_11,
	12: DICEICON_12,
	13: DICEICON_13,
	14: DICEICON_14,
	15: DICEICON_15,
	16: DICEICON_16,
	17: DICEICON_17,
	18: DICEICON_18,
	19: DICEICON_19,
	20: DICEICON_20,
	21: DICEICON_21,
	22: DICEICON_22,
	23: DICEICON_23,
	24: DICEICON_24,
	null: DICEICONNULL
}

func clear_dice_numbers():
	for i in 8:
		match i:
			1: 
				dice_icon_1.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_1.visible = false
			2:
				dice_icon_2.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_2.visible = false
			3:
				dice_icon_3.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_3.visible = false
			4:
				dice_icon_4.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_4.visible = false
			5:
				dice_icon_5.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_5.visible = false
			6:
				dice_icon_6.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_6.visible = false
			7:
				dice_icon_7.get_active_material(0).albedo_texture = DICEICONNULL
				dice_icon_7.visible = false

func update_dice_numbers(dice_position, dice_value):
	print(dice_number_display.get(dice_position))
	print("dice position for sheet is " + str(dice_position))
	#dice_number_display.get(dice_position).get_active_material(0).albedo_texture = dice_images.get(dice_value)
	match dice_position:
		1: 
			dice_icon_1.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_1.visible = true
		2:
			dice_icon_2.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_2.visible = true
		3:
			dice_icon_3.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_3.visible = true
		4:
			dice_icon_4.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_4.visible = true
		5:
			dice_icon_5.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_5.visible = true
		6:
			dice_icon_6.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_6.visible = true
		7:
			dice_icon_7.get_active_material(0).albedo_texture = dice_images.get(dice_value)
			dice_icon_7.visible = true
