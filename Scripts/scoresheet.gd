extends Node3D

@onready var current_sum: Label3D = $MeshInstance3D/CurrentSum
@onready var bonus_score: Label3D = $MeshInstance3D/BonusScore
@onready var bonus_threshold: Label3D = $MeshInstance3D/BonusThreshold
@onready var bonus_explaination: Label3D = $"MeshInstance3D/Bonus Explaination"
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var ones: Label3D = $MeshInstance3D/DiceIcon1/Ones
@onready var ones_score: Label3D = $MeshInstance3D/DiceIcon1/OnesScore
@onready var ones_score_mult: Label3D = $MeshInstance3D/DiceIcon1/OnesScoreMult
@onready var twos: Label3D = $MeshInstance3D/DiceIcon2/Twos
@onready var twos_score: Label3D = $MeshInstance3D/DiceIcon2/TwosScore
@onready var twos_score_mult: Label3D = $MeshInstance3D/DiceIcon2/TwosScoreMult
@onready var threes: Label3D = $MeshInstance3D/DiceIcon3/Threes
@onready var threes_score: Label3D = $MeshInstance3D/DiceIcon3/ThreesScore
@onready var threes_score_mult: Label3D = $MeshInstance3D/DiceIcon3/ThreesScoreMult
@onready var fours: Label3D = $MeshInstance3D/DiceIcon4/Fours
@onready var fours_score: Label3D = $MeshInstance3D/DiceIcon4/FoursScore
@onready var fours_score_mult: Label3D = $MeshInstance3D/DiceIcon4/FoursScoreMult
@onready var fives: Label3D = $MeshInstance3D/DiceIcon5/Fives
@onready var fives_score: Label3D = $MeshInstance3D/DiceIcon5/FivesScore
@onready var fives_score_mult: Label3D = $MeshInstance3D/DiceIcon5/FivesScoreMult
@onready var sixes: Label3D = $MeshInstance3D/DiceIcon6/Sixes
@onready var sixes_score: Label3D = $MeshInstance3D/DiceIcon6/SixesScore
@onready var sixes_score_mult: Label3D = $MeshInstance3D/DiceIcon6/SixesScoreMult

@onready var choice: Label3D = $MeshInstance3D/ChoiceIcon/Choice
@onready var choice_score: Label3D = $MeshInstance3D/ChoiceIcon/ChoiceScore
@onready var choice_score_mult: Label3D = $MeshInstance3D/ChoiceIcon/ChoiceScoreMult
@onready var small_straight: Label3D = $MeshInstance3D/SmallStraightIcon/SmallStraight
@onready var small_straight_score: Label3D = $MeshInstance3D/SmallStraightIcon/SmallStraightScore
@onready var small_straight_mult: Label3D = $MeshInstance3D/SmallStraightIcon/SmallStraightMult
@onready var large_straight: Label3D = $MeshInstance3D/LargeStraightIcon/LargeStraight
@onready var large_straight_score: Label3D = $MeshInstance3D/LargeStraightIcon/LargeStraightScore
@onready var large_straight_mult: Label3D = $MeshInstance3D/LargeStraightIcon/LargeStraightMult
@onready var full_house: Label3D = $MeshInstance3D/FullHouseIcon/FullHouse
@onready var full_house_score: Label3D = $MeshInstance3D/FullHouseIcon/FullHouseScore
@onready var full_house_mult: Label3D = $MeshInstance3D/FullHouseIcon/FullHouseMult
@onready var four_of_a_kind: Label3D = $MeshInstance3D/FourOfAKindIcon/FourOfAKind
@onready var four_of_a_kind_score: Label3D = $MeshInstance3D/FourOfAKindIcon/FourOfAKindScore
@onready var four_of_a_kind_mult: Label3D = $MeshInstance3D/FourOfAKindIcon/FourOfAKindMult
@onready var yacht: Label3D = $MeshInstance3D/YachtIcon/Yacht
@onready var yacht_score: Label3D = $MeshInstance3D/YachtIcon/YachtScore
@onready var yacht_mult: Label3D = $MeshInstance3D/YachtIcon/YachtMult

@onready var highlighter: AnimationPlayer = $Highlighter
@onready var grand_total_amount: Label3D = $"MeshInstance3D/Grand Total Amount"

@export var is_sheet_highlighted : bool = false
@export var hovered_category : String = "none"
@export var is_leave_area_highlighted : bool = false

