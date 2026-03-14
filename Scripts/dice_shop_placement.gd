extends Node3D
@onready var price_tag: Node3D = $PriceTag

func _ready() -> void:
	price_tag.visible = false

func show_price() -> void:
	price_tag.visible = true
	
