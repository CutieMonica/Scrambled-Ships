extends Node3D

class_name StatueBaseLogic

@export var common_text_color : Color = Color(0.638, 0.638, 0.638, 1.0)
@export var common_text_outline_color : Color = Color(0.115, 0.115, 0.115, 0.639)

@export var uncommon_text_color : Color = Color(0.236, 0.617, 0.273, 1.0)
@export var uncommon_text_outline_color : Color = Color(0.012, 0.166, 0.158, 0.639)

@export var rare_text_color : Color = Color(0.599, 0.416, 0.838, 1.0)
@export var rare_text_outline_color : Color = Color(0.082, 0.122, 0.295, 0.639)

@export var legendary_text_color : Color = Color(0.882, 0.647, 0.28, 1.0)
@export var legendary_text_outline_color : Color = Color(0.293, 0.0, 0.03, 0.639)

@export var common_luminance : float = 0.01

@export var uncommon_luminance : float = 0.1

@export var rare_luminance : float = 0.2

@export var legendary_luminance : float = 0.4

func name_change(newname : String) -> void:
	get_parent().label_3d.text = newname
