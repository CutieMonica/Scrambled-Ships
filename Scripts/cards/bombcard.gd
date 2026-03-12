extends Node3D

@onready var nametag: Label3D = $CardVisuals/Nametag
@onready var description: Label3D = $CardVisuals/Description
@onready var rarity: Label3D = $CardVisuals/Rarity
@onready var outline: MeshInstance3D = $CardVisuals/Outline
@onready var card_back: MeshInstance3D = $CardVisuals/CardBack
@onready var card_art: MeshInstance3D = $CardVisuals/CardArt
@onready var card_front: MeshInstance3D = $CardVisuals/CardFront
@export var playsound : String = "none"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var card_logic: Node3D = $card_logic
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var focused : bool = false

func _on_mouse_detect_mouse_entered() -> void:
	card_logic.focuscard()

func _on_mouse_detect_mouse_exited() -> void:
	card_logic.unfocuscard()

func _process(_delta: float) -> void:
	if playsound != "none":
		match playsound:
			"explode":
				var random_vine_boom_jumpscare : int = randi_range(1, 100)
				if random_vine_boom_jumpscare < 100:
					audio_stream_player_3d.stream = SfxBank.explosion_1
				if random_vine_boom_jumpscare == 100:
					audio_stream_player_3d.stream = SfxBank.explosion_2
		audio_stream_player_3d.play()
		playsound = "none"
				
