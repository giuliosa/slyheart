extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = direction * 200
	move_and_slide()
