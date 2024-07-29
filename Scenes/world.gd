extends Node2D

@export var next_level: PackedScene

@onready var level_completed = $Node/LevelCompleted
@onready var camera_2d = $Camera2D
@onready var player = $Player

func _ready():
	RenderingServer.set_default_clear_color(Color.DIM_GRAY)
	Events.level_completed.connect(show_level_completed)
	player.follow_camera(camera_2d)

func show_level_completed():
	level_completed.show()
	get_tree().paused = true
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	LevelTransition.fade_from_black()
