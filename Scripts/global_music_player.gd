extends AudioStreamPlayer

var title_music = preload("res://Assets/Music/rolls light as waves v1.ogg")
@onready var global_music_player: AudioStreamPlayer = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	start_title_song()

func start_title_song():
	global_music_player.stream = title_music
	global_music_player.play()
	
func fade_out():
	animation_player.play("fade_out")
