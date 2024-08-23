extends Area2D

func _on_body_entered(body)-> void:
	queue_free()
	var coins := get_tree().get_nodes_in_group("Coins")
	if coins.size() == 1:
		Events.level_completed.emit()
