extends Node3D

@export var statue_1 : Node3D

@export var statue_2 : Node3D

@onready var statue_camera_timer: Timer = $StatueCameraTimer

var unselected_color : Color = Color(0.747, 0.549, 0.831, 1.0)
var selected_color : Color = Color(0.992, 0.983, 1.0, 1.0)

var unselected_luminance : float = 0.5
var selected_luminance : float = 2.0

var statue_bottom_chosen : bool = false
var statue_top_chosen : bool = false

@onready var combiner_top_collider_1: CollisionShape3D = $StatueCombinerTop1/CombinerTopArea1/CombinerTopCollider1
@onready var combiner_top_collider_2: CollisionShape3D = $StatueCombinerTop2/CombinerTopArea2/CombinerTopCollider2
@onready var combiner_bottom_collider_1: CollisionShape3D = $StatueCombinerBottom1/CombinerBottomArea1/CombinerBottomCollider1
@onready var combiner_bottom_collider_2: CollisionShape3D = $StatueCombinerBottom2/CombinerBottomArea2/CombinerBottomCollider2
@onready var statue_top_outline_1: MeshInstance3D = $StatueCombinerTop1/StatueTopOutline1
@onready var statue_top_outline_2: MeshInstance3D = $StatueCombinerTop2/StatueTopOutline2
@onready var statue_bottom_outline_1: MeshInstance3D = $StatueCombinerBottom1/StatueBottomOutline1
@onready var statue_bottom_outline_2: MeshInstance3D = $StatueCombinerBottom2/StatueBottomOutline2

@onready var statue_final_product_area: Node3D = $"../StatueFinalProductArea"


const statue_combiner = preload("uid://bi60iqmoecgti")

var new_statue_instance : Node

func new_statue_check() -> void:
	if statue_bottom_chosen and statue_top_chosen:
		statue_combination_epic_style()

func enable_statue_combiner_areas() -> void:
	combiner_top_collider_1.disabled = false
	combiner_top_collider_2.disabled = false
	combiner_bottom_collider_1.disabled = false
	combiner_bottom_collider_2.disabled = false
	combiner_top_highlight_1_unsolidified()
	combiner_top_highlight_2_unsolidified()
	combiner_bottom_highlight_1_unsolidified()
	combiner_bottom_highlight_2_unsolidified()
	

func disable_statue_combiner_areas() -> void:
	combiner_top_collider_1.disabled = true
	combiner_top_collider_2.disabled = true
	combiner_bottom_collider_1.disabled = true
	combiner_bottom_collider_2.disabled = true
	combiner_top_highlight_1_unsolidified()
	combiner_top_highlight_2_unsolidified()
	combiner_bottom_highlight_1_unsolidified()
	combiner_bottom_highlight_2_unsolidified()


func _on_combiner_top_area_1_mouse_entered() -> void:
	InputHandler.hovered_object = "statue_combiner_top_1"
	statue_top_outline_1.visible = true

func _on_combiner_top_area_1_mouse_exited() -> void:
	statue_top_outline_1.visible = false
	if InputHandler.hovered_object == "statue_combiner_top_1":
		InputHandler.hovered_object = "none"
	
	
func _on_combiner_top_area_2_mouse_entered() -> void:
	statue_top_outline_2.visible = true
	InputHandler.hovered_object = "statue_combiner_top_2"

func _on_combiner_top_area_2_mouse_exited() -> void:
	statue_top_outline_2.visible = false
	if InputHandler.hovered_object == "statue_combiner_top_2":
		InputHandler.hovered_object = "none"


func _on_combiner_bottom_area_1_mouse_entered() -> void:
	statue_bottom_outline_1.visible = true
	InputHandler.hovered_object = "statue_combiner_bottom_1"

func _on_combiner_bottom_area_1_mouse_exited() -> void:
	statue_bottom_outline_1.visible = false
	if InputHandler.hovered_object == "statue_combiner_bottom_1":
		InputHandler.hovered_object = "none"


func _on_combiner_bottom_area_2_mouse_entered() -> void:
	statue_bottom_outline_2.visible = true
	InputHandler.hovered_object = "statue_combiner_bottom_2"

func _on_combiner_bottom_area_2_mouse_exited() -> void:
	statue_bottom_outline_2.visible = false
	if InputHandler.hovered_object == "statue_combiner_bottom_2":
		InputHandler.hovered_object = "none"


