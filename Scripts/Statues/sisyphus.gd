extends Node3D

@export var base_modifier : float = 0.01
@export var current_category : String = "none"
@export var statue_name : String = "Sisyphus' Boulder"
@export var color_shift_level : int = 1
@export var trigger_condition : String = "Reroll"
@onready var statue_model_logic: Node3D = $StatueModelLogic
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var added_modifier : float
@onready var category_chosen: Label3D = $CategoryChosen
@onready var buff_text: Label3D = $BuffText

#placeholder, only for activating the statue while testing
#func _ready() -> void:
	#statue_activate()

func generate_value() -> void:
	var modifier_value : String = get_parent().statue_bottom_instance.statue_type
	match modifier_value:
		"Subtract":
			added_modifier = (base_modifier - (get_parent().statue_bottom_instance.base_statue_value * 0.01))
			buff_text.text = statue_model_logic.get_symbol() + str(added_modifier) + "X Every Roll"
		"Add":
			added_modifier = base_modifier + ((get_parent().statue_bottom_instance.base_statue_value * 0.01))
			buff_text.text = statue_model_logic.get_symbol() + str(added_modifier) + "X Every Roll"
			
func update_text() -> void:
	category_chosen.text = "All Categories"

func statue_activate() -> void:
	statue_model_logic.play_audio()
	get_parent().get_parent().score_sheet.buff_all_modifiers(added_modifier)
	animation_player.play("activate")
	
			