@export var current_best_double : int = 0
@export var current_best_triple : int = 0
@export var current_best_quad : int = 0
@export var current_best_quint : int = 0
	
@export var second_best_triple : int = 0
@export var second_best_double : int = 0
	
var highlighted = false
var can_highlight = true
var has_temp_modifier = false


var ones_amount : int
var twos_amount : int
var threes_amount : int
var fours_amount : int
var fives_amount : int
var sixes_amount : int

var choice_amount : int
var small_straight_amount : int
var large_straight_amount : int
var full_house_amount : int
var four_of_a_kind_amount : int
var yacht_amount : int

var ones_multiplier : float = 1.0
var twos_multiplier : float = 1.0
var threes_multiplier : float = 1.0
var fours_multiplier : float = 1.0
var fives_multiplier : float = 1.0
var sixes_multiplier : float = 1.0

var choice_multiplier : float = 1.0
var small_straight_multiplier : float = 1.5
var large_straight_multiplier : float = 2.5
var full_house_multiplier : float = 2.0
var four_of_a_kind_multiplier : float = 3.0
var yacht_multiplier : float = 5.0

var ones_locked_in : bool = false
var twos_locked_in : bool = false
var threes_locked_in : bool = false
var fours_locked_in : bool = false
var fives_locked_in : bool = false
var sixes_locked_in : bool = false

var choice_locked_in : bool = false
var small_straight_locked_in : bool = false
var large_straight_locked_in : bool = false
var full_house_locked_in : bool = false
var four_of_a_kind_locked_in : bool = false
var yacht_locked_in : bool = false

var ones_locked_in_score : int
var twos_locked_in_score : int
var threes_locked_in_score : int
var fours_locked_in_score : int
var fives_locked_in_score : int
var sixes_locked_in_score : int

var choice_locked_in_score : int
var small_straight_locked_in_score : int
var large_straight_locked_in_score : int
var full_house_locked_in_score : int
var four_of_a_kind_locked_in_score : int
var yacht_locked_in_score : int

var valid_small_straight : bool = false
var valid_large_straight : bool = false
var valid_full_house : bool = false
var valid_four_of_a_kind : bool = false
var valid_yacht : bool = false

var large_straight_dice_cap : int
var full_house_larger_number : int
var full_house_smaller_number : int

var top_sum : int
var bonus_given = false
var max_top_sum : int
var bonus_amount : int
var current_grand_total : int
var bonus_threshold_amount : int

var outline_color = Color("a010a230")
var permanent_number_color = Color("000032")
var info_outline_color = Color("0f0f0fd8")
var info_color = Color("c0cadf")
var inside_sheet : bool = false

var pencil_sound_1 = preload("res://Assets/SFX/pencilsound1.ogg")
var pencil_sound_2 = preload("res://Assets/SFX/pencilsound2.ogg")

func random_sound():
	var play_sound : int
	play_sound = randi_range(1, 2)
	if play_sound == 1:
		audio_stream_player.stream = pencil_sound_1
	if play_sound == 2:
		audio_stream_player.stream = pencil_sound_2
	audio_stream_player.play()
