extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().paused = true
		get_tree().current_scene.get_node("CanvasLayer2/LabelGO").visible = true
		
