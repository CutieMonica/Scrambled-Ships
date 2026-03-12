extends MultiMeshInstance3D

var mesh_instances : Array = []

func get_meshes() -> void:
	for child in get_parent().get_children():
		if child is MeshInstance3D:
			mesh_instances.append(child)
