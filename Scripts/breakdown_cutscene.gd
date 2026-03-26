extends Control
@onready var dialogue_handler_2: Control = $DialogueHandler2
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GlobalMusicPlayer.play_breakdown_song() 
	dialogue_handler_2.play_shake_1()
	await get_tree().create_timer(3).timeout
	get_tree().call_group("DealerDialogue", "ending_instability")
	animation_player.play("breakdown")
	timer.start()


func _on_timer_timeout() -> void:
	dialogue_handler_2.back_to_normal()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
