extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_button_pressed() -> void:
	animation_player.play_backwards("Popup")
	await get_tree().create_timer(0.99).timeout
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