func calculate_score():
	print("score calculated")
	ones_amount = GameManager.dice_numbers.values().count(1)
	twos_amount = (GameManager.dice_numbers.values().count(2) * 2)
	threes_amount = (GameManager.dice_numbers.values().count(3) * 3)
	fours_amount = (GameManager.dice_numbers.values().count(4) * 4)
	fives_amount = (GameManager.dice_numbers.values().count(5) * 5)
	sixes_amount = (GameManager.dice_numbers.values().count(6) * 6)
	
	choice_amount = (ones_amount + twos_amount + threes_amount + fours_amount + fives_amount + sixes_amount)
	
	small_straight_amount = 0
	large_straight_amount = 0
	valid_small_straight = false
	valid_large_straight = false
	large_straight_dice_cap = 5
	var straight_highest_number : int = 0
	
	for n in 25:
		if GameManager.dice_numbers.values().count(n) != 0:
			print("first straight check passed for number " + str(n))
			if GameManager.dice_numbers.values().count(n - 1) != 0:
				print("second straight check passed for number " + str(n))
				if GameManager.dice_numbers.values().count(n - 2) != 0:
					print("third straight check passed for number " + str(n))
					if GameManager.dice_numbers.values().count(n - 3) != 0:
						print("fourth straight check passed for number " + str(n))
						valid_small_straight = true
						@warning_ignore("narrowing_conversion")
						straight_highest_number = n
						small_straight_amount = ((straight_highest_number) + ((straight_highest_number) * 3) - 6)
						print("straight highest number :" + str(straight_highest_number))
						print("small straight amount :" + str(small_straight_amount))
						print("small straight valid = " + str(valid_small_straight))
						if GameManager.dice_numbers.values().count(n - 4) != 0:
							print("fifth straight check passed for number " + str(n))
							@warning_ignore("narrowing_conversion")
							large_straight_amount = ((straight_highest_number) + ((straight_highest_number) * 4) - 10)
							print("large straight amount :" + str(large_straight_amount))
							valid_large_straight = true
							large_straight_dice_cap = 5
							if GameManager.dice_numbers.values().count(n - 5) != 0:
								print("sixth straight check passed for number " + str(n))
								large_straight_dice_cap = 6
								large_straight_amount += (straight_highest_number - 5)
								print("large straight amount :" + str(large_straight_amount))
								if GameManager.dice_numbers.values().count(n - 6) != 0:
									print("seventh straight check passed for number " + str(n))
									large_straight_dice_cap = 7
									large_straight_amount += (straight_highest_number - 6)
									print("large straight amount :" + str(large_straight_amount))
				
	if !valid_small_straight:
		small_straight_amount = 0
		large_straight_amount = 0
		
	if !valid_large_straight:
		large_straight_amount = 0
	
	print("small straight valid = " + str(valid_small_straight))
	
	valid_full_house = false
	full_house_larger_number = 0
	full_house_smaller_number = 0
	current_best_double = 0
	current_best_triple = 0
	current_best_quad = 0
	current_best_quint = 0
	
	for n in 25:
		if GameManager.dice_numbers.values().count(n) >= 5:
			if n > current_best_quint:
				current_best_quint = n
		if GameManager.dice_numbers.values().count(n) >= 4:
			if n > current_best_quad:
				if n != current_best_quint:
					current_best_quad = n
		if GameManager.dice_numbers.values().count(n) >= 3:
			if n > current_best_triple:
				if current_best_triple > 0:
					second_best_triple = current_best_triple
				current_best_triple = n
		if GameManager.dice_numbers.values().count(n) >= 2:
			if n > current_best_double:
				if current_best_double > 0:
					second_best_double = current_best_double
				current_best_double = n
					
	#this code is ok
	if current_best_quint > current_best_quad and current_best_quint > current_best_triple:
		full_house_larger_number = current_best_quint
	if current_best_quad > current_best_quint and current_best_quad > current_best_triple:
		full_house_larger_number = current_best_quad
	if current_best_triple > current_best_quint and current_best_triple > current_best_quad:
		full_house_larger_number = current_best_triple
		
	#this code sucks
	if second_best_double != 0:
		full_house_smaller_number = second_best_double
	if current_best_double != full_house_larger_number:
		if current_best_double != 0 and current_best_double > full_house_smaller_number:
			full_house_smaller_number = current_best_double
	if second_best_triple != full_house_larger_number:
		if second_best_triple != 0 and second_best_triple > full_house_smaller_number:
			full_house_smaller_number = second_best_triple
	if current_best_triple != full_house_larger_number:
		if current_best_triple != 0 and current_best_triple > full_house_smaller_number:
			full_house_smaller_number = current_best_triple
	if current_best_quad != full_house_larger_number:
		if current_best_quad != 0 and current_best_quad > full_house_smaller_number:
			full_house_smaller_number = current_best_quad
	
		
	if full_house_larger_number > 0 and full_house_smaller_number > 0:
		full_house_amount = (((full_house_larger_number) * 3) + ((full_house_smaller_number * 2)))
		valid_full_house = true
		
	if full_house_larger_number <= 0 or full_house_smaller_number <= 0:
		full_house_amount = 0
		valid_full_house = false
		
	valid_four_of_a_kind = false
	valid_yacht = false
	four_of_a_kind_amount = 0
	yacht_amount = 0
		
	if current_best_quad > 0:
		valid_four_of_a_kind = true
		four_of_a_kind_amount = ((current_best_quad) * 4)
	if current_best_quint > 0:
		valid_yacht = true
		valid_four_of_a_kind = true
		yacht_amount = ((current_best_quint) * 5)
		if current_best_quint > current_best_quad:
			four_of_a_kind_amount = ((current_best_quint) * 4)
			
	if current_best_quad <= 0 and current_best_quint <= 0:
		valid_four_of_a_kind = false
		four_of_a_kind_amount = 0
		
	if current_best_quint <= 0:
		valid_yacht = false
		yacht_amount = 0
		
	
