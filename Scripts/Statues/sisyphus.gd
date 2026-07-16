extends Node3D

@export var rarity : int = 1
@export var base_modifier : float = 0.05
@export var current_category : String = "none"
@export var statue_name : String = "Sisyphus' Rock"
@export var color_shift_level : int = 1
@export var trigger_condition : String = "Reroll"
@onready var statue_model_logic: Node3D = $StatueModelLogic
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var poof_particle: CPUParticles3D = $PoofParticle

@export var item_name : String = "Sisyphus' Rock"
@export var added_modifier : float
@onready var category_chosen: Label3D = $CategoryChosen
@onready var buff_text: Label3D = $BuffText

@export var tooltip : String = "The kingdom of heaven has long since forgotten my name, and I am EAGER to make them remember."
@export var description : String = "Statue Model
After each roll, the boulder moves on the mountain, adjusting all multipliers by a small amount. This statue is barely affected by its base."

#placeholder, only for activating the statue while testing
#func _ready() -> void:
	#statue_activate()

func generate_value() -> void:
	var modifier_value : String = get_parent().statue_bottom_instance.statue_type
	match modifier_value:
		"Subtract":
			added_modifier = (base_modifier - (get_parent().statue_bottom_instance.base_statue_value * 0.01))
			buff_text.text = statue_model_logic.get_symbol(added_modifier) + str(added_modifier) + "X Every Roll"
		"Add":
			added_modifier = base_modifier + ((get_parent().statue_bottom_instance.base_statue_value * 0.01))
			buff_text.text = statue_model_logic.get_symbol(added_modifier) + str(added_modifier) + "X Every Roll"
			
func update_text() -> void:
	category_chosen.text = "All Categories"

func statue_activate() -> void:
	statue_model_logic.play_audio()
	get_parent().get_parent().score_sheet.buff_all_modifiers(added_modifier)
	animation_player.play("activate")
	
			
