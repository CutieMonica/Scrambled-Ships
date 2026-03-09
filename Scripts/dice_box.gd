extends Node3D

@onready var highlighter: AnimationPlayer = $Highlighter

func _on_outside_the_box_detect_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice"):
		body.outside_the_box = true

func _on_back_in_the_box_detect_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice"):
		body.outside_the_box = false

func highlighton():
	highlighter.play("highlighted")
	

func highlightoff():
	highlighter.play("unhighlighted")

func _on_dice_clipping_fix_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice") or body.is_in_group("dice_resting"):
		body.position.y += 0.1