func _ready() -> void:
	update_multipliers()
	GameManager.dice_numbers.values().count(1)
	print()
	bonus_explaination.modulate = info_color
	bonus_explaination.outline_modulate = info_outline_color


func reset_text():
	current_sum.modulate = info_color
	current_sum.outline_modulate = info_outline_color
	
func update_multipliers():
	ones_score_mult.text = ("x" + str(snappedf(ones_multiplier, 0.01)))
	twos_score_mult.text = ("x" + str(snappedf(twos_multiplier, 0.01)))
	threes_score_mult.text = ("x" + str(snappedf(threes_multiplier, 0.01)))
	fours_score_mult.text = ("x" + str(snappedf(fours_multiplier, 0.01)))
	fives_score_mult.text = ("x" + str(snappedf(fives_multiplier, 0.01)))
	sixes_score_mult.text = ("x" + str(snappedf(sixes_multiplier, 0.01)))
	
	choice_score_mult.text = ("x" + str(snappedf(choice_multiplier, 0.01)))
	small_straight_mult.text = ("x" + str(snappedf(small_straight_multiplier, 0.01)))
	large_straight_mult.text = ("x" + str(snappedf(large_straight_multiplier, 0.01)))
	full_house_mult.text = ("x" + str(snappedf(full_house_multiplier, 0.01)))
	four_of_a_kind_mult.text = ("x" + str(snappedf(four_of_a_kind_multiplier, 0.01)))
	yacht_mult.text = ("x" + str(snappedf(yacht_multiplier, 0.01)))
	
	max_top_sum = roundi(((GameManager.dice_amount) * ones_multiplier) + ((GameManager.dice_amount * 2) * twos_multiplier) + ((GameManager.dice_amount * 3) * threes_multiplier) + ((GameManager.dice_amount * 4) * fours_multiplier) + ((GameManager.dice_amount * 5) * fives_multiplier) + ((GameManager.dice_amount * 6) * sixes_multiplier))
	print(max_top_sum)
	if !has_temp_modifier:
		@warning_ignore("integer_division", "narrowing_conversion")
		bonus_threshold_amount = (max_top_sum / 1.66)
		@warning_ignore("narrowing_conversion", "integer_division")
		bonus_amount = (max_top_sum / 3)
	print(bonus_threshold_amount)
	bonus_threshold.text = ("BONUS THRESHOLD: " + str(bonus_threshold_amount))
	bonus_score.text = ("BONUS SCORE: " + str(bonus_amount))
	if !bonus_given and top_sum > bonus_threshold_amount:
		max_top_sum += bonus_amount
		bonus_threshold.outline_modulate = outline_color
		bonus_score.outline_modulate = outline_color
		bonus_score.modulate = permanent_number_color
		bonus_threshold.modulate = permanent_number_color
		bonus_given = true
	

