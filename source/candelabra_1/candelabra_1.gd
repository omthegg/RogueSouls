extends Node3D


func _ready() -> void:
	var multimesh:MultiMesh = $MultiMeshInstance3D.multimesh
	
	multimesh.set_instance_transform(0, Transform3D(
		Basis(), Vector3(0, 0.57, 0)))
	
	multimesh.set_instance_transform(1, Transform3D(
		Basis(), Vector3(0.074, 0.49, 0.074)))
	
	multimesh.set_instance_transform(2, Transform3D(
		Basis(), Vector3(-0.074, 0.49, 0.074)))
	
	multimesh.set_instance_transform(3, Transform3D(
		Basis(), Vector3(0.074, 0.49, -0.074)))
	
	multimesh.set_instance_transform(4, Transform3D(
		Basis(), Vector3(-0.074, 0.49, -0.074)))
