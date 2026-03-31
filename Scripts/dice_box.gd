extends Node3D

@onready var highlighter: AnimationPlayer = $Highlighter
@onready var dice_slots: AnimationPlayer = $DiceSlots
@onready var mesh_instance_3d: MeshInstance3D = $Base/MeshInstance3D
const CHANNELS_4_PROFILE = preload("uid://4c88p7gfurot")
@onready var mesh_instance_3d_8: MeshInstance3D = $Base2/MeshInstance3D8
const I_HAD_JUST_A_RANDOM_DREAM_THAT_THE_YOUTUBER_JONNY_RAZER_WAS_V_0_ARZV_5_GI_1_GUOE_1 = preload("uid://bbwowsdigm411")

func _ready() -> void:
	if GameManager.jonnymode:
		mesh_instance_3d.get_active_material(0).albedo_texture = CHANNELS_4_PROFILE
		mesh_instance_3d.get_active_material(0).albedo_color = Color(1.0, 1.0, 1.0, 1.0)
		mesh_instance_3d_8.get_active_material(0).albedo_texture = I_HAD_JUST_A_RANDOM_DREAM_THAT_THE_YOUTUBER_JONNY_RAZER_WAS_V_0_ARZV_5_GI_1_GUOE_1
		mesh_instance_3d_8.get_active_material(0).albedo_color = Color(1.0, 1.0, 1.0, 1.0)

func _on_outside_the_box_detect_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice"):
		body.outside_the_box = true
		

func _on_back_in_the_box_detect_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice"):
		body.outside_the_box = false

func highlighton() -> void:
	highlighter.play("highlighted")
	

func highlightoff() -> void:
	highlighter.play("unhighlighted")

func _on_dice_clipping_fix_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice") or body.is_in_group("dice_resting"):
		body.position.y += 0.1

func unlock_slot_6() -> void:
	dice_slots.play("UnlockableSlot1")
	
func unlock_slot_7() -> void:
	dice_slots.play("UnlockableSlot2")