func lock_in_score():
	random_sound()
	if hovered_category == "ones":
		ones_locked_in = true
		ones_locked_in_score = roundi(ones_amount * ones_multiplier)
		ones_score.outline_modulate = outline_color
		ones_score.modulate = permanent_number_color
		current_grand_total += ones_locked_in_score
	if hovered_category == "twos":
		twos_locked_in = true
		twos_locked_in_score = roundi(twos_amount * twos_multiplier)
		twos_score.outline_modulate = outline_color
		twos_score.modulate = permanent_number_color
		current_grand_total += twos_locked_in_score
	if hovered_category == "threes":
		threes_locked_in = true
		threes_locked_in_score = roundi(threes_amount * threes_multiplier)
		threes_score.outline_modulate = outline_color
		threes_score.modulate = permanent_number_color
		current_grand_total += threes_locked_in_score
	if hovered_category == "fours":
		fours_locked_in = true
		fours_locked_in_score = roundi(fours_amount * fours_multiplier)
		fours_score.outline_modulate = outline_color
		fours_score.modulate = permanent_number_color
		current_grand_total += fours_locked_in_score
	if hovered_category == "fives":
		fives_locked_in = true
		fives_locked_in_score = roundi(fives_amount * fives_multiplier)
		fives_score.outline_modulate = outline_color
		fives_score.modulate = permanent_number_color
		current_grand_total += fives_locked_in_score
	if hovered_category == "sixes":
		sixes_locked_in = true
		sixes_locked_in_score = roundi(sixes_amount * sixes_multiplier)
		sixes_score.outline_modulate = outline_color
		sixes_score.modulate = permanent_number_color
		current_grand_total += sixes_locked_in_score
	if hovered_category == "choice":
		choice_locked_in = true
		choice_locked_in_score = roundi(choice_amount * choice_multiplier)
		choice_score.outline_modulate = outline_color
		choice_score.modulate = permanent_number_color
		current_grand_total += choice_locked_in_score
	if hovered_category == "small_straight":
		small_straight_locked_in = true
		small_straight_locked_in_score = roundi(small_straight_amount * small_straight_multiplier)
		small_straight_score.outline_modulate = outline_color
		small_straight_score.modulate = permanent_number_color
		current_grand_total += small_straight_locked_in_score
	if hovered_category == "large_straight":
		large_straight_locked_in = true
		large_straight_locked_in_score = roundi(large_straight_amount * large_straight_multiplier)
		large_straight_score.outline_modulate = outline_color
		large_straight_score.modulate = permanent_number_color
		current_grand_total += large_straight_locked_in_score
	if hovered_category == "full_house":
		full_house_locked_in = true
		full_house_locked_in_score = roundi(full_house_amount * full_house_multiplier)
		full_house_score.outline_modulate = outline_color
		full_house_score.modulate = permanent_number_color
		current_grand_total += full_house_locked_in_score
	if hovered_category == "four_of_a_kind":
		four_of_a_kind_locked_in = true
		four_of_a_kind_locked_in_score = roundi(four_of_a_kind_amount * four_of_a_kind_multiplier)
		four_of_a_kind_score.outline_modulate = outline_color
		four_of_a_kind_score.modulate = permanent_number_color
		current_grand_total += four_of_a_kind_locked_in_score
	if hovered_category == "yacht":
		yacht_locked_in = true
		yacht_locked_in_score = roundi(yacht_amount * yacht_multiplier)
		yacht_score.outline_modulate = outline_color
		yacht_score.modulate = permanent_number_color
		current_grand_total += yacht_locked_in_score
	hovered_category = "none"
	top_sum = (ones_locked_in_score + twos_locked_in_score + threes_locked_in_score + fours_locked_in_score + fives_locked_in_score + sixes_locked_in_score)
	current_sum.text = "TOP SUM: " + str(top_sum)
	grand_total_amount.text = str(current_grand_total)
	
	if GameManager.rolls > 0:
		get_tree().call_group("stored_dice", "return_to_box")
		leave_sheet()
		get_parent().become_inactionable()
		await get_tree().create_timer(0.301).timeout
		get_parent().become_actionable()
		get_parent().reload()
	if GameManager.rolls <= 0:
		pass

func _on_area_3d_mouse_entered() -> void:
	if can_highlight:
		highlighter.play("Highlighted")
		highlighted = true
		get_parent().input_handler.hovered_object = "scoresheet"

func _on_area_3d_mouse_exited() -> void:
	highlighter.play("NotHighlighted")
	highlighted = false
	if get_parent().input_handler.hovered_object == "scoresheet" and !inside_sheet:
		get_parent().input_handler.hovered_object = "none"
	if get_parent().input_handler.hovered_object == "scoresheet" and inside_sheet:
		pass

func interact():
	if is_sheet_highlighted:
		enter_sheet()
	if hovered_category != "none" and hovered_category != "outside":
		lock_in_score()
	if hovered_category == "outside":
		leave_sheet()
	if hovered_category == "none":
		pass

func enter_sheet():
	inside_sheet = true
	highlighter.play("Clicked")
	is_sheet_highlighted = false
	get_parent().zoom_on_score_sheet()
		
func leave_sheet():
	inside_sheet = false
	highlighter.play_backwards("Clicked")
	unhighlight_box()
	get_parent().zoom_out_score_sheet()
	hovered_category = "none"
	if get_parent().input_handler.hovered_object == "scoresheet":
		get_parent().input_handler.hovered_object = "none"
	#await get_tree().create_timer(1).timeout
		
func _on_mouse_detect_ones_mouse_entered() -> void:
	print("mouse_over_one")
	unhighlight_box()
	if !ones_locked_in:
		ones_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		ones_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		ones_score.text = str(roundi(ones_amount * ones_multiplier))
		hovered_category = "ones"
	else:
		hovered_category = "none"

