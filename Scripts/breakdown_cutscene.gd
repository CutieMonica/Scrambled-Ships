extends Control

func _ready() -> void:
	get_tree().call_group("DealerDialogue", "ending_instability")
