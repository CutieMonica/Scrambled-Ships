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
const AND_GOT = preload("uid://dqaak7wmuvpnf")
const YOU_SURVIVED = preload("uid://dxl8qsatre043")

const BETTER_LUCK = preload("uid://bbi4e1bttpseo")
const GOODBYE = preload("uid://dikdpl0qicg0s")
const HOPE_YOU_HAD_FUN = preload("uid://ds57indt1ovlf")
const HOW_IT_ROLLS = preload("uid://b25vc8thed623")
const IF_ONLY_YOU_WERE_A_LITTLE_BIT_MORE_LUCKY = preload("uid://df8ckywlg3f3k")
const IT_APPEARS_YOU_HAVE_REACHED = preload("uid://ieuk0lt2iy6p")
const LOST_THE_GAME = preload("uid://bj7i85eo1orvo")
const LOST = preload("uid://cd7n2o48g3v5")
const MISS = preload("uid://dioy6sgnujmwo")
const NO_HARD_FEELINGS = preload("uid://bbtth2a5p2xf")
const NO_ONE_IS_AROUND_TO_HELP = preload("uid://bptygd7tubmal")
const SEE_YOU_NEXT_TIME = preload("uid://dla5fm74slht3")
const SO_CLOSE = preload("uid://ckigwsru8pvnw")
const SO_SAD = preload("uid://fi4jk63k3asd")
const SORRY = preload("uid://ce4lqswor4y1f")
const TRY_AGAIN = preload("uid://b5sulfr5d1qhf")
const UNFORTUNATE = preload("uid://6oxppi2fiekp")
const WILL_YOU_PERSIST = preload("uid://cnvak0evd2c1v")
const WILL_YOU_TRY_AGAIN = preload("uid://o6mj605nw506")
const YOU_DIED = preload("uid://bmcwmngi6y63u")

const YOU_LOSE = preload("uid://ufy0a7os3byt")


var random_death_voice_line : Dictionary = {}

func _ready() -> void:
	random_death_voice_line = {
		1: BETTER_LUCK,
		2: GOODBYE,
		3: HOPE_YOU_HAD_FUN,
		4: HOW_IT_ROLLS,
		5: IF_ONLY_YOU_WERE_A_LITTLE_BIT_MORE_LUCKY,
		6: IT_APPEARS_YOU_HAVE_REACHED,
		7: LOST_THE_GAME,
		8: LOST,
		9: MISS,
		10: NO_HARD_FEELINGS,
		11: NO_ONE_IS_AROUND_TO_HELP,
		12: SEE_YOU_NEXT_TIME,
		13: SO_CLOSE,
		14: SO_SAD,
		15: SORRY,
		16: TRY_AGAIN,
		17: UNFORTUNATE,
		18: WILL_YOU_PERSIST,
		19: WILL_YOU_TRY_AGAIN,
		20: YOU_DIED
	}
	GameManager.calculate_round_target_and_progress_round()
	label_3d.text = str(GameManager.new_round_target)
	round_counter.text = str(GameManager.current_round)
	
func play_random_death_voice() -> void:
	var random_death_line := GameManager.rng.randi_range(1, random_death_voice_line.size())
	label_3d.text = "LOSE"
	audio_stream_player_3d.stream = YOU_LOSE
	audio_stream_player_3d.play()
	variable_timer.wait_time = 1
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = "SURVIVED"
	audio_stream_player_3d.stream = YOU_SURVIVED
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.7
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = str(GameManager.current_round - 1)
	for n in (int(str(GameManager.current_round - 1).length())):
		play_number((int(str(GameManager.current_round - 1)[n])))
		variable_timer.wait_time = 0.6
		variable_timer.start()
		await variable_timer.timeout
	label_3d.text = "ROUNDS"
	audio_stream_player_3d.stream = voiceROUND
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.6
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = "AND GOT"
	audio_stream_player_3d.stream = AND_GOT
	audio_stream_player_3d.play()
	variable_timer.wait_time = 0.6
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = str(GameManager.high_score)
	for n in (int(str(GameManager.high_score).length())):
		play_number((int(str(GameManager.high_score)[n])))
		variable_timer.wait_time = 0.5
		variable_timer.start()
		await variable_timer.timeout
	label_3d.text = "SCORE"
	audio_stream_player_3d.stream = voiceSCORE
	audio_stream_player_3d.play()
	variable_timer.wait_time = 1
	variable_timer.start()
	await variable_timer.timeout
	label_3d.text = "FAILED"
	audio_stream_player_3d.stream = random_death_voice_line.get(random_death_line)
	audio_stream_player_3d.play()
	await audio_stream_player_3d.finished
	variable_timer.wait_time = 0.3
	variable_timer.start()
	await variable_timer.timeout
	get_parent().ending_fade_out()
	
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
	label_3d.visible = true
	round_counter.visible = true
	round_counter.text = str(GameManager.current_round)
	if GameManager.dialogue_seen.get(2) != true:
		get_parent().dialogue_player.shop_tutorial_dialogue()
	else:
		get_parent().get_rick_quick_bitch()
	
	
	
