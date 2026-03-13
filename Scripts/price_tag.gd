extends Node3D

var price : int = 0
@onready var label_3d: Label3D = $Pricetag/Label3D

func inflation_is_a_bitch(new_price : int) -> void:
	price = new_price
	label_3d.text = ("$" + str(price))
	
