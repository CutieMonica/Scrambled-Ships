extends Node3D

@export var base_statue_value : int
@export var statue_type : String = "Subtract"
var color : String = "blue"
var common_values := GameManager.rng_statues.randi_range(1, 5)
var uncommon_values := GameManager.rng_statues.randi_range(6, 9)
var rare_values := GameManager.rng_statues.randi_range(10, 30)
var legendary_values := GameManager.rng_statues.randi_range(31, 100)
var rarity : Array = [1, 2, 3, 4]
@export var weight_probabilities : Array = [10, 5, 2, 0.5]
@onready var label_3d: Label3D = $Label3D
@onready var statue_base_logic: StatueBaseLogic = $StatueBaseLogic

@onready var collider: StaticBody3D = $Collider
@export var statue_tooltip : String

func _ready() -> void:
	create_value()

func create_value() -> void:
	var random_weight := GameManager.rng_statues
	var random_value : int = rarity[random_weight.rand_weighted(weight_probabilities)]
	match random_value:
		1:
			base_statue_value = common_values
			label_3d.modulate = statue_base_logic.common_text_color
			label_3d.outline_modulate = statue_base_logic.common_text_outline_color
			print("common base")
		2:
			base_statue_value = uncommon_values
			label_3d.modulate = statue_base_logic.uncommon_text_color
			label_3d.outline_modulate = statue_base_logic.uncommon_text_outline_color
			print("uncommon base")
		3:
			base_statue_value = rare_values
			label_3d.modulate = statue_base_logic.rare_text_color
			label_3d.outline_modulate = statue_base_logic.rare_text_outline_color
			print("rare base")
		4:
			base_statue_value = legendary_values
			label_3d.modulate = statue_base_logic.legendary_text_color
			label_3d.outline_modulate = statue_base_logic.legendary_text_outline_color
			print("legendary base")
	print(base_statue_value)
	create_tooltip()
	
func create_tooltip() -> void:
	statue_tooltip = "Subtraction: Subtracts -" + str(base_statue_value) + " to the model placed above this base."
