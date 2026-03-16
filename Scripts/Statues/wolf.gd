extends Node3D

@export var base_modifier : int = 2
@export var current_category : String = "none"
@export var statue_name : String = "Wolf"
@export var color_shift_level : int = 4
@onready var statue_model_logic: Node3D = $StatueModelLogic
@onready var mesh: MeshInstance3D = $"WolfModel/Sketchfab_model/752cfc8e13e440bcaae116cf7f82ed7f_fbx/RootNode/wolf/wolf_Material_0"
@export var added_modifier : float
@onready var category_chosen: Label3D = $CategoryChosen
@onready var buff_text: Label3D = $BuffText
@export var trigger_condition : String = "RoundStart"
var has_given_modifier : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var item_name : String = "Wolf"
@export var tooltip : String = "Inside of you are two wolves. You should really get that checked out."
@export var description : String = "Statue Model
At the start of every round, the Wolf will pick a random category. It will then permanently boost that category by its current value. Not very affected by bases."

func randomize_category() -> void:
	if has_given_modifier:
		get_parent().get_parent().score_sheet.buff_one_modifier(-added_modifier, current_category)
	var random_category := GameManager.rng_statues.randi_range(1, 12)
	match random_category:
		1:
			current_category = "ones_multiplier"
		2:
			current_category = "twos_multiplier"
		3:
			current_category = "threes_multiplier"
		4:
			current_category = "fours_multiplier"
		5:
			current_category = "fives_multiplier"
		6:
			current_category = "sixes_multiplier"
		7:
			current_category = "choice_multiplier"
		8:
			current_category = "small_straight_multiplier"
		9:
			current_category = "large_straight_multiplier"
		10:
			current_category = "full_house_multiplier"
		11:
			current_category = "four_of_a_kind_multiplier"
		12:
			current_category = "yacht_multiplier"

func generate_value() -> void:
	var modifier_value : String = get_parent().statue_bottom_instance.statue_type
	match modifier_value:
		"Subtract":
			added_modifier = (base_modifier - (get_parent().statue_bottom_instance.base_statue_value * 0.1))
			buff_text.text = statue_model_logic.get_symbol() + str(added_modifier) + "X This Round"
		"Add":
			added_modifier = base_modifier + ((get_parent().statue_bottom_instance.base_statue_value * 0.1))
			buff_text.text = statue_model_logic.get_symbol() + str(added_modifier) + "X This Round"
func update_text() -> void:
	match current_category:
		"ones_multiplier":
			category_chosen.text = "Ones"
		"twos_multiplier":
			category_chosen.text = "Twos"
		"threes_multiplier":
			category_chosen.text = "Threes"
		"fours_multiplier":
			category_chosen.text = "Fours"
		"fives_multiplier":
			category_chosen.text = "Fives"
		"sixes_multiplier":
			category_chosen.text = "Sixes"
		"choice_multiplier":
			category_chosen.text = "Choice"
		"small_straight_multiplier":
			category_chosen.text = "Small Straight"
		"large_straight_multiplier":
			category_chosen.text = "Large Straight"
		"full_house_multiplier":
			category_chosen.text = "Full House"
		"four_of_a_kind_multiplier":
			category_chosen.text = "Four of a Kind"
		"yacht_multiplier":
			category_chosen.text = "Yacht"
			
func statue_activate() -> void:
	if !get_parent().in_shop:
		statue_model_logic.play_audio()
		randomize_category()
		generate_value()
		update_text()
		get_parent().get_parent().score_sheet.buff_one_modifier(added_modifier, current_category)
		animation_player.play("activate")
