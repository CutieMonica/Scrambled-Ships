extends Node3D

@export var shop_slot_hovered : int = 0

@onready var highlight_1: MeshInstance3D = $ShopPlacementArea1/Highlight1
@onready var highlight_2: MeshInstance3D = $ShopPlacementArea2/Highlight2
@onready var highlight_3: MeshInstance3D = $ShopPlacementArea3/Highlight3
@onready var highlight_4: MeshInstance3D = $ShopPlacementArea4/Highlight4
@onready var highlight_5: MeshInstance3D = $ShopPlacementArea5/Highlight5
@onready var highlight_6: MeshInstance3D = $ShopPlacementArea6/Highlight6
@onready var highlight_7: MeshInstance3D = $ShopPlacementArea7/Highlight7
@onready var highlight_8: MeshInstance3D = $ShopPlacementArea8/Highlight8
@onready var highlight_9: MeshInstance3D = $ShopPlacementArea9/Highlight9
@onready var highlight_10: MeshInstance3D = $ShopPlacementArea10/Highlight10
@onready var highlight_11: MeshInstance3D = $ShopPlacementArea11/Highlight11
@onready var highlight_12: MeshInstance3D = $ShopPlacementArea12/Highlight12

var highlights : Dictionary = {}

func _ready() -> void:
	highlights = {
		1: highlight_1,
		2: highlight_2,
		3: highlight_3,
		4: highlight_4,
		5: highlight_5,
		6: highlight_6,
		7: highlight_7,
		8: highlight_8,
		9: highlight_9,
		10: highlight_10,
		11: highlight_11,
		12: highlight_12
	}


func _on_shop_placement_area_1_mouse_entered() -> void:
	shop_slot_hovered = 1
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_1"
	change_highlight(1)
	
func _on_shop_placement_area_1_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_1":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 1:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_2_mouse_entered() -> void:
	shop_slot_hovered = 2
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_2"
	
	change_highlight(2)

func _on_shop_placement_area_2_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_2":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 2:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_3_mouse_entered() -> void:
	shop_slot_hovered = 3
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_3"
	
	change_highlight(3)

func _on_shop_placement_area_3_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_3":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 3:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_4_mouse_entered() -> void:
	shop_slot_hovered = 4
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_4"
	
	change_highlight(4)

func _on_shop_placement_area_4_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_4":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 4:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_5_mouse_entered() -> void:
	shop_slot_hovered = 5
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_5"
	
	change_highlight(5)

func _on_shop_placement_area_5_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_5":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 5:
		shop_slot_hovered = 0
		change_highlight(0)

func _on_shop_placement_area_6_mouse_entered() -> void:
	shop_slot_hovered = 6
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_6"
	
	change_highlight(6)

func _on_shop_placement_area_6_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_6":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 6:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_7_mouse_entered() -> void:
	shop_slot_hovered = 7
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_7"
	
	change_highlight(7)

func _on_shop_placement_area_7_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_7":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 7:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_8_mouse_entered() -> void:
	shop_slot_hovered = 8
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_8"
	
	change_highlight(8)

func _on_shop_placement_area_8_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_8":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 8:
		shop_slot_hovered = 0
		change_highlight(0)

func _on_shop_placement_area_9_mouse_entered() -> void:
	shop_slot_hovered = 9
	
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_9"
	change_highlight(9)

func _on_shop_placement_area_9_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_9":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 9:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_10_mouse_entered() -> void:
	shop_slot_hovered = 10
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_10"
	
	change_highlight(10)

func _on_shop_placement_area_10_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_10":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 10:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_11_mouse_entered() -> void:
	shop_slot_hovered = 11
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_11"
	
	change_highlight(11)

func _on_shop_placement_area_11_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_11":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 11:
		shop_slot_hovered = 0
		change_highlight(0)


func _on_shop_placement_area_12_mouse_entered() -> void:
	shop_slot_hovered = 12
	if get_parent().shop_items.get(shop_slot_hovered) == null:
		return
	InputHandler.hovered_object = "shop_slot_12"
	
	change_highlight(12)

func _on_shop_placement_area_12_mouse_exited() -> void:
	if InputHandler.hovered_object == "shop_slot_12":
		InputHandler.hovered_object = "none"
	if shop_slot_hovered == 12:
		shop_slot_hovered = 0
		change_highlight(0)

func change_highlight(number : int) -> void:
	for i : int in highlights:
		highlights.get(i).visible = false
	if number == 0:
		return
	highlights.get(number).visible = true
	
