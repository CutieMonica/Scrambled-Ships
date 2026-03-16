extends Node3D

@onready var nametag: Label3D = $CardVisuals/Nametag
@onready var descriptionlabel: Label3D = $CardVisuals/Description
@onready var raritylabel: Label3D = $CardVisuals/Rarity
@onready var outline: MeshInstance3D = $CardVisuals/Outline
@onready var card_back: MeshInstance3D = $CardVisuals/CardBack
@onready var card_art: MeshInstance3D = $CardVisuals/CardArt
@onready var card_front: MeshInstance3D = $CardVisuals/CardFront
@export var playsound : String = "none"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var mouse_collider: CollisionShape3D = $MouseDetect/MouseCollider
@onready var text: Label3D = $CardVisuals/Text

@export var item_type : String = "Card"
@export var tooltip : String = "Looks like it was stolen from a random game of Poker."
@export var rarity : String = "Common"
@export var item_name : String = "Wheel of Fortune Card"
@export var description : String = "When used, there is a 1/4 chance for it to activate. When activated, it will choose a random category, and give it either +1.5x mult or multiply its mult by 1.5x."

@onready var card_logic: Node3D = $card_logic
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var focused : bool = false
var buffing : String


func _on_mouse_detect_mouse_entered() -> void:
	card_logic.focuscard()

func _on_mouse_detect_mouse_exited() -> void:
	card_logic.unfocuscard()

				
func yall_ready_for_this() -> void:
	animation_player.play("get_out")

func activate() -> void:
	position = Vector3(-3.715, 9.0, 2.0)
	var is_activating: int = GameManager.rng_cards.randi_range(4, 4)
	if is_activating != 4:
		animation_player.play("nope")
	if is_activating == 4:
		var random_effect: int = GameManager.rng_cards.randi_range(1, 2)
		var chosen_category : String = card_logic.choose_random_category()
		var chosen_category_written : String
		
		match chosen_category:
			"ones": 
				chosen_category_written = "Ones"
			"twos": 
				chosen_category_written = "Twos"
			"threes": 
				chosen_category_written = "Threes"
			"fours": 
				chosen_category_written = "Fours"
			"fives":
				chosen_category_written = "Fives"
			"sixes": 
				chosen_category_written = "Sixes"
			"choice": 
				chosen_category_written = "Choice"
			"small_straight": 
				chosen_category_written = "Small Straight"
			"large_straight": 
				chosen_category_written = "Large Straight"
			"full_house": 
				chosen_category_written = "Full House"
			"four_of_a_kind": 
				chosen_category_written = "Four of a Kind"
			"yacht": 
				chosen_category_written = "Yacht"
			
		match random_effect:
			1:
				buffing = chosen_category + "_multiplier"
				get_parent().score_sheet.multiply_one_modifier(1.5, buffing)
				text.text = chosen_category_written + " Multiplied!"
			2:
				buffing = chosen_category + "_multiplier"
				get_parent().score_sheet.buff_one_modifier(1.5, buffing)
				text.text = chosen_category_written + " Buffed!"
			#3:
			#	buffing = chosen_category + "_score"
			#	get_parent().score_sheet.buff_one_score(1.5, buffing)
			#	text.text = chosen_category_written + " Score + 20!"
				
	animation_player.play("success")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "success" or anim_name == "nope":
		card_logic.card_dies()
