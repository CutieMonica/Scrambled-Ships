extends Node3D

@onready var nametag: Label3D = $CardVisuals/Nametag
@onready var descriptionlabel: Label3D = $CardVisuals/Description
@onready var raritylabel: Label3D = $CardVisuals/Rarity
@onready var outline: MeshInstance3D = $CardVisuals/Outline
@onready var card_back: MeshInstance3D = $CardVisuals/CardBack
@onready var card_art: MeshInstance3D = $CardVisuals/CardArt
@onready var card_front: MeshInstance3D = $CardVisuals/CardFront
@export var playsound : String = "none"
@export var card_position : int = 1
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var mouse_collider: CollisionShape3D = $MouseDetect/MouseCollider
@onready var card_visuals: Node3D = $CardVisuals


@export var item_type : String = "Card"
@export var tooltip : String = "Who up bouncing on they blade?"
@export var rarity : String = "Uncommon"
@export var item_name : String = "Bob Card"
@export var description : String = "Upon use, Bob will bounce on the Dice Box, causing every die outside of storage to flip upside down."

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
				audio_stream_player_3d.stream = SfxBank.blade_bounce
				get_tree().get_first_node_in_group("main").shake_screen()
				audio_stream_player_3d.volume_db = -10
		audio_stream_player_3d.play()
		playsound = "none"
				
func yall_ready_for_this() -> void:
	animation_player.play("get_out")

func activate() -> void:
	position = Vector3(0, 0, 0)
	rotation = Vector3.ZERO
	animation_player.play("explode")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		InputHandler.actionable = true
		card_logic.card_dies()

func _on_bounce_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("dice"):
		body.dice_logic.bounced_on()
