extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		restart_game()

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