func _on_mouse_detect_ones_mouse_exited() -> void:
	print("mouse_not_over_one")
	if hovered_category == "ones":
		hovered_category = "none"
	if !ones_locked_in:
		ones_score.text = " "
	else:
		hovered_category = "none"

func _on_mouse_detect_twos_mouse_entered() -> void:
	print("mouse_over_two")
	unhighlight_box()
	if !twos_locked_in:
		twos_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		twos_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		twos_score.text = str(roundi(twos_amount * twos_multiplier))
		hovered_category = "twos"
	else:
		hovered_category = "none"

func _on_mouse_detect_twos_mouse_exited() -> void:
	print("mouse_not_over_two")
	if hovered_category == "twos":
		hovered_category = "none"
	if !twos_locked_in:
		twos_score.text = " "
	else:
		hovered_category = "none"

func _on_mouse_detect_threes_mouse_entered() -> void:
	print("mouse_over_three")
	unhighlight_box()
	if !threes_locked_in:
		threes_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		threes_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		threes_score.text = str(roundi(threes_amount * threes_multiplier))
		hovered_category = "threes"
	else:
		hovered_category = "none"

func _on_mouse_detect_threes_mouse_exited() -> void:
	print("mouse_not_over_three")
	if hovered_category == "threes":
		hovered_category = "none"
	if !threes_locked_in:
		threes_score.text = " "
	else:
		hovered_category = "none"

func _on_mouse_detect_fours_mouse_entered() -> void:
	print("mouse_over_four")
	unhighlight_box()
	if !fours_locked_in:
		fours_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		fours_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		fours_score.text = str(roundi(fours_amount * fours_multiplier))
		hovered_category = "fours"
	else:
		hovered_category = "none"

func _on_mouse_detect_fours_mouse_exited() -> void:
	print("mouse_not_over_four")
	if hovered_category == "fours":
		hovered_category = "none"
	if !fours_locked_in:
		fours_score.text = " "
	else:
		hovered_category = "none"

func _on_mouse_detect_fives_mouse_entered() -> void:
	print("mouse_over_five")
	unhighlight_box()
	if !fives_locked_in:
		fives_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		fives_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		fives_score.text = str(roundi(fives_amount * fives_multiplier))
		hovered_category = "fives"
	else:
		hovered_category = "none"

func _on_mouse_detect_fives_mouse_exited() -> void:
	print("mouse_not_over_five")
	if hovered_category == "fives":
		hovered_category = "none"
	if !fives_locked_in:
		fives_score.text = " "
	else:
		pass

func _on_mouse_detect_sixes_mouse_entered() -> void:
	print("mouse_over_six")
	unhighlight_box()
	if !sixes_locked_in:
		sixes_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		sixes_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		sixes_score.text = str(roundi(sixes_amount * sixes_multiplier))
		hovered_category = "sixes"
	else:
		hovered_category = "none"

func _on_mouse_detect_sixes_mouse_exited() -> void:
	print("mouse_not_over_six")
	if hovered_category == "sixes":
		hovered_category = "none"
	if !sixes_locked_in:
		sixes_score.text = " "
	else:
		pass
		

func _on_mouse_detect_choice_mouse_entered() -> void:
	print("mouse_over_choice")
	unhighlight_box()
	if !choice_locked_in:
		choice_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		choice_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		choice_score.text = str(roundi(choice_amount * choice_multiplier))
		hovered_category = "choice"

func _on_mouse_detect_choice_mouse_exited() -> void:
	print("mouse_not_over_choice")
	if hovered_category == "choice":
		hovered_category = "none"
	if !choice_locked_in:
		choice_score.text = " "
	else:
		pass


func _on_mouse_detect_small_straight_mouse_entered() -> void:
	print("mouse_over_s_straight")
	unhighlight_box()
	if !small_straight_locked_in:
		small_straight_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		small_straight_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		small_straight_score.text = str(roundi(small_straight_amount * small_straight_multiplier))
		hovered_category = "small_straight"

func _on_mouse_detect_small_straight_mouse_exited() -> void:
	print("mouse_not_over_s_straight")
	if hovered_category == "small_straight":
		hovered_category = "none"
	if !small_straight_locked_in:
		small_straight_score.text = " "
	else:
		pass


