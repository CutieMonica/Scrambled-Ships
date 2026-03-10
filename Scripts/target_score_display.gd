extends Node3D
@onready var label_3d: Label3D = $Label3D
@onready var round_counter: Label3D = $RoundCounter
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var variable_timer: Timer = $VariableTimer


const voice_0 = preload("uid://eu3fkj42s76c")
const voice_1 = preload("uid://dkhqymwux1uc8")
const voice_2 = preload("uid://bomrhh64ryb77")
const voice_3 = preload("uid://i55281g2dgdl")
const voice_4 = preload("uid://dhk8mt48y22df")
const voice_5 = preload("uid://bi1envonmie2b")
const voice_6 = preload("uid://d3t8uep5mg7kr")
const voice_7 = preload("uid://2xk0bskvcafn")
const voice_8 = preload("uid://c8u2paj7j4oke")
const voice_9 = preload("uid://d3qjdtbrjej6q")
const voiceIS = preload("uid://cwm41vde45iqq")
const voicePASSED = preload("uid://uvkap8p7y80k")
const voiceROUND = preload("uid://i5n3osr64a4q")
const voiceSCORE = preload("uid://o7f3ryw7u4jv")


func _ready() -> void:
	GameManager.calculate_round_target_and_progress_round()
	label_3d.text = str(GameManager.new_round_target)
	round_counter.text = str(GameManager.current_round)
	await get_tree().create_timer(2).timeout
	get_new_target_score()
	
func play_number(number : int) -> void:
	match number:
		0:
			audio_stream_player_3d.stream = voice_0
		1:
			audio_stream_player_3d.stream = voice_1
		2:
			audio_stream_player_3d.stream = voice_2
		3:
			audio_stream_player_3d.stream = voice_3
		4:
			audio_stream_player_3d.stream = voice_4
		5:
			audio_stream_player_3d.stream = voice_5
		6:
			audio_stream_player_3d.stream = voice_6
		7:
			audio_stream_player_3d.stream = voice_7
		8:
			audio_stream_player_3d.stream = voice_8
		9:
			audio_stream_player_3d.stream = voice_9
	audio_stream_player_3d.play()


func get_new_target_score() -> void:
	get_parent().zoom_in_timer()
	GameManager.calculate_round_target_and_progress_round()
	label_3d.text = "ROUND " + str(GameManager.current_round - 1)
	audio_stream_player_3d.stream = voiceROUND
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.2
	variable_timer.start()
	await variable_timer.timeout
	for n in (int(str(GameManager.current_round - 1).length())):
		play_number((int(str(GameManager.current_round - 1)[n])))
		variable_timer.wait_time = 0.6
		variable_timer.start()
		await variable_timer.timeout
	label_3d.text = "SCORE"
	audio_stream_player_3d.stream = voiceSCORE
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.8
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = "PASSED!!"
	audio_stream_player_3d.stream = voicePASSED
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.8
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = "ROUND " + str(GameManager.current_round)
	audio_stream_player_3d.stream = voiceROUND
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.2
	variable_timer.start()
	await variable_timer.timeout
	for n in (int(str(GameManager.current_round).length())):
		play_number((int(str(GameManager.current_round)[n])))
		variable_timer.wait_time = 0.6
		variable_timer.start()
		await variable_timer.timeout
	label_3d.text = "SCORE"
	audio_stream_player_3d.stream = voiceSCORE
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.8
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = "IS"
	audio_stream_player_3d.stream = voiceIS
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.4
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = str(GameManager.new_round_target)
	for n in (int(str(GameManager.new_round_target).length())):
		play_number((int(str(GameManager.new_round_target)[n])))
		variable_timer.wait_time = 0.4
		variable_timer.start()
		label_3d.visible = !label_3d.visible
		round_counter.visible = !round_counter.visible
		await variable_timer.timeout
	#label_3d.text = ""
	#variable_timer.wait_time = 0.4
	#variable_timer.start()
	#await variable_timer.timeout
	#label_3d.text = str(GameManager.new_round_target)
	#variable_timer.wait_time = 0.4
	#variable_timer.start()
	#await variable_timer.timeout
	#label_3d.text = " "
	#variable_timer.wait_time = 0.4
	#variable_timer.start()
	#await variable_timer.timeout
	#label_3d.text = str(GameManager.new_round_target)
#	variable_timer.wait_time = 0.4
	#variable_timer.start()
	#await variable_timer.timeout
#	label_3d.text = " "
	#variable_timer.wait_time = 0.4
	#variable_timer.start()
	#await variable_timer.timeout
	#label_3d.text = str(GameManager.new_round_target)
	#variable_timer.wait_time = 0.4
	#variable_timer.start()
	#await variable_timer.timeout
	label_3d.visible = true
	round_counter.visible = true
	round_counter.text = str(GameManager.current_round)
	get_parent().zoom_out_timer()
	
	
	
