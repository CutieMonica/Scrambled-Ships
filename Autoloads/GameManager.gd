extends Control

@onready var rolls_counter: Label = $CanvasLayer/RollsCounter
@onready var crt_filter: ColorRect = $CanvasLayer/CRTFilter
@onready var fps: Label = $CanvasLayer/FPS

@export var rolls : int = 0
@export var max_rolls : int = 8

@export var statue_count : int

@onready var fps_2: Label = $CanvasLayer/FPS2
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pause_button: TextureButton = $CanvasLayer/PauseButton

signal round_changing

var jonnymode : bool = false
var fredmode : bool = false

@export var dice_numbers : Dictionary = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: null,
	7: null
}

var high_score : int
var viewing_cards : bool = false
var choosing_new_cards : bool = false
var combining_statues: bool = false
var money_due : int 
var run_number : int = 0
var permanent_money_increases : int = 0
var current_money : int
var performance_mode : bool = false
var pixelization : bool = true
var visible_fps : bool = false
var has_pressed_release : bool = false
var dice_amount : int = 5
var card_slots : int = 5
var card_count : int = 0
var previous_round_target : int = 20
var rng := RandomNumberGenerator.new()
var rng_shops := RandomNumberGenerator.new()
var rng_statues := RandomNumberGenerator.new()
var rng_upgrades := RandomNumberGenerator.new()
var rng_cards := RandomNumberGenerator.new()
var input_seed : int
var statue_top_choice : Node3D
var statue_bottom_choice : Node3D
var reverse_card_choosing : bool = true
var combined_statue_1 : Node3D
var combined_statue_2 : Node3D
var ending_cutscene : bool = false
var is_postgame : bool = false
var mobile : bool = false

var ticket_1_choice_1 : int
var ticket_1_choice_2 : int

var statue_to_cover : int = 1
var category_to_debuff : String

var dialogue_seen : Dictionary = {
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
	12: false,
	13: false,
	14: false,
	15: false,
	16: false,
	17: false,
	18: false,
	19: false,
	20: false,
	21: false,
	22: false,
	23: false,
	24: false,
	25: false,
	26: false,
	27: false,
	28: false,
	29: false,
	30: false,
	31: false,
	32: false,
	33: false,
	34: false,
	35: false,
	36: false,
	37: false,
	38: false,
	39: false,
	40: false,
	41: false,
	42: false,
	43: false,
	44: false,
	45: false,
	46: false,
	47: false,
	48: false,
	49: false,
	50: false
}

@export var in_tutorial : bool = false
@export var overkill_money_cap : int = 8
@export var base_round_target : int = 40
@export var new_round_target : int = 20
@export var current_round : int = 0
@export var dice_rested : int = 0
@export var dice_resting : bool = false
@export var highlighting : String = "none"
@export var is_on_web : bool = false
@onready var performance_filter_adjust: AnimationPlayer = $PerformanceFilterAdjust

@export var number_display : bool = false
@export var reduce_motion : bool = false
@export var increase_contrast : bool = false
@export var reduce_flashing : bool = false

func reset_things() -> void:
	rolls = 0
	high_score = 0
	money_due = 0
	permanent_money_increases = 3
	current_money = 0
	has_pressed_release = false
	dice_amount = 5
	card_slots = 5
	card_count = 0
	previous_round_target = 15
	#input_seed = 0
	overkill_money_cap  = 8
	give_me_your_seed()
	base_round_target = 30
	new_round_target = 15
	current_round = 0
	dice_rested = 0
	dice_resting = false
	highlighting = "none"
	InputHandler.current_reroll_state = 0
	InputHandler.hovered_object = "none"
	InputHandler.statue_camera_state = false
	InputHandler.next_card = 0
	InputHandler.currently_vacant_dice_slot = 0
	InputHandler.currently_vacant_statue_slot = 0
	InputHandler.currently_vacant_card_slot = 0
	InputHandler.selected_shop_slot = 0
	InputHandler.in_game = false
	InputHandler.actionable = false
	dice_numbers = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: null,
	7: null
}

