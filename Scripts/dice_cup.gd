extends Node3D

@export var play_anim : String = "none"
@export var RELEASE : bool = false
@export var returnal : bool = false
@export var resetting : bool = false
@export var current_shakes : int = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var outliner: AnimationPlayer = $Outliner
@onready var cup_body_3d: AnimatableBody3D = $Cup/CupBody3D
@onready var lid_collider: CollisionShape3D = $Cup/CupBody3D/lid_collider
@onready var lid_collider_timer: Timer = $LidColliderTimer
@onready var release_timer: Timer = $ReleaseTimer
@onready var returnal_timer: Timer = $ReturnalTimer


var outlined : bool = false
var back_to_normal : bool = true

func release_on_that_thang() -> void:
	RELEASE = true
	animation_player.play("lid_off_after_shake")
	lid_collider_timer.start()

	#cup_body_3d.set_collision_layer_value(1, false)
	#cup_body_3d.set_collision_mask_value(1, false)
	
	

func _process(delta: float) -> void:
	if play_anim == "reload_die":
		lid_collider.disabled = true
		animation_player.play("reload_die")
		back_to_normal = false
		if outlined:
			outliner.play("outlineoff")
			outlined = false
			if get_parent().input_handler.hovered_object == "dicecup":
				get_parent().input_handler.hovered_object = "none"
		play_anim = "none"
	if play_anim == "locked_in":
		animation_player.play_backwards("reload_die")
		play_anim = "none"
	if play_anim == "lid_off":
		play_anim = "none"
	if play_anim == "shake":
		animation_player.play("shake")
		lid_collider.disabled = false
		play_anim = "none"
	if play_anim == "none":
		pass
	if RELEASE:
		#lid_body.set_collision_layer_value(1, false)
		#lid_body.set_collision_mask_value(1, false)
		#position = lerp(position, Vector3(3, 12, -1), delta * 2)
		#rotation = lerp(rotation, Vector3(rotation.x, rotation.y, rotation.z + 1), delta * 0.5)
		pass
	if returnal:
		rotation = lerp(rotation, Vector3(0, 0, 0), delta)
		position = lerp(position, Vector3(position.x, position.y + 2, position.z), delta * 2)
	if resetting:
		rotation = Vector3(0, 0, 0)
		position = Vector3(0, 0, 0)
		animation_player.play("RESET")
		resetting = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shake":
		current_shakes += 1
		if !GameManager.has_pressed_release or current_shakes < 2 or !GameManager.has_pressed_release and current_shakes >= 2:
			animation_player.play("shake")
			
		if GameManager.has_pressed_release and current_shakes >= 2:
			current_shakes = 0
			play_anim = "none"
			release_on_that_thang()
			get_tree().call_group("dice_logic", "throw")
			get_parent().current_state = -1
			release_timer.start()
	if anim_name == "shake_backwards":
		animation_player.play("shake")


func _on_static_body_3d_mouse_entered() -> void:
	if back_to_normal:
		outliner.play("outlineon")
		outlined = true
		get_parent().input_handler.hovered_object = "dicecup"

func _on_static_body_3d_mouse_exited() -> void:
	outliner.play("outlineoff")
	outlined = false
	if get_parent().input_handler.hovered_object == "dicecup":
		get_parent().input_handler.hovered_object = "none"


func _on_lid_collider_timer_timeout() -> void:
	lid_collider.disabled = true


func _on_release_timer_timeout() -> void:
	get_parent().animation_player.play("cup_respawn")
	returnal = true
	RELEASE = false
	#cup_body_3d.set_collision_layer_value(1, true)
	#cup_body_3d.set_collision_mask_value(1, true)
	back_to_normal = true
	get_parent().current_state = 0
	resetting = true
	GameManager.has_pressed_release = false
	returnal_timer.start()
	

func _on_returnal_timer_timeout() -> void:
	returnal = false
