extends CharacterBody3D

func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y < -10:
		suicide()

func suicide():
	queue_free()
