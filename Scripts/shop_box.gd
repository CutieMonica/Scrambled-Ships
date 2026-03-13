extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_shop_reload() -> void:
	animation_player.play("lidflip")
