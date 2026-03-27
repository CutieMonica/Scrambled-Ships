extends Node3D

@export var base_modifier : int = 10
@export var statue_name : String = "Paperweight"
@export var color_shift_level : int = 3
@onready var statue_model_logic: Node3D = $StatueModelLogic
@onready var mesh: MeshInstance3D = $Sketchfab_Scene/Sketchfab_model/currentmodel_wrl_cleaner_materialmerger_gles/Object_2
@export var added_modifier : float
@onready var category_chosen: Label3D = $CategoryChosen
@onready var buff_text: Label3D = $BuffText
@export var trigger_condition : String = "RoundStart"
var has_given_modifier : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var poof_particle: CPUParticles3D = $PoofParticle

@export var item_name : String = "Paper Weight"
@export var tooltip : String = "This has never once been used to weigh down a piece of paper, somehow."
@export var description : String = "Statue Model
At the start of every round, the Paper Weight will add its current value to the target score. Affected by bases a normal amount."

func generate_value() -> void:
	var modifier_value : String = get_parent().statue_bottom_instance.statue_type
	match modifier_value:
		"Subtract":
			added_modifier = (base_modifier - (get_parent().statue_bottom_instance.base_statue_value))
			buff_text.text = statue_model_logic.get_symbol() + str(added_modifier) + " Every Round"
		"Add":
			added_modifier = base_modifier + ((get_parent().statue_bottom_instance.base_statue_value))
			buff_text.text = statue_model_logic.get_symbol() + str(added_modifier) + " Every Round"
			
func update_text() -> void:
	category_chosen.text = "Target Score"
			
func statue_activate() -> void:
	if !get_parent().in_shop:
		statue_model_logic.play_audio()
		generate_value()
		animation_player.play("activate")
		@warning_ignore("narrowing_conversion")
		GameManager.new_round_target += added_modifier
		get_parent().get_parent().target_score_display.label_3d.text = str(GameManager.new_round_target)
