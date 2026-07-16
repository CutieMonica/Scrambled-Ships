extends Node3D

@export var rarity : int = 3
@export var base_modifier : float = 1
@export var single_modifier : float = -8
@export var current_category : String = "none"
@export var statue_name : String = "Helping Hand"
@export var color_shift_level : int = 3
@export var trigger_condition : String = "OneCategoryBuffed"
@onready var statue_model_logic: Node3D = $StatueModelLogic
@onready var mesh: MeshInstance3D = $Sketchfab_Scene/Sketchfab_model/root/GLTF_SceneRootNode/M_LeftHandStatue_0/Object_4

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var poof_particle: CPUParticles3D = $PoofParticle

var can_activate : bool = false

@export var item_name : String = "Helping Hand"
@export var all_modifier : float
@export var one_modifier : float
@onready var category_chosen: Label3D = $CategoryChosen
@onready var buff_text: Label3D = $BuffText

@export var tooltip : String = "Say my name and I will fly."
@export var description : String = "Statue Model
After a single category is buffed, debuff that category by 8 - base value, and buff every category by 1 + base value. Somewhat affected by bases."

#placeholder, only for activating the statue while testing
#func _ready() -> void:
	#statue_activate()

func generate_value() -> void:
	var modifier_value : String = get_parent().statue_bottom_instance.statue_type
	match modifier_value:
		"Subtract":
			one_modifier = (single_modifier + (get_parent().statue_bottom_instance.base_statue_value * 0.1))
			category_chosen.text = "Single Category " + statue_model_logic.get_symbol(one_modifier) + str(one_modifier)
			
			all_modifier = (base_modifier - (get_parent().statue_bottom_instance.base_statue_value * 0.1))
			buff_text.text = "All Categories " + statue_model_logic.get_symbol(all_modifier) + str(all_modifier)
			
		"Add":
			one_modifier = (single_modifier - (get_parent().statue_bottom_instance.base_statue_value * 0.1))
			category_chosen.text = "Single Category " + statue_model_logic.get_symbol(one_modifier) + str(one_modifier)
			
			all_modifier = (base_modifier + (get_parent().statue_bottom_instance.base_statue_value * 0.1))
			buff_text.text = "All Categories " + statue_model_logic.get_symbol(all_modifier) + str(all_modifier)
			
func update_text() -> void:
	pass

func statue_activate() -> void:
	can_activate = !can_activate
	if can_activate:
		statue_model_logic.play_audio()
		get_parent().get_parent().score_sheet.buff_all_modifiers(all_modifier)
		get_parent().get_parent().score_sheet.buff_one_modifier(one_modifier, GameManager.category_to_debuff) 
		GameManager.category_to_debuff = "none"
		animation_player.play("activate")
	if !can_activate:
		pass
			
