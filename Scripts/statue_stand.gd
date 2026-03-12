extends Node3D

@onready var outline: MeshInstance3D = $Outline

func _on_mouse_detect_mouse_entered() -> void:
	InputHandler.hovered_object = "statues"
	outline_on()

func _on_mouse_detect_mouse_exited() -> void:
	outline_off()
	if InputHandler.hovered_object == "statues":
		InputHandler.hovered_object = "none"

func outline_on() -> void:
	outline.visible = true

func outline_off() -> void:
	outline.visible = false
