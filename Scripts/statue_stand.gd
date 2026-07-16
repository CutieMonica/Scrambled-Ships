extends Node3D

@onready var outline: MeshInstance3D = $Outline
@onready var mouse_collider: CollisionShape3D = $MouseDetect/MouseCollider
@onready var yipee_bye_divide: AnimationPlayer = $YipeeByeDivide
var hovered : bool = false
var highlighted : bool = false

func _process(_delta: float) -> void:
	if !GameManager.in_tutorial and !get_parent().between_rounds and InputHandler.current_reroll_state == 0 and hovered and !highlighted and !get_parent().camera_movement.is_playing():
		InputHandler.hovered_object = "statues"
		outline_on()

func _on_mouse_detect_mouse_entered() -> void:
	hovered = true
	if !get_parent().between_rounds and InputHandler.current_reroll_state == 0 and !GameManager.in_tutorial and !get_parent().camera_movement.is_playing():
		InputHandler.hovered_object = "statues"
		outline_on()

func _on_mouse_detect_mouse_exited() -> void:
	hovered = false
	outline_off()
	if InputHandler.hovered_object == "statues":
		InputHandler.hovered_object = "none"

func outline_on() -> void:
	outline.visible = true
	highlighted = true

func outline_off() -> void:
	outline.visible = false
	highlighted = false

func mouse_box_on() -> void:
	mouse_collider.disabled = false
	
func mouse_box_off() -> void:
	mouse_collider.disabled = true

func divider_1_gone() -> void:
	yipee_bye_divide.play("divider1kill")
	
func divider_2_gone() -> void:
	yipee_bye_divide.play("divider2kill")
