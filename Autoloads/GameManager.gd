extends Control

@onready var rolls_counter: Label = $CanvasLayer/RollsCounter
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var crt_filter: ColorRect = $CanvasLayer/CRTFilter
@onready var fps: Label = $CanvasLayer/FPS

@export var rolls : int = 8
@export var max_rolls : int = 8
@onready var fps_2: Label = $CanvasLayer/FPS2

signal round_changing

var money_due : int 
var current_money : int
var performance_mode : bool = false
var visible_fps : bool = false
var has_pressed_release : bool = false
var dice_amount : int = 7
var previous_round_target : int = 40
var rng = RandomNumberGenerator.new()
var rng_shops = RandomNumberGenerator.new()
var rng_statues = RandomNumberGenerator.new()
var input_seed : int
@export var base_round_target : int = 80
@export var new_round_target : int = 40
@export var current_round : int = 0
@export var dice_rested : int = 0
@export var dice_resting : bool = false
@export var highlighting : String = "none"

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	Engine.max_fps = DisplayServer.screen_get_refresh_rate()
	if !OS.has_feature("web"):
		toggle_performance_mode(false)
		Engine.physics_ticks_per_second = 120 
		print("notonweb")
	if OS.has_feature("web"):
		Engine.max_fps = 60
		toggle_performance_mode(true)
		get_tree().call_group("performance_switch", "performance_switch")
		Engine.physics_ticks_per_second = 120
		print("onweb")

func give_me_your_seed():
	#seed
	if input_seed != null and input_seed != 0:
		rng.seed = input_seed
		rng_shops.seed = input_seed
		rng_statues.seed = input_seed
	if input_seed == null or input_seed == 0:
		var random_seed = RandomNumberGenerator.new().randi_range(1, 999999999)
		rng.seed = random_seed
		rng_shops.seed = random_seed
		rng_statues.seed = random_seed
func toggle_performance_mode(state):
	if state == true:
		performance_mode = true
		crt_filter.visible = true
	if state == false:
		performance_mode = false
		crt_filter.visible = false

@export var dice_numbers : Dictionary = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: null,
	7: null
}

func update_rolls_count(increment):
	rolls += increment
	rolls_counter.text = "Rolls:" + str(rolls)
	if increment < 0:
		get_tree().call_group("main", "roll_used")

func update_dice_numbers(dice_position, dice_value):
	dice_numbers.set(dice_position, dice_value)
	dice_rested += 1
	if dice_rested >= dice_amount:
		dice_resting = true
		get_tree().call_group("main", "become_actionable")
		print("become_actionable")
		get_tree().call_group("scoresheet", "calculate_score")
	
func reset_dice_resting():
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

func calculate_round_target_and_progress_round():
	current_round += 1
	previous_round_target = new_round_target
	@warning_ignore("integer_division")
	new_round_target = (base_round_target * (current_round * (previous_round_target / 40)))
	@warning_ignore("integer_division")
	print("new round target is " + str((base_round_target * (current_round * (previous_round_target / 40)))))
	round_changing.emit()
	

func _process(_delta: float) -> void:
	
	if visible_fps:
		fps.text = str(Engine.get_frames_per_second()) + " FPS"
		fps_2.text = str(Engine.get_physics_frames()) + " PTPS"
	else:
		pass