func _on_mouse_detect_large_straight_mouse_entered() -> void:
	print("mouse_over_l_straight")
	unhighlight_box()
	if !large_straight_locked_in:
		large_straight_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		large_straight_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		large_straight_score.text = str(roundi(large_straight_amount * large_straight_multiplier))
		hovered_category = "large_straight"

func _on_mouse_detect_large_straight_mouse_exited() -> void:
	print("mouse_not_over_l_straight")
	if hovered_category == "large_straight":
		hovered_category = "none"
	if !large_straight_locked_in:
		large_straight_score.text = " "
	else:
		pass

func _on_mouse_detect_full_house_mouse_entered() -> void:
	print("mouse_over_full_house")
	unhighlight_box()
	if !full_house_locked_in:
		full_house_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		full_house_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		full_house_score.text = str(roundi(full_house_amount * full_house_multiplier))
		hovered_category = "full_house"

func _on_mouse_detect_full_house_mouse_exited() -> void:
	print("mouse_not_over_full_house")
	if hovered_category == "full_house":
		hovered_category = "none"
	if !full_house_locked_in:
		full_house_score.text = " "
	else:
		pass


func _on_mouse_detect_four_of_a_kind_mouse_entered() -> void:
	print("mouse_over_four_of_a_kind")
	unhighlight_box()
	if !four_of_a_kind_locked_in:
		four_of_a_kind_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		four_of_a_kind_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		four_of_a_kind_score.text = str(roundi(four_of_a_kind_amount * four_of_a_kind_multiplier))
		hovered_category = "four_of_a_kind"

func _on_mouse_detect_four_of_a_kind_mouse_exited() -> void:
	print("mouse_not_over_four_of_a_kind")
	if hovered_category == "four_of_a_kind":
		hovered_category = "none"
	if !four_of_a_kind_locked_in:
		four_of_a_kind_score.text = " "
	else:
		pass


func _on_mouse_detect_yacht_mouse_entered() -> void:
	print("mouse_over_yacht")
	unhighlight_box()
	if !yacht_locked_in:
		yacht_score.outline_modulate = Color(0.781, 0.643, 0.0, 0.6)
		yacht_score.modulate = Color(0.0, 0.184, 0.396, 0.729)
		yacht_score.text = str(roundi(yacht_amount * yacht_multiplier))
		hovered_category = "yacht"

func _on_mouse_detect_yacht_mouse_exited() -> void:
	print("mouse_not_over_four_of_a_kind")
	if hovered_category == "yacht":
		hovered_category = "none"
	if !yacht_locked_in:
		yacht_score.text = " "
	else:
		pass


func _on_mouse_detect_leave_mouse_entered() -> void:
	hovered_category = "outside"
	print("readytoleave")
	get_parent().dice_box.highlighton()

func unhighlight_box():
	get_parent().dice_box.highlightoff()

func buff_all_modifiers(buff):
	ones_multiplier = ones_multiplier + buff
	twos_multiplier = twos_multiplier + buff
	threes_multiplier = threes_multiplier + buff
	fours_multiplier = fours_multiplier + buff
	fives_multiplier = fives_multiplier + buff
	sixes_multiplier = sixes_multiplier + buff

	choice_multiplier = choice_multiplier + buff
	small_straight_multiplier = small_straight_multiplier + buff
	large_straight_multiplier = large_straight_multiplier + buff
	full_house_multiplier = full_house_multiplier + buff
	four_of_a_kind_multiplier = four_of_a_kind_multiplier + buff
	yacht_multiplier = yacht_multiplier + buff
	
	update_multipliers()

func buff_one_modifier(buff, modifier):
	match modifier:
		"ones_multiplier":
			ones_multiplier += buff
		"twos_multiplier":
			twos_multiplier += buff
		"threes_multiplier":
			threes_multiplier += buff
		"fours_multiplier":
			fours_multiplier += buff
		"fives_multiplier":
			fives_multiplier += buff
		"sixes_multiplier":
			sixes_multiplier += buff
		"choice_multiplier":
			choice_multiplier += buff
		"small_straight_multiplier":
			small_straight_multiplier += buff
		"large_straight_multiplier":
			large_straight_multiplier += buff
		"full_house_multiplier":
			full_house_multiplier += buff
		"four_of_a_kind_multiplier":
			four_of_a_kind_multiplier += buff
		"yacht_multiplier":
			yacht_multiplier += buff
	
	update_multipliers()
