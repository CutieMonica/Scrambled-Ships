extends Node3D

@onready var outline: MeshInstance3D = $Outline

func _on_mouse_detect_mouse_entered() -> void:
	get_parent().input_handler.hovered_object = "statues"
	outline_on()

func _on_mouse_detect_mouse_exited() -> void:
	outline_off()
	if get_parent().input_handler.hovered_object == "statues":
		get_parent().input_handler.hovered_object = "none"

func outline_on() -> void:
	outline.visible = true

func outline_off() -> void:
	outline.visible = false
