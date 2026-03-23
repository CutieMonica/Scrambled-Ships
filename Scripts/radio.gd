extends Node3D

@onready var music_source: AudioStreamPlayer3D = $MusicSource
@onready var music_fade_in: AnimationPlayer = $MusicFadeIn

var roll_with_it_music := load("res://Assets/Music/Roll with it (final).ogg")

func _ready() -> void:
	play_round_1_song()

func play_round_1_song() -> void:
	music_fade_in.play("FadeIn")
	music_source.stream = roll_with_it_music
	music_source.play()
	
func fade_out_song() -> void:
	music_fade_in.play("Fadeout")
