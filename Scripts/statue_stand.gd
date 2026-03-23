extends Node3D

@onready var outline: MeshInstance3D = $Outline
@onready var mouse_collider: CollisionShape3D = $MouseDetect/MouseCollider
@onready var yipee_bye_divide: AnimationPlayer = $YipeeByeDivide

func _on_mouse_detect_mouse_entered() -> void:
	InputHandler.hovered_object = "statues"
	outline_on()

func _on_mouse_detect_mouse_exited() -> void:
	outline_off()

func outline_on() -> void:
	outline.visible = true

func outline_off() -> void:
	outline.visible = false

func mouse_box_on() -> void:
	mouse_collider.disabled = false
	
func mouse_box_off() -> void:
	mouse_collider.disabled = true

func divider_1_gone() -> void:
	yipee_bye_divide.play("divider1kill")
	
func divider_2_gone() -> void:
	yipee_bye_divide.play("divider2kill")
