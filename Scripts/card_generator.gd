extends Node3D

var rarity : Array = [1, 2, 3, 4]
@export var weight_probabilities : Array = [10, 5, 2, 0.5]
var card_choice : PackedScene

#every card
var bomb_card := load("uid://dgpdr61xocghe")
var bob_card := load("res://Scenes/Cards/BobCard.tscn")
var wheel_of_fortune_card := load("uid://6bq38k2ugok3")
var reverse_card := load("res://Scenes/Cards/ReverseCard.tscn")

var common_cards: Dictionary = {
	1: bomb_card,
	2: wheel_of_fortune_card
}

var uncommon_cards: Dictionary = {
	1: bob_card
}

var rare_cards: Dictionary = {
	1: reverse_card
}

var card_instance : Node3D
@export var shop_slot : int = 0
@export var card_rarity : String
@export var card_price : int

func spawn_card() -> void:
	if get_parent().get_parent().get_parent().card_shop_slots_unlocked < shop_slot:
		return
	var random_weight := GameManager.rng_shops
	var random_value : int = rarity[random_weight.rand_weighted(weight_probabilities)]

	match random_value:
		1:
			card_rarity = "common"
			card_choice = common_cards.get(GameManager.rng_shops.randi_range(1, common_cards.size()))
			card_price = 2
		2:
			card_rarity = "uncommon"
			card_choice = uncommon_cards.get(GameManager.rng_shops.randi_range(1, uncommon_cards.size()))
			card_price = 4
		3:
			card_rarity = "rare"
			card_choice = rare_cards.get(GameManager.rng_shops.randi_range(1, rare_cards.size()))
			card_price = 6
		4:
			#dice_rarity = "legendary"
			#dice_choice = legendary_dice.get(GameManager.rng_shops.randi_range(1, legendary_dice.size()))
			#dice_price = 8
			spawn_card()
			return
	card_instance = card_choice.instantiate()
	card_instance.name = "Card" + str(shop_slot)
	get_parent().price_tag.inflation_is_a_bitch(card_price)
	get_parent().show_price()
	add_child(card_instance)
	get_parent().get_parent().get_parent().shop_items.set(shop_slot, card_instance)
	card_instance.reparent(get_parent())
