extends Node3D

var statue_combiner : PackedScene = load("uid://bi60iqmoecgti")
var statue_instance : Node3D
@export var shop_slot : int = 0

func spawn_statue() -> void:
	if get_parent().get_parent().get_parent().statue_shop_slots_unlocked < shop_slot:
		return
		
	statue_instance = statue_combiner.instantiate()
	get_parent().get_parent().get_parent().statues_created += 1
	statue_instance.name = "Statue" + str(get_parent().get_parent().get_parent().statues_created)
	add_child(statue_instance)
	get_parent().get_parent().get_parent().shop_items.set(shop_slot, statue_instance)
	statue_instance.create_statue()
	statue_instance.reparent(get_parent())