func combiner_top_highlight_1_solidified() -> void:
	statue_top_outline_1.get_active_material(0).albedo_color = selected_color
	statue_top_outline_1.get_active_material(0).emission_energy_multiplier = selected_luminance
	statue_top_chosen = true
	new_statue_check()
	

func combiner_top_highlight_1_unsolidified() -> void:
	statue_top_outline_1.get_active_material(0).albedo_color = unselected_color
	statue_top_outline_1.get_active_material(0).emission_energy_multiplier = unselected_luminance
	
	
func combiner_top_highlight_2_solidified() -> void:
	statue_top_outline_2.get_active_material(0).albedo_color = selected_color
	statue_top_outline_2.get_active_material(0).emission_energy_multiplier = selected_luminance
	statue_top_chosen = true
	new_statue_check()

func combiner_top_highlight_2_unsolidified() -> void:
	statue_top_outline_2.get_active_material(0).albedo_color = unselected_color
	statue_top_outline_2.get_active_material(0).emission_energy_multiplier = unselected_luminance
	
	
func combiner_bottom_highlight_1_solidified() -> void:
	statue_bottom_outline_1.get_active_material(0).albedo_color = selected_color
	statue_bottom_outline_1.get_active_material(0).emission_energy_multiplier = selected_luminance
	statue_bottom_chosen = true
	new_statue_check()

func combiner_bottom_highlight_1_unsolidified() -> void:
	statue_bottom_outline_1.get_active_material(0).albedo_color = unselected_color
	statue_bottom_outline_1.get_active_material(0).emission_energy_multiplier = unselected_luminance
	
	
func combiner_bottom_highlight_2_solidified() -> void:
	statue_bottom_outline_2.get_active_material(0).albedo_color = selected_color
	statue_bottom_outline_2.get_active_material(0).emission_energy_multiplier = selected_luminance
	statue_bottom_chosen = true
	new_statue_check()

func combiner_bottom_highlight_2_unsolidified() -> void:
	statue_bottom_outline_2.get_active_material(0).albedo_color = unselected_color
	statue_bottom_outline_2.get_active_material(0).emission_energy_multiplier = unselected_luminance
	

func statue_combination_epic_style() -> void:
	disable_statue_combiner_areas()
	get_parent().statue_fusion_zoom()
	#get_parent().statue_fusion_to_statue_stand()
	GameManager.combined_statue_1.deconstructing_former = false
	GameManager.combined_statue_2.deconstructing_newer = false
	
	get_parent().in_play_statues.set(GameManager.combined_statue_1.statue_position, null)
	
	new_statue_instance = statue_combiner.instantiate()
	get_parent().statues_created += 1
	new_statue_instance.name = "FusedStatue" + str(get_parent().statues_created)
	
	add_child(new_statue_instance)
	
	new_statue_instance.global_position = statue_final_product_area.global_position
	
	get_parent().statue_top_choice.get_parent().statue_top_instance = null
	get_parent().statue_bottom_choice.get_parent().statue_bottom_instance = null
	
	get_parent().statue_top_choice.reparent(new_statue_instance)
	new_statue_instance.statue_top_instance = get_parent().statue_top_choice
	
	get_parent().statue_bottom_choice.reparent(new_statue_instance)
	new_statue_instance.statue_bottom_instance = get_parent().statue_bottom_choice

	new_statue_instance.reparent(get_parent())
	
	GameManager.combined_statue_1.destroy_statue()
	GameManager.combined_statue_2.destroy_statue()
	
	new_statue_instance.in_shop = false
	new_statue_instance.moving_to_new_base = true
	await get_tree().create_timer(0.75).timeout
	new_statue_instance.poof_particle.emitting = true
	new_statue_instance.redo_statue()
	await get_tree().create_timer(0.75).timeout
	
	new_statue_instance.purchase_statue()
	new_statue_instance.moving_to_new_base = false
	get_parent().statue_fusion_to_statue_stand()
	GameManager.combined_statue_1 = null
	GameManager.combined_statue_2 = null
	GameManager.combining_statues = false
	get_parent().statue_top_choice = null
	get_parent().statue_bottom_choice = null
	statue_bottom_chosen = false
	statue_top_chosen = false
	get_parent().choosing_new_statue = false
	new_statue_instance = null
