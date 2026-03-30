extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shop_generate_timer: Timer = $ShopGenerateTimer
@onready var move_nametag: AnimationPlayer = $MoveNametag
@onready var leave_shop_highlight: MeshInstance3D = $LeaveShop/LeaveShopHighlight
@onready var shop_clear_timer: Timer = $ShopClearTimer
@onready var money_tracker: Node3D = $MoneyTracker
@onready var shop_reroll_timer: Timer = $ShopRerollTimer
@onready var leave_shop_collider: CollisionShape3D = $LeaveShop/MouseDetect/LeaveShopCollider
@onready var exit_button_timer: Timer = $ExitButtonTimer
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var exit_button_can_be_enabled : bool = false

func play_shop_reload() -> void:
	animation_player.play("lidflip")
	shop_generate_timer.start()

func shop_reroll() -> void:
	temp_disable_exit_button()
	move_nametag.play_backwards("move_nametag")
	animation_player.play_backwards("lidflip")
	shop_reroll_timer.start()
	await shop_reroll_timer.timeout
	get_parent().clear_shop_items()
	animation_player.stop()
	play_shop_reload()

func exit_shop() -> void:
	if !get_parent().camera_movement.is_playing() and InputHandler.hovered_object == "shop_leave":
		audio_stream_player.stream = SfxBank.slide_in
		audio_stream_player.play()
		move_nametag.play_backwards("move_nametag")
		animation_player.play_backwards("lidflip")
		#delete all shop items NOW
		
		get_parent().round_start()
		shop_clear_timer.start()

func _on_shop_generate_timer_timeout() -> void:
	get_parent().generate_shop()
	await get_tree().process_frame
	move_nametag.play("move_nametag")
	exit_button_can_be_enabled = true


func _on_mouse_detect_mouse_entered() -> void:
	if get_parent().between_rounds == true:
		InputHandler.hovered_object = "shop_leave"
		leave_shop_highlight.visible = true
		

func _on_mouse_detect_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_leave":
		InputHandler.hovered_object = "none"
	leave_shop_highlight.visible = false


func _on_shop_clear_timer_timeout() -> void:
	get_parent().clear_shop_items()
	
func disable_exit_button() -> void:
	leave_shop_collider.disabled = true
	
func enable_exit_button() -> void:
	if exit_button_can_be_enabled == true:
		leave_shop_collider.disabled = false

func temp_disable_exit_button() -> void:
	leave_shop_collider.disabled = true
	exit_button_timer.start()
	await exit_button_timer.timeout
	if exit_button_can_be_enabled == true:
		leave_shop_collider.disabled = false
