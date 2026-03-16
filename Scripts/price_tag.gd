extends Node3D

@export var shop_position : int
var price : int = 0
@onready var label_3d: Label3D = $Pricetag/Label3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

func delete_price_tag() -> void:
	animation_player.play("fade")
	audio_stream_player_3d.stream = SfxBank.shadow_wizard_money_gang
	audio_stream_player_3d.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player_3d.volume_db = (randf_range(-4, -2))
	audio_stream_player_3d.play()

func inflation_is_a_bitch(new_price : int) -> void:
	price = new_price
	get_parent().get_parent().get_parent().shop_prices.set(shop_position, new_price)
	label_3d.text = ("$" + str(price))

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		visible = false
		animation_player.play("RESET")
