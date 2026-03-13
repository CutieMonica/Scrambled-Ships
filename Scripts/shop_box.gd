extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shop_generate_timer: Timer = $ShopGenerateTimer

func play_shop_reload() -> void:
	animation_player.play("lidflip")
	shop_generate_timer.start()

func _on_shop_generate_timer_timeout() -> void:
	get_parent().generate_shop()
