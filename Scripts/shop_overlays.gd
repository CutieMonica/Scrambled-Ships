extends Control
@onready var passive_overlay_dissolve: AnimationPlayer = $PassiveOverlayDissolve
@onready var ui_animations: AnimationPlayer = $UIAnimations
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var buy_button: TextureButton = $BuyButton

var focused_item_slot : int
var buying_item : String

@onready var item_name: Label = $DescriptionPaper/ItemName
@onready var item_rarity: Label = $DescriptionPaper/ItemRarity
@onready var item_description: Label = $DescriptionPaper/ItemDescription
@onready var item_tagline: Label = $DescriptionPaper/ItemTagline

func slide_in_UI(new_item_name : String, new_item_tagline : String, new_item_rarity : String, new_item_description : String, new_focused_item_slot : int) -> void:
	ui_animations.play("slide_in_shop")
	passive_overlay_dissolve.play("PassiveLoop")
	item_name.text = new_item_name
	item_rarity.text = new_item_rarity
	item_description.text = new_item_description
	item_tagline.text = new_item_tagline
	focused_item_slot = new_focused_item_slot
	audio_stream_player.stream = SfxBank.slide_in
	get_parent().shop_box.exit_button_can_be_enabled = false
	get_parent().shop_box.disable_exit_button()
	audio_stream_player.play()
	await ui_animations.animation_finished
	if get_parent().shop_prices.get(focused_item_slot) > GameManager.current_money:
		buy_button.disabled = true
	if get_parent().shop_prices.get(focused_item_slot) <= GameManager.current_money:
		buy_button.disabled = false

func slide_out_UI() -> void:
	audio_stream_player.stream = SfxBank.slide_out
	audio_stream_player.play()
	ui_animations.play_backwards("slide_in_shop")
	get_parent().shop_slot_zoom_out(focused_item_slot)
	get_parent().shop_box.exit_button_can_be_enabled = true
	get_parent().shop_box.temp_disable_exit_button()
	
	

func _on_cancel_button_pressed() -> void:
	slide_out_UI()

func _on_buy_button_pressed() -> void:
	if get_parent().shop_prices.get(focused_item_slot) <= GameManager.current_money:
		slide_out_UI()
		get_parent().update_money(get_parent().shop_prices.get(focused_item_slot))
		get_parent().shop_prices.set(focused_item_slot, null)
		get_parent().shop_placement_references.get(focused_item_slot).price_tag.delete_price_tag()
		if focused_item_slot == 0:
			return
		if focused_item_slot >= 1 and focused_item_slot <= 5:
			buying_item = "Dice"
			get_parent().shop_items.get(focused_item_slot).dice_logic.purchase_die()
		if focused_item_slot >= 6 and focused_item_slot <= 7:
			buying_item = "Ticket"
			get_parent().shop_items.get(focused_item_slot).purchase_ticket()
			
		if focused_item_slot >= 8 and focused_item_slot <= 9:
			buying_item = "Statue"
			get_parent().shop_items.get(focused_item_slot).purchase_statue()
			
		if focused_item_slot >= 10:
			buying_item = "Card"
			get_parent().shop_items.get(focused_item_slot).card_logic.purchase_card()
		get_parent().shop_items.set(focused_item_slot, null)
		get_parent().shop_box.disable_exit_button()
		
