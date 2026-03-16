extends Node3D

@onready var label_3d: Label3D = $MeshInstance3D/Label3D

func update_money() -> void:
	label_3d.text = "$" + str(GameManager.current_money)
