extends Node3D
@onready var phase_shifts: AnimationPlayer = $PhaseShifts
@onready var animation_player: AnimationPlayer = $"Y Bot/AnimationPlayer"

func _ready() -> void:
	idle()

func idle() -> void:
	var random_animation : int = randi_range(1, 8)
	match random_animation:
		1: animation_player.queue("Sitting Idle/mixamo_com")
		2: animation_player.queue("Sitting Idle/mixamo_com")
		3: animation_player.queue("Sitting(2)/mixamo_com")
		4: animation_player.queue("Sitting Idle/mixamo_com")
		5: animation_player.queue("Sitting Idle/mixamo_com")
		6: animation_player.queue("Sitting(2)/mixamo_com")
		7: animation_player.queue("Sitting(2)/mixamo_com")
		8: animation_player.queue("Sitting/mixamo_com")

	

func phase_shift() -> void:
	phase_shifts.play("Round" + str(GameManager.current_round))

func play_finale() -> void:
	phase_shifts.play("Finale")

func play_finale_2() -> void:
	phase_shifts.play("Finale_2")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Sitting Idle/mixamo_com":
		idle()
	else:
		animation_player.queue("Sitting Idle/mixamo_com")
