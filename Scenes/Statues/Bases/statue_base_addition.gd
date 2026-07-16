extends Node3D

@export var base_statue_value : int
@export var statue_type : String = "Add"
var color : String = "red"
var common_values := GameManager.rng_statues.randi_range(1, 5)
var uncommon_values := GameManager.rng_statues.randi_range(6, 9)
var rare_values := GameManager.rng_statues.randi_range(10, 30)
var legendary_values := GameManager.rng_statues.randi_range(31, 100)
var rarity : Array = [1, 2, 3, 4]
var base_rarity : int = 0
@export var weight_probabilities : Array = [10, 5, 2, 0.5]
@onready var label_3d: Label3D = $Label3D
@onready var statue_base_logic: StatueBaseLogic = $StatueBaseLogic
@onready var poof_particle: CPUParticles3D = $PoofParticle

@export var statue_base_description : String
@export var item_name : String = "Additive"
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
			base_rarity = 1
			get_parent().statue_bottom_rarity = 1
			print("common base")
		2:
			base_statue_value = uncommon_values
			base_rarity = 2
			get_parent().statue_bottom_rarity = 2
			print("uncommon base")
		3:
			base_statue_value = rare_values
			base_rarity = 3
			get_parent().statue_bottom_rarity = 3
			print("rare base")
		4:
			base_statue_value = legendary_values
			base_rarity = 4
			get_parent().statue_bottom_rarity = 4
			print("legendary base")
	print(base_statue_value)
	create_tooltip()
	
func create_tooltip() -> void:
	statue_tooltip = "
	Statue Base
	Addition: Has a base value of " + str(base_statue_value) + ", this gets added to the value of the model placed above this base."
