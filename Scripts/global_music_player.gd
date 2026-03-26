extends AudioStreamPlayer

var title_music := preload("res://Assets/Music/rolls light as waves v1.ogg")
var act1_ambience := preload("res://Assets/Music/Ambient/Looming figure (final).ogg")
var act2_ambience := preload("res://Assets/Music/Ambient/Absorbing pressence (act 2 ambient).ogg")
var act3_ambience := preload("res://Assets/Music/Ambient/black luminous (act 3 ambience).ogg")
var act4_ambience := preload("res://Assets/Music/Ambient/Rooted in malcontempt (act 4 amience).ogg")
var act5_ambience := preload("res://Assets/Music/Ambient/in loathsome recall (act 5 ambience).ogg")
var act6_ambience := preload("res://Assets/Music/Ambient/but just as i remember (act 6 ambient).ogg")
var breakdown_cutscene_song := preload("res://Assets/Music/Overcome.ogg")
var credits_song := preload("res://PLACEHOLDERCREDITSDELETETHISLATER.ogg")


@onready var global_music_player: AudioStreamPlayer = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var ambience_target : int = 0

func _ready() -> void:
	start_title_song()

func start_title_song() -> void:
	global_music_player.stream = title_music
	global_music_player.play()
	
func fade_out() -> void:
	animation_player.queue("fade_out")

func fade_in() -> void:
	animation_player.queue("fade_in")

func play_breakdown_song() -> void:
	global_music_player.stream = breakdown_cutscene_song

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#global_music_player.playing = false
	if anim_name == "fade_out":
		match ambience_target:
			0:
				pass
			1:
				fade_in()
				global_music_player.stream = act1_ambience
				global_music_player.play()
			2:
				fade_in()
				global_music_player.stream = act2_ambience
				global_music_player.play()
			3:
				fade_in()
				global_music_player.stream = act3_ambience
				global_music_player.play()
			4:
				fade_in()
				global_music_player.stream = act4_ambience
				global_music_player.play()
			5:
				fade_in()
				global_music_player.stream = act5_ambience
				global_music_player.play()
			6:
				fade_in()
				global_music_player.stream = act6_ambience
				global_music_player.play()
			7:
				global_music_player.stream = null
				global_music_player.playing = false
			8:
				pass
