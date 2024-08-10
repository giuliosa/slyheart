extends MarginContainer

@onready var start_game = %StartGame
@onready var quit = %Quit

func _ready():
	start_game.grab_focus()
	pass

func _on_start_game_pressed():
	#await LevelTransition.fade_out()
	get_tree().change_scene_to_file("res://Scenes/level_one.tscn")
	LevelTransition.fade_in()


func _on_quit_pressed():
	get_tree().quit()
