extends Node3D

@export var card_position : int = 0

var activated : bool = false

@export var move_along_now : bool = false

@export var common_text_color : Color = Color(0.638, 0.638, 0.638, 1.0)
@export var common_text_outline_color : Color = Color(0.115, 0.115, 0.115, 0.639)

@export var uncommon_text_color : Color = Color(0.236, 0.617, 0.273, 1.0)
@export var uncommon_text_outline_color : Color = Color(0.012, 0.166, 0.158, 0.639)

@export var rare_text_color : Color = Color(0.599, 0.416, 0.838, 1.0)
@export var rare_text_outline_color : Color = Color(0.082, 0.122, 0.295, 0.639)

@export var legendary_text_color : Color = Color(0.882, 0.647, 0.28, 1.0)
@export var legendary_text_outline_color : Color = Color(0.293, 0.0, 0.03, 0.639)
@onready var timer: Timer = $Timer

func change_layers() -> void:
	await get_tree().process_frame
	get_parent().nametag.render_priority -= card_position
	get_parent().description.render_priority -= card_position
	get_parent().rarity.render_priority -= card_position
	get_parent().nametag.outline_render_priority -= card_position
	get_parent().description.outline_render_priority -= card_position
	get_parent().rarity.outline_render_priority -= card_position
	get_parent().card_back.get_active_material(0).render_priority -= card_position
	get_parent().card_art.get_active_material(0).render_priority -= card_position
	get_parent().card_front.get_active_material(0).render_priority -= card_position
		
func focuscard() -> void:
	if InputHandler.hovered_object != "scoresheet" and !activated:
		get_parent().animation_player.play("highlight")
		get_parent().focused = true
		InputHandler.hovered_object = "card" + str(get_parent().card_position)
		print(InputHandler.hovered_object)
	else:
		pass

func unfocuscard() -> void:
	if !activated:
		get_parent().animation_player.play("unhighlight")
		get_parent().focused = false
		if InputHandler.hovered_object == "card" + str(get_parent().card_position):
			InputHandler.hovered_object = "none"

func _process(_delta: float) -> void:
	if move_along_now and !activated:
		get_parent().position = get_parent().get_parent().card_placement_references[card_position].position
		get_parent().rotation = get_parent().get_parent().card_placement_references[card_position].rotation
	if activated:
		pass

func card_interact() -> void:
	activated = true
	get_parent().get_parent().remove_card(card_position)
	get_parent().get_parent().exit_card_outline.visible = false
	get_parent().get_parent().pull_down_cards()
	move_along_now = false
	get_parent().mouse_collider.visible = false
	get_parent().yall_ready_for_this()
	timer.start()

func _on_timer_timeout() -> void:
	move_along_now = false
	get_parent().activate()