func _ready() -> void:
	if !OS.has_feature("web"):
		@warning_ignore("narrowing_conversion")
		Engine.max_fps = DisplayServer.screen_get_refresh_rate()
		is_on_web = false
		get_tree().call_group("performance_switch", "performance_switch")
		Engine.physics_ticks_per_second = 120 
		print("notonweb")
	if OS.has_feature("web"):
		Engine.max_fps = 60
		is_on_web = true
		get_tree().call_group("performance_switch", "performance_switch")
		Engine.physics_ticks_per_second = 120
		print("onweb")
		
	if OS.has_feature("mobile"):
		mobile = true
		
	SaveLoad._load()
	dialogue_seen = SaveLoad.SaveFileData.dialogue_seen
	run_number = SaveLoad.SaveFileData.run_number
	is_postgame = SaveLoad.SaveFileData.is_postgame
	
	performance_mode = SaveLoad.SaveFileData.performance_mode
	number_display = SaveLoad.SaveFileData.number_display
	reduce_motion = SaveLoad.SaveFileData.reduce_motion
	increase_contrast = SaveLoad.SaveFileData.increase_contrast
	reduce_flashing = SaveLoad.SaveFileData.reduce_flashing
	pixelization = SaveLoad.SaveFileData.pixelization
	
	filter_shift()
	

func give_me_your_seed() -> void:
	#seed
	if input_seed != null and input_seed != 0:
		rng.seed = input_seed
		rng_shops.seed = input_seed
		rng_statues.seed = input_seed
		rng_upgrades.seed = input_seed
		rng_cards.seed = input_seed
	if input_seed == null or input_seed == 0:
		var random_seed := RandomNumberGenerator.new().randi_range(1, 999999999)
		input_seed = random_seed
		rng.seed = random_seed
		rng_shops.seed = random_seed
		rng_statues.seed = random_seed
		rng_upgrades.seed = random_seed
		rng_cards.seed = random_seed
	if run_number == 0:
		input_seed = 332815025
		rng.seed = 332815025
		rng_shops.seed = 332815025
		rng_statues.seed = 332815025
		rng_upgrades.seed = 332815025
		rng_cards.seed = 332815025
		
func toggle_performance_mode(state : bool) -> void:
	if state == true:
		performance_mode = true
		crt_filter.visible = true
	if state == false:
		performance_mode = false
		crt_filter.visible = false



func update_rolls_count(increment : int) -> void:
	rolls += increment
	rolls_counter.text = "Rolls:" + str(rolls)
	if increment < 0:
		get_tree().call_group("main", "roll_used")

@warning_ignore("untyped_declaration")
func update_dice_numbers(dice_position : int, dice_value) -> void:
	dice_numbers.set(dice_position, dice_value)
	dice_rested += 1
	if dice_rested >= dice_amount:
		dice_resting = true
		get_tree().call_group("main", "become_actionable")
		print("become_actionable")
		get_tree().call_group("scoresheet", "calculate_score")
	
func reset_dice_resting() -> void:
	get_tree().call_group("dice_paper", "clear_dice_numbers")
	dice_resting = false
	dice_rested = 0
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("FPS_View"):
		visible_fps = !visible_fps
		if visible_fps:
			fps.visible = true
			fps_2.visible = true
		if !visible_fps:
			fps.visible = false
			fps_2.visible = false

func calculate_round_target_and_progress_round() -> void:
	current_round += 1
	previous_round_target = new_round_target
	@warning_ignore("integer_division", "narrowing_conversion")
	new_round_target = snappedi((base_round_target) + (previous_round_target) + ((previous_round_target) * (current_round * 0.055)), 10)
	if new_round_target < 40:
		new_round_target = current_round * 20
	@warning_ignore("integer_division")
	print("new round target is " + str(new_round_target))
	round_changing.emit()
	
func progress_round(current_grand_total : int) -> void:
	@warning_ignore("integer_division")
	var overkill_money : int = ((current_grand_total - new_round_target) / current_round)
	if overkill_money > overkill_money_cap:
		overkill_money = overkill_money_cap
	@warning_ignore("integer_division")
	money_due = (overkill_money + rolls) + permanent_money_increases
	get_tree().call_group("main", "play_sheet_to_counter")

func _process(_delta: float) -> void:
	if visible_fps:
		fps.text = str(Engine.get_frames_per_second()) + " FPS"
		fps_2.text = str(Engine.get_physics_frames()) + " PTPS"
	else:
		pass
	if mobile and PauseScreen.can_pause and InputHandler.actionable and PauseScreen.pause_buffer.is_stopped():
		pause_button.disabled = false
	else:
		pause_button.disabled = true

func pause_appear() -> void:
	if mobile:
		animation_player.play("pauseappear")
func hide_pause() -> void:
	if mobile:
		animation_player.play_backwards("pauseappear")
	

func _on_pause_button_pressed() -> void:
	PauseScreen.pause()
	pause_button.visible = false

func filter_shift() -> void:
	performance_filter_adjust.play("Performance" + str(performance_mode) + "Pixelfalse") #+ "Pixel" + str(pixelization))
	contrast_shift()

func contrast_shift() -> void:
	if increase_contrast:
		performance_filter_adjust.queue("highcontrast")
