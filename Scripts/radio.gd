extends Node3D

@onready var music_source: AudioStreamPlayer3D = $MusicSource
@onready var music_fade_in: AnimationPlayer = $MusicFadeIn
@onready var music_source_2: AudioStreamPlayer3D = $MusicSource2
@onready var music_source_3: AudioStreamPlayer3D = $MusicSource3
@onready var music_source_4: AudioStreamPlayer3D = $MusicSource4
@onready var music_source_5: AudioStreamPlayer3D = $MusicSource5
@onready var music_source_6: AudioStreamPlayer3D = $MusicSource6
@onready var music_source_7: AudioStreamPlayer3D = $MusicSource7
@onready var music_source_8: AudioStreamPlayer3D = $MusicSource8

var current_song : int = 0

var act1music := preload("res://Assets/Music/Roll with it (final).ogg")
var act2music := preload("res://Assets/Music/Tuning out (act 2 main).ogg")
var act3music := preload("res://Assets/Music/Getting Dicey (act 3 Main).ogg")
var act4music := preload("res://Assets/Music/something sinister (act 4 main).ogg")
var act5music := preload("res://Assets/Music/in loving memory (act 5 main).ogg")
var act6music := preload("res://Assets/Music/not quite as i recalled (act 6 main).ogg")
var act7music := preload("res://Assets/Music/remember (act 7 ambient_main).ogg")
var act8music := preload("res://Assets/Music/you (act 8 ambient_main).ogg")

func _ready() -> void:
	play_round_1_song()

func play_song(song_number : int) -> void:
	match song_number:
		1: play_round_1_song()
		2: play_round_2_song()
		3: play_round_3_song()
		4: play_round_4_song()
		5: play_round_5_song()
		6: play_round_6_song()
		7: play_round_7_song()
		8: play_round_8_song()

func play_round_1_song() -> void:
	music_fade_in.play("FadeIn1")
	music_source.stream = act1music
	music_source.play()
	current_song = 1
	
func play_round_2_song() -> void:
	music_fade_in.play("FadeIn2")
	music_source_2.stream = act2music
	music_source_2.play()
	current_song = 2
	
func play_round_3_song() -> void:
	music_fade_in.play("FadeIn3")
	music_source_3.stream = act3music
	music_source_3.play()
	current_song = 3
	
func play_round_4_song() -> void:
	music_fade_in.play("FadeIn4")
	music_source_4.stream = act4music
	music_source_4.play()
	current_song = 4
	
func play_round_5_song() -> void:
	music_fade_in.play("FadeIn5")
	music_source_5.stream = act5music
	music_source_5.play()
	current_song = 5
	
func play_round_6_song() -> void:
	music_fade_in.play("FadeIn6")
	music_source_6.stream = act6music
	music_source_6.play()
	current_song = 6
	
func play_round_7_song() -> void:
	music_fade_in.play("FadeIn7")
	music_source_7.stream = act7music
	music_source_7.play()
	current_song = 7
	
func play_round_8_song() -> void:
	music_fade_in.play("FadeIn8")
	music_source_8.stream = act8music
	music_source_8.play()
	current_song = 8
	
func fade_out_song() -> void:
	music_fade_in.play("Fadeoutall")

func _on_music_fade_in_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeIn" + str(current_song):
		match current_song:
			1:
				pass
			2:
				music_source.playing = false
			3:
				music_source_2.playing = false
			4:
				music_source_3.playing = false
			5:
				music_source_4.playing = false
			6:
				music_source_5.playing = false
			7:
				music_source_6.playing = false
			8:
				music_source_7.playing = false
				
	if anim_name == "Fadeoutall":
		music_source.playing = false
		music_source_2.playing = false
		music_source_3.playing = false
		music_source_4.playing = false
		music_source_5.playing = false
		music_source_6.playing = false
		music_source_7.playing = false
		music_source_8.playing = false
		
