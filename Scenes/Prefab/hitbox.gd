extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if owner.has_method("must_die"):
			owner.queue_free()
		body.velocity.y = -body.jump_velocity
