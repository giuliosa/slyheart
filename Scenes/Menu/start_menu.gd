extends MarginContainer

@onready var start_game := %StartGame
@onready var quit := %Quit

func _ready()-> void:
	start_game.grab_focus()
	pass

func _on_start_game_pressed()-> void:
	#await LevelTransition.fade_out()
	get_tree().change_scene_to_file("res://Scenes/level_one.tscn")
	LevelTransition.fade_in()


func _on_quit_pressed()-> void:
	get_tree().quit()
