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
@export var tooltip : String = "You have Scrambled Ships, it came free with your Game Box."
@export var rarity : String = "Rare"
@export var item_name : String = "Reverse Card"
@export var description : String = "Upon use, allows you to select one of your statues. When you pick a statue, that statue's base will flip. Addition becomes Subtraction, and vice versa."

@onready var card_logic: Node3D = $card_logic
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var focused : bool = false

func _on_mouse_detect_mouse_entered() -> void:
	card_logic.focuscard()

func _on_mouse_detect_mouse_exited() -> void:
	card_logic.unfocuscard()

				
func yall_ready_for_this() -> void:
	animation_player.play("get_out")

func activate() -> void:
	get_parent().statue_stand.mouse_box_off()
	get_parent().zoom_on_statue()
	get_parent().choosing_new_statue = true
	get_tree().call_group("statues", "enable_statue_choice_area")
	add_to_group("card_waiting")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "statue1" or anim_name == "statue2" or anim_name == "statue3" or anim_name == "statue4" or anim_name == "statue5" or anim_name == "statue6":
		InputHandler.actionable = true
		get_parent().zoom_out_statue()
		get_parent().statue_stand.mouse_box_on()
		get_parent().choosing_new_statue = false
		get_tree().call_group("statues", "disable_statue_choice_area")
		remove_from_group("card_waiting")
		queue_free()
		

func play_animation() -> void:
	rotation = Vector3.ZERO
	global_position = Vector3.ZERO
	animation_player.play("statue" + str(GameManager.statue_to_cover))
	match GameManager.statue_to_cover:
		1:
			position = Vector3(-12.5, 2.75, -7.47)
			#rotation = Vector3(0, 16.5, 0)
		2:
			position = Vector3(-11.6, 2.75, -7.47)
			#rotation = Vector3(0, 8.5, 0)
		3: 
			position = Vector3(-10.65, 2.75, -7.47)
			#rotation = Vector3(0, 0.5, 0)
		4:
			position = Vector3(-9.8, 2.75, -7.47)
			#rotation = Vector3(0, -0.5, 0)
		5:
			position = Vector3(-9.1, 2.75, -7.47)
			#rotation = Vector3(0, -15.5, 0)
		6:
			position = Vector3(-8.2, 2.75, -7.47)
			#rotation = Vector3(0, -14.5, 0)
	await get_tree().create_timer(0.5).timeout
	card_logic.random_card_sound()
