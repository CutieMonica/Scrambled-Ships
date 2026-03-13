extends AudioStreamPlayer

var title_music := preload("res://Assets/Music/rolls light as waves v1.ogg")
var act1_ambience := preload("res://Assets/Music/Looming figure (final).ogg")
@onready var global_music_player: AudioStreamPlayer = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	#start_title_song()
	start_act1ambience()

func start_title_song() -> void:
	global_music_player.stream = title_music
	global_music_player.play()
	
func fade_out() -> void:
	animation_player.play("fade_out")

func fade_in() -> void:
	animation_player.play("fade_in")

func start_act1ambience() -> void:
	fade_in()
	global_music_player.stream = act1_ambience
	global_music_player.play()
