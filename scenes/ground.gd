extends StaticBody2D

var speed : float = 150.0

func _physics_process(delta: float) -> void:
	position.x -= Global.platform_speed * delta
